//
//  MyPostDraftViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyPostDraftViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
//#import "PostDraftTableCell.h"
#import "NewPostDraftTableCell.h"
#import "Forum.h"
#import "SVProgressHUD.h"
#import "SendPostViewController.h"
#import "MGSwipeButton.h"

NSString *const kPostDraftCellIndentifier = @"NewPostDraftTableCell";

@interface MyPostDraftViewController ()<UITableViewDataSource, UITableViewDelegate,MGSwipeTableCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* postDraftArray;
@end

@implementation MyPostDraftViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"草稿箱";
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPostDraftTableCell" bundle:nil] forCellReuseIdentifier:kPostDraftCellIndentifier];
    self.view.backgroundColor = RGBHex(qwColor11);
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllDrafts)];
}

- (void)deleteAllDrafts
{
    [QWPostDrafts deleteAllObjFromDB];
    [self p_reloadTableData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self p_reloadTableData];
}

- (NSArray *)postDraftArray
{
    NSArray* draftArray = [QWPostDrafts getArrayFromDBWithWhere:[NSString stringWithFormat:@"passPort = '%@'", QWGLOBALMANAGER.configure.expertPassportId]];
    if ([draftArray isKindOfClass:[NSArray class]]) {
        _postDraftArray = draftArray;
        return _postDraftArray;
    }
    return nil;
}

- (void)p_reloadTableData
{
    if (self.postDraftArray.count == 0) {
        [self showInfoView:@"暂无草稿" image:@"ic_img_fail"];
    }else{
        [self removeInfoView];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _postDraftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPostDraftTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kPostDraftCellIndentifier forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    cell.swipeDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kPostDraftCellIndentifier configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
//    return [tableView fd_heightForCellWithIdentifier:@"PostDraftTableCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        [self configure:cell indexPath:indexPath];
//    }];
}

- (void)configure:(NewPostDraftTableCell*)cell indexPath:(NSIndexPath*)indexPath
{
    QWPostDrafts* postDraft = [_postDraftArray objectAtIndex:indexPath.row];
    [cell setCell:postDraft];
}


#pragma mark ---- MGSwipeTableCellDelegate ----

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons:1];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = nil;
    if (index == 0) {
        indexPath = [self.tableView indexPathForCell:cell];
        
        if (indexPath.row < _postDraftArray.count) {
            QWPostDrafts* postDraft = [_postDraftArray objectAtIndex:indexPath.row];
            if ([postDraft deleteToDB]) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
                [self p_reloadTableData];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"删除失败!"];
            }
            
        }
        
    }
    return YES;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[1] = {@"删除"};
    UIColor * colors[1] = {RGBHex(qwColor3)};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < self.postDraftArray.count) {
        QWPostDrafts* postDraft = self.postDraftArray[row];
        SendPostViewController* sendPostVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"SendPostViewController"];
        sendPostVC.hidesBottomBarWhenPushed = YES;
        // 保存在草稿箱的进入发帖，只要已经选择了圈子就隐藏起来
        sendPostVC.needChooseCircle = !(postDraft.postStatus == PostStatusType_Editing) && (postDraft.sendCircle == nil);

        sendPostVC.postStatusType = postDraft.postStatus;
        
        sendPostVC.postDetail = postDraft.postDetail;
        sendPostVC.sendCircle = postDraft.sendCircle;
        sendPostVC.reminderExpertArray = [NSMutableArray arrayWithArray:postDraft.reminderExperts];
        [self.navigationController pushViewController:sendPostVC animated:YES];
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifSendPostResult) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"apiStatus"] integerValue] == 0) {
                [self p_reloadTableData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"发帖失败!"];
            }
        }
    }
    if (type == NotifLoginSuccess || type == NotifQuitOut) {
        [self p_reloadTableData];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

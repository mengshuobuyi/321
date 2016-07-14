//
//  ReplyPostHistoryViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ReplyPostHistoryViewController.h"
#import "ReplyPostTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Forum.h"
#import "PostDetailViewController.h"
#import "SVProgressHUD.h"
#import "MGSwipeButton.h"
@interface ReplyPostHistoryViewController ()<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* postReplyArray;
@end

@implementation ReplyPostHistoryViewController
{
    NSInteger pageIndex;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的回帖";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.postReplyArray.count == 0) {
        [self loadData];
    }
}

- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ReplyPostTableCell" bundle:nil] forCellReuseIdentifier:@"ReplyPostTableCell"];
    
    __weak __typeof(self)weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        [weakSelf.tableView.footer setCanLoadMore:YES];
        pageIndex = 0;
        [weakSelf.postReplyArray removeAllObjects];
        [weakSelf loadData];
    }];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadData)];
}

- (void)loadData
{
    GetMyPostReplyListR* getMyPostReplyListR = [GetMyPostReplyListR new];
    getMyPostReplyListR.token = self.token;
    getMyPostReplyListR.page = pageIndex + 1;
    getMyPostReplyListR.pageSize = 10;
    [Forum getMyPostReplyList:getMyPostReplyListR success:^(NSArray *postReplyList) {
        if (postReplyList.count > 0) {
            [self.postReplyArray addObjectsFromArray:postReplyList];
            pageIndex ++;
            [self.tableView reloadData];
        }
        if (pageIndex == 0 && postReplyList.count == 0) {
            [self showInfoView:@"您还没有回过帖子" image:@"ic_img_fail"];
        }
        else
        {
            [self removeInfoView];
        }

        if (postReplyList.count < 10) {
            [self.tableView.footer setCanLoadMore:NO];
        }
        else
        {
            [self.tableView.footer setCanLoadMore:YES];
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(HttpException *e) {
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        DebugLog(@"get my post reply list error : %@", e);
    }];
}

- (NSMutableArray *)postReplyArray
{
    if (!_postReplyArray) {
        _postReplyArray = [NSMutableArray array];
    }
    return _postReplyArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postReplyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyPostTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyPostTableCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    cell.swipeDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ReplyPostTableCell" configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.postReplyArray.count) {
        QWPostReply* postReply = self.postReplyArray[indexPath.row];
        PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
        postDetailVC.hidesBottomBarWhenPushed = YES;
        postDetailVC.postId = postReply.postId;
        [self.navigationController pushViewController:postDetailVC animated:YES];
    }
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    QWPostReply* postReply = self.postReplyArray[indexPath.row];
    [cell setCell:postReply];
}

#pragma mark ---- MGSwipeTableCellDelegate  start  ----

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
        if (indexPath.row < self.postReplyArray.count) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除该回帖吗？一经删除，不可恢复哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            alertView.tag = indexPath.row;
            [alertView show];
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

#pragma mark ---- MGSwipeTableCellDelegate  end  ----

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"网络异常,请稍后重试" duration:DURATION_SHORT];
            return;
        }
        NSInteger index = alertView.tag;
        if (index < self.postReplyArray.count) {
            QWPostReply* postReply = self.postReplyArray[index];
            DeletePostReplyR* deletePostReplyR = [DeletePostReplyR new];
            deletePostReplyR.token = QWGLOBALMANAGER.configure.userToken;
            deletePostReplyR.replyID = postReply.id;
            deletePostReplyR.replyerID = postReply.replier;
            //            deletePostReplyR.teamID = postReply.
            [Forum deletePostReply:deletePostReplyR success:^(BaseAPIModel *baseAPIModel) {
                if ([baseAPIModel.apiStatus integerValue] == 0) {
                    NSString* successMessage = StrIsEmpty(baseAPIModel.apiMessage) ? @"删除成功!" : baseAPIModel.apiMessage;
                    [SVProgressHUD showSuccessWithStatus:successMessage];
                }
                else
                {
                    NSString* errorMessage = StrIsEmpty(baseAPIModel.apiMessage) ? @"删除失败!" : baseAPIModel.apiMessage;
                    [SVProgressHUD showErrorWithStatus:errorMessage];
                }
            } failure:^(HttpException *e) {
                DebugLog(@"delete post reply error : %@", e);
            }];
        }
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

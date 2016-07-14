//
//  SendPostHistoryViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SendPostHistoryViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PostInCircleTableCell.h"
#import "PostDetailViewController.h"
#import "Forum.h"
#import "MGSwipeButton.h"
#import "SVProgressHUD.h"
#define SendPostHistoryPageSize 10
@interface SendPostHistoryViewController ()<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* postArray;

@end

@implementation SendPostHistoryViewController
{
    NSInteger pageIndex;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的发帖";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PostInCircleTableCell" bundle:nil] forCellReuseIdentifier:@"PostInCircleTableCell"];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (NSMutableArray *)postArray
{
    if (!_postArray) {
        _postArray = [NSMutableArray array];
    }
    return _postArray;
}

- (void)loadData
{
    pageIndex = 0;
    GetMyPostListR* getMyPostListR = [GetMyPostListR new];
    getMyPostListR.token = self.token;
    getMyPostListR.page = pageIndex + 1;
    getMyPostListR.pageSize = SendPostHistoryPageSize;
    [Forum getMyPostList:getMyPostListR success:^(NSArray *postList) {
        if (pageIndex == 0) {
            [self.postArray removeAllObjects];
        }
        if (pageIndex == 0 && postList.count == 0) {
            [self showInfoView:@"您还没有发过帖子" image:@"ic_img_fail"];
        }
        if (postList.count > 0) {
            pageIndex++;
            [self removeInfoView];
        }
        [self.postArray addObjectsFromArray:postList];
        [self.tableView setCanCancelContentTouches:(postList.count == SendPostHistoryPageSize)];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(HttpException *e) {
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        DebugLog(@"getMyPostList error : %@", e);
    }];
}

- (void)loadMoreData
{
    GetMyPostListR* getMyPostListR = [GetMyPostListR new];
    getMyPostListR.token = self.token;
    getMyPostListR.page = pageIndex + 1;
    getMyPostListR.pageSize = SendPostHistoryPageSize;
    [Forum getMyPostListWithoutProgress:getMyPostListR success:^(NSArray *postList) {
        if (postList.count > 0) {
            pageIndex++;
        }
        [self.postArray addObjectsFromArray:postList];
        [self.tableView setCanCancelContentTouches:(postList.count == SendPostHistoryPageSize)];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(HttpException *e) {
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        DebugLog(@"getMyPostList error : %@", e);
    }];
}

- (void)configTableView
{
    __weak __typeof(self) weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        [weakSelf loadData];
    }];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostInCircleTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostInCircleTableCell" forIndexPath:indexPath];
    cell.postCellType = PostCellType_MineSendPost;
    [self configure:cell indexPath:indexPath];
    cell.swipeDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"PostInCircleTableCell" configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QWPostModel* postModel = self.postArray[indexPath.row];
    PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    postDetailVC.hidesBottomBarWhenPushed = YES;
    postDetailVC.postId = postModel.postId;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    QWPostModel* postModel = self.postArray[indexPath.row];
    [cell setCell:postModel];
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
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"网络异常,请稍后重试" duration:DURATION_SHORT];
            return NO;
        }
        indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath.row < self.postArray.count) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除该帖子吗？一经删除，不可恢复哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSInteger index = alertView.tag;
        if (index < self.postArray.count) {
            QWPostModel* postModel = self.postArray[index];
            DeletePostInfoR* deletePostInfoR = [DeletePostInfoR new];
            deletePostInfoR.token = QWGLOBALMANAGER.configure.expertToken;
            deletePostInfoR.poster = QWGLOBALMANAGER.configure.expertPassportId;
            deletePostInfoR.postId = postModel.postId;
            deletePostInfoR.teamId = postModel.teamId;
            deletePostInfoR.postTitle = postModel.postTitle;
            
            [Forum delPostInfo:deletePostInfoR success:^(BaseAPIModel *baseAPIModel) {
                if ([baseAPIModel.apiStatus integerValue] == 0) {
                    [QWGLOBALMANAGER postNotif:NotifDeletePostSuccess data:nil object:nil];
                    [SVProgressHUD showSuccessWithStatus:@"帖子删除成功!"];
                    pageIndex = 0;
                    [self.tableView.footer setCanLoadMore:YES];
                    [self loadData];
                    
                }
                else
                {
                    NSString* errorMessage = StrIsEmpty(baseAPIModel.apiMessage) ? @"删除失败!" : baseAPIModel.apiMessage;
                    [SVProgressHUD showErrorWithStatus:errorMessage];
                }
            } failure:^(HttpException *e) {
                DebugLog(@"delete post error : %@", e);
            }];
        }
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (NotifDeletePostSuccess == type) {
        [self loadData];
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


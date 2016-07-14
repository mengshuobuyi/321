//
//  HotPostViewController.m
//  APP
//
//  Created by Martin.Liu on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "HotPostViewController.h"
#import "PostTableCell.h"
#import "AllCircleViewController.h"             // 全部圈子
#import "PostDetailViewController.h"            // 帖子详情
#import "SendPostViewController.h"              // 发帖
#import "CircleDetailViewController.h"               // 圈子
#import "UITableView+FDTemplateLayoutCell.h"
// 通告用到的
#import "AutoScrollView.h"
#import "ActivityModel.h"

#import "Forum.h"
#import "LoginViewController.h"
@interface HotPostViewController ()<UITableViewDataSource, UITableViewDelegate, AutoScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *firstCircleImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstCircleTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstCircleSubTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *secondCircleImageView;
@property (strong, nonatomic) IBOutlet UILabel *secondCircleTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondCircleSubTitleLabel;

@property (strong, nonatomic) IBOutlet AutoScrollView *noticeScrollView;
@property (nonatomic, strong) NSArray* cirCleArray;   // 两个圈子
@property (nonatomic, strong) NSArray* noticePushArray;   // 两个圈子
- (IBAction)allCircleBtnAction:(id)sender;
- (IBAction)firstCircleBtnAction:(id)sender;
- (IBAction)secondCircleBtnAction:(id)sender;
- (IBAction)sendPostBtnAction:(id)sender;

@end

@implementation HotPostViewController
{
    NSMutableArray* titleArray;
    NSArray* postArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = [NSMutableArray array];
    self.tableView.backgroundColor = RGBHex(qwColor11);
    
    [self setupTableView];
    [self loadData];
}

- (void)UIGlobal
{
    self.noticeScrollView.delegate = self;
    self.noticeScrollView.ButtonColor = RGBHex(qwColor8);
    [self.noticeScrollView setupView];
    
    self.firstCircleImageView.layer.masksToBounds = YES;
    self.firstCircleImageView.layer.cornerRadius = CGRectGetHeight(self.firstCircleImageView.frame)/2;
    self.secondCircleImageView.layer.masksToBounds = YES;
    self.secondCircleImageView.layer.cornerRadius = CGRectGetHeight(self.secondCircleImageView.frame)/2;
    self.firstCircleTitleLabel.font= self.secondCircleTitleLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.firstCircleTitleLabel.textColor = self.secondCircleTitleLabel.textColor = RGBHex(qwColor6);
    self.firstCircleSubTitleLabel.font = self.secondCircleSubTitleLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.firstCircleSubTitleLabel.textColor = self.secondCircleSubTitleLabel.textColor = RGBHex(qwColor8);
}

- (void) loadData
{
    GetHotPostR* getHotPost = [GetHotPostR new];
    getHotPost.token = QWGLOBALMANAGER.configure.expertToken;
    getHotPost.page = 1;
    getHotPost.pageSize = 50;
    [Forum gethotPost:getHotPost success:^(QWCircleHotInfo *responModel) {
        [self removeInfoView];
        if ([responModel.apiStatus integerValue] == 0) {
            QWCircleHotInfo* circleHotInfo = responModel;
            postArray = circleHotInfo.postInfoList;
            self.cirCleArray = circleHotInfo.teamList;
            self.noticePushArray = circleHotInfo.noticePushList;
            [self.tableView reloadData];
            [self endHeaderRefresh];
        }
    } failure:^(HttpException *e) {
        [self endHeaderRefresh];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
        DebugLog(@"getTeamHot error : %@", e);
    }];
}

- (void) loadMoreData
{
    GetHotPostR* getHotPost = [GetHotPostR new];
    getHotPost.token = QWGLOBALMANAGER.configure.expertToken;
    getHotPost.page = 1;
    getHotPost.pageSize = 50;
    [Forum gethotPostWithoutProgress:getHotPost success:^(QWCircleHotInfo *responModel) {
        [self removeInfoView];
        if ([responModel.apiStatus integerValue] == 0) {
            QWCircleHotInfo* circleHotInfo = responModel;
            postArray = circleHotInfo.postInfoList;
            self.cirCleArray = circleHotInfo.teamList;
            self.noticePushArray = circleHotInfo.noticePushList;
            [self.tableView reloadData];
            [self endHeaderRefresh];
        }
    } failure:^(HttpException *e) {
        [self endHeaderRefresh];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
        DebugLog(@"getTeamHot error : %@", e);
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self loadData];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"PostTableCell" bundle:nil] forCellReuseIdentifier:@"PostTableCell"];
    __weak __typeof(self) weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        [weakSelf loadData];
    }];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (void)setCirCleArray:(NSArray *)cirCleArray
{
    _cirCleArray = cirCleArray;
    if (cirCleArray.count > 0) {
        QWCircleModel* firstCircle = cirCleArray[0];
        [self.firstCircleImageView setImageWithURL:[NSURL URLWithString:firstCircle.teamLogo] placeholderImage:ForumDefaultImage];
        self.firstCircleTitleLabel.text = firstCircle.teamName;
        if (firstCircle.master > 0) {
            self.firstCircleSubTitleLabel.text = [NSString stringWithFormat:@"%ld个专家圈主", firstCircle.master];
        }
        else
        {
            self.firstCircleSubTitleLabel.text = @"暂无圈主";
        }
    }
    else
    {
        [self.firstCircleImageView setImage: ForumDefaultImage];
        self.firstCircleTitleLabel.text = nil;
        self.firstCircleSubTitleLabel.text = nil;
    }
    if (cirCleArray.count > 1) {
        QWCircleModel* secondCircle = cirCleArray[1];
        [self.secondCircleImageView setImageWithURL:[NSURL URLWithString:secondCircle.teamLogo] placeholderImage:ForumDefaultImage];
        self.secondCircleTitleLabel.text = secondCircle.teamName;
        if (secondCircle.master > 0) {
            self.secondCircleSubTitleLabel.text = [NSString stringWithFormat:@"%ld个专家圈主", secondCircle.master];
        }
        else
        {
            self.secondCircleSubTitleLabel.text = @"暂无圈主";
        }
    }
    else
    {
        [self.secondCircleImageView setImage: ForumDefaultImage];
        self.secondCircleTitleLabel.text = nil;
        self.secondCircleSubTitleLabel.text = nil;
    }
}

- (void)setNoticePushArray:(NSArray *)noticePushArray
{
    _noticePushArray = noticePushArray;
    [titleArray removeAllObjects];
    for (QWNoticePushModel* noticePushModel in _noticePushArray) {
        BranchActivityVo* notice = [[BranchActivityVo alloc] init];
        notice.title = noticePushModel.noticeTitle;
        [titleArray addObject:notice];
    }
    self.noticeScrollView.dataArray = titleArray;
    [self.noticeScrollView setupView];
}

#pragma mark - AutoScrollView Delegate
- (void)didSelectedButtonAtIndex:(NSInteger)index
{
    if (index < self.noticePushArray.count) {
        QWNoticePushModel* noticePushModel = self.noticePushArray[index];
        switch (noticePushModel.columnType) {
            case 1: // 外链

                break;
            case 10:  // 帖子详情
            {
                PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
                postDetailVC.hidesBottomBarWhenPushed = YES;
                postDetailVC.postId = noticePushModel.noticeContent;
                [self.navigationController pushViewController:postDetailVC animated:YES];
            }
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void) configure:(PostTableCell*)cell indexPath:(NSIndexPath*)indexPath
{
    QWPostModel* postModel = postArray[indexPath.row];
    cell.userInfoBtn.touchUpInsideBlock = ^{
        DebugLog(@"go to user detial : %@", postModel.posterId);
        // @property (nonatomic, assign) NSInteger posterType;     // 发帖人类型(1:普通用户, 2:马甲, 3:药师, 4:营养师),
    };
    [cell setCell:postModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"PostTableCell" configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < postArray.count) {
        QWPostModel* postModel =  postArray[indexPath.row];
        PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
        postDetailVC.hidesBottomBarWhenPushed = YES;
        postDetailVC.postId = postModel.postId;
        [self.navigationController pushViewController:postDetailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)allCircleBtnAction:(id)sender {
//    CircleDetailViewController* circleVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
//    circleVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:circleVC animated:YES];
    AllCircleViewController* allCirCleVC = (AllCircleViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"AllCircleViewController"];
    allCirCleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allCirCleVC animated:YES];
}

- (IBAction)firstCircleBtnAction:(id)sender {
    DebugLog(@"click first circle");
    if (self.cirCleArray.count < 1) {
        return;
    }
//    // 进入圈子详情
//    CircleDetailViewController* circleDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
//    circleDetailVC.hidesBottomBarWhenPushed = YES;
//    if (self.cirCleArray.count > 0) {
//        QWCircleModel* circleModel = self.cirCleArray[0];
//        circleDetailVC.circleId = circleModel.teamId;
//    }
//    [self.navigationController pushViewController:circleDetailVC animated:YES];
}

- (IBAction)secondCircleBtnAction:(id)sender {
    DebugLog(@"click second circle");
    if (self.cirCleArray.count < 2) {
        return;
    }
//    CircleDetailViewController* circleDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
//    circleDetailVC.hidesBottomBarWhenPushed = YES;
//    if (self.cirCleArray.count > 1) {
//        QWCircleModel* circleModel = self.cirCleArray[1];
//        circleDetailVC.circleId = circleModel.teamId;
//    }
//
//    [self.navigationController pushViewController:circleDetailVC animated:YES];
}

- (IBAction)sendPostBtnAction:(id)sender {
    if(!QWGLOBALMANAGER.loginStatus) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//        loginViewController.isPresentType = YES;
//        loginViewController.loginSuccessBlock = ^{
//            SendPostViewController* sendPostVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"SendPostViewController"];
//            sendPostVC.hidesBottomBarWhenPushed = YES;
//            sendPostVC.needChooseCircle = YES;
//            [self.navigationController pushViewController:sendPostVC animated:YES];
//        };
//        [self presentViewController:navgationController animated:YES completion:NULL];
        return;
    }
    SendPostViewController* sendPostVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"SendPostViewController"];
    sendPostVC.hidesBottomBarWhenPushed = YES;
    sendPostVC.needChooseCircle = YES;
    [self.navigationController pushViewController:sendPostVC animated:YES];
}
@end

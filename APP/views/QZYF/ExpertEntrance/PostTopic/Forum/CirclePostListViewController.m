//
//  CirclePostListViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CirclePostListViewController.h"
#import "PostInCircleTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PostTableCell.h"
#import "Forum.h"
#import "PostDetailViewController.h"
@interface CirclePostListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* postArray;
@end

@implementation CirclePostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PostInCircleTableCell" bundle:nil] forCellReuseIdentifier:@"PostInCircleTableCell"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    GetPostListInfoR* getPostListInfoR = [GetPostListInfoR new];
    getPostListInfoR.teamId = self.circleId;
    getPostListInfoR.sortType = [NSString stringWithFormat:@"%ld", (long)self.sortType];
    getPostListInfoR.page = 1;
    getPostListInfoR.pageSize = 1000;
    [Forum getPostListInfo:getPostListInfoR success:^(NSArray *responseModelArray) {
        self.postArray = responseModelArray;
        [self.tableView reloadData];
    } failure:^(HttpException *e) {
        DebugLog(@"get post List error : %@", e);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostInCircleTableCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    if (self.postArray.count > indexPath.row) {
        QWPostModel* postModel = self.postArray[indexPath.row];
        [cell setCell:postModel];        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"PostInCircleTableCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)currentViewSelected:(void (^)(CGFloat))finishLoading
{
    if (finishLoading) {
        CGFloat sumHeight = 0;
        __weak __typeof(self)weakSelf = self;
        for ( int i = 0; i < self.postArray.count; i++) {
            __weak NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            sumHeight += [self.tableView fd_heightForCellWithIdentifier:@"PostInCircleTableCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                [weakSelf configure:cell indexPath:indexPath];
            }];
//            sumHeight += [self.tableView fd_heightForCellWithIdentifier:@"PostInCircleTableCell" configuration:^(id cell) {
//                [self configure:cell indexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//            }];
        }
        finishLoading(sumHeight);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    postDetailVC.hidesBottomBarWhenPushed = YES;
    QWPostModel* postModel = self.postArray[indexPath.row];
    postDetailVC.postId = postModel.postId;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

- (void)setUpTableFrame:(CGRect)rect
{
    self.tableView.frame = rect;
}

- (void)footerRereshing:(void (^)(CGFloat))finishRefresh :(void (^)(BOOL))canLoadMore :(void (^)())failure
{
    
}

@end

//
//  MyRecommendationViewController.m
//  wenYao-store
//  我的推荐人列表页面
//  接口 ：
//      获取我的推荐人列表： api/mbr/inviter/queryMyRecommends
//  Created by Martin.Liu on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyRecommendationViewController.h"
#import "ConstraintsUtility.h"
#import "MyRecommendationTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Mbr.h"
#import "StoreModel.h"
#import "SVProgressHUD.h"

static NSString *const kMyRecommendationCell = @"kMyRecommendationCell";

@interface MyRecommendationViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* myRecommendArray;
@end

@implementation MyRecommendationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的推荐";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBHex(qwColor11);
    [self configTableView];
    [self loadData];
}

- (void)loadData
{
    if (!StrIsEmpty(QWGLOBALMANAGER.configure.userToken)) {
        __weak __typeof(self) weakSelf = self;
        [Mbr queryMyRecommends:@{@"token":QWGLOBALMANAGER.configure.userToken} success:^(MyRecommendListModel *myRecommendList) {
            if ([myRecommendList.apiStatus integerValue] == 0) {
                weakSelf.myRecommendArray = myRecommendList.myRecommends;
                if (weakSelf.myRecommendArray.count > 0) {
                    [weakSelf removeInfoView];
                }
                else
                {
                    [weakSelf showInfoView:@"暂无推荐人" image:@"img_employee_statistical"];
                }
                [weakSelf.tableView reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:StrDFString(myRecommendList.apiMessage, @"获取推荐人失败") duration:DURATION_LONG];
            }
        } failure:^(HttpException *e) {
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                
                [weakSelf showInfoView:kWaring12 image:@"img_network"];
            }else
            {
                if(e.errorCode!=-999){
                    if(e.errorCode == -1001){
                        [weakSelf showInfoView:kWarning215N54 image:@"ic_img_fail"];
                    }else{
                        [weakSelf showInfoView:kWarning215N0 image:@"ic_img_fail"];
                    }
                }
            }
        }];
    }
}

- (void)viewInfoClickAction:(id)sender
{
    [self loadData];
}

#pragma mark - 配置表格
- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = RGBHex(qwColor11);
    [self.view addSubview:self.tableView];
    PREPCONSTRAINTS(self.tableView);
    ALIGN_TOPLEFT(self.tableView, 0);
    ALIGN_BOTTOMRIGHT(self.tableView, 0);
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MyRecommendationTableCell" bundle:nil] forCellReuseIdentifier:kMyRecommendationCell];
}

#pragma mark - UITableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myRecommendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRecommendationTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kMyRecommendationCell forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (row < self.myRecommendArray.count) {
        MyRecommendModel* myRecommend = self.myRecommendArray[row];
        [cell setCell:myRecommend];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
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

@end

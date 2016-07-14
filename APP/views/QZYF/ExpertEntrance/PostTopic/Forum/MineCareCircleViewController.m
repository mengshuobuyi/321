//
//  MineCareCircleViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MineCareCircleViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CircleTableCell.h"
#import "Forum.h"
#import "LoginViewController.h"
@interface MineCareCircleViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineCareCircleViewController
{
    NSArray* myCircleArray;
    NSArray* myAttnCircleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的圈子";
    self.tableView.backgroundColor = RGBHex(qwColor11);
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleTableCell" bundle:nil] forCellReuseIdentifier:@"CircleTableCell"];
    
    if(!QWGLOBALMANAGER.loginStatus) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        __weak typeof(self) weakSelf = self;
//        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//        loginViewController.isPresentType = YES;
//        loginViewController.loginSuccessBlock = ^{
//            [weakSelf loadData];
//        };
//        [self presentViewController:navgationController animated:YES completion:NULL];
    }
    else
        [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    GetMyCircleListR* getMyCircleListR = [GetMyCircleListR new];
    getMyCircleListR.token = QWGLOBALMANAGER.configure.expertToken;
    [Forum getMyCircleList:getMyCircleListR success:^(QWMyCircleList *myCircleList) {
        myCircleArray = myCircleList.teamList;
        myAttnCircleArray = myCircleList.attnTeamList;
        if (myCircleArray.count == 0 && myAttnCircleArray.count == 0) {
            [self showInfoView:@"暂无关注的圈子" image:@"ic_img_fail"];
        }
        else
        {
            [self removeInfoView];
        }
        [self.tableView reloadData];
    } failure:^(HttpException *e) {
        DebugLog(@"get my CircleList : %@", e);
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

#pragma mark - UITableView delegate'
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSection = 0;
    if (myCircleArray.count > 0) {
        numberOfSection++;
    }
    if (myAttnCircleArray.count > 0) {
        numberOfSection++;
    }
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && myCircleArray.count > 0) {
        return myCircleArray.count;
    }
    return myAttnCircleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CircleTableCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && myCircleArray.count > 0) {
        QWCircleModel* circle = myCircleArray[indexPath.row];
        [cell setCell:circle];
    }
    else
    {
        QWCircleModel* circle = myAttnCircleArray[indexPath.row];
        [cell setCell:circle];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"CircleTableCell" configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, height)];
    view.backgroundColor = RGBHex(qwColor11);
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APP_W - 15 * 2, height)];
    label.font = [UIFont systemFontOfSize:kFontS4];
    label.textColor = RGBHex(qwColor8);
    NSString* title;
    title = section == 0 ? @"我的圈子" : @"我关注的圈子";
    label.text = title;
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
}



@end

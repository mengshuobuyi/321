//
//  MAAllCircleViewController.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/1/20.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MAAllCircleViewController.h"
#import "CircleDetailViewController.h"
#import "CircleTableCell.h"
#import "Forum.h"
#import "SVProgressHUD.h"
@interface MAAllCircleViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MAAllCircleViewController
{
    NSArray* circleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleTableCell" bundle:nil] forCellReuseIdentifier:@"CircleTableCell"];
    [self loadData];
}

- (void)loadData
{
    GetAllCircleListR* getAllCircleListR = [GetAllCircleListR new];
    getAllCircleListR.token = QWGLOBALMANAGER.configure.expertToken;
    [Forum getAllCircleList:getAllCircleListR success:^(NSArray *teamList) {
        circleArray = teamList;
        [self.tableView reloadData];
    } failure:^(HttpException *e) {
        DebugLog(@"getAllTeamList error : %@", e);
    }];
}

- (void)UIGlobal
{
    self.tableView.backgroundColor = RGBHex(qwColor11);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 10;
    return circleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleTableCell* cell = (CircleTableCell*)[tableView dequeueReusableCellWithIdentifier:@"CircleTableCell" forIndexPath:indexPath];
    __weak QWCircleModel* circleModel = circleArray[indexPath.row];
    __weak __typeof(self) weakSelf = self;
    
    if (self.selectCircleBlock) {
        cell.circleType = CircleCellType_SelectedRadio;
        cell.chooseBtn.selected = [circleModel isEqual:self.selectedCircle];
    }
    else
    {
        cell.circleType = CircleCellType_Normal;
        cell.careBtn.touchUpInsideBlock = ^{
            AttentionCircleR* attentionCircleR = [AttentionCircleR new];
            attentionCircleR.teamId = circleModel.teamId;
            attentionCircleR.isAttentionTeam = circleModel.flagAttn ? 1 : 0;
            attentionCircleR.token = QWGLOBALMANAGER.configure.expertToken;
            [Forum attentionCircle:attentionCircleR success:^(BaseAPIModel *baseAPIModel) {
                if ([baseAPIModel.apiStatus integerValue] == 0) {
                    circleModel.flagAttn = !circleModel.flagAttn;
                    [weakSelf.tableView reloadData];
                }
                else
                {
                    if (!StrIsEmpty(baseAPIModel.apiMessage)) {
                        [SVProgressHUD showErrorWithStatus:baseAPIModel.apiMessage];
                    }
                }
            } failure:^(HttpException *e) {
                DebugLog(@"attention circle error : %@", e);
            }];
        };
    }
    [cell setCell:circleModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 发帖选择圈子
    if (self.selectCircleBlock) {
        QWCircleModel* circleModel = circleArray[indexPath.row];
        self.selectCircleBlock(circleModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // 进入圈子详情
        CircleDetailViewController *circleDetailVC = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
        QWCircleModel* circleModel = circleArray[indexPath.row];
        circleDetailVC.teamId = circleModel.teamId;
        circleDetailVC.title = [NSString stringWithFormat:@"%@圈",circleModel.teamName];
        circleDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:circleDetailVC animated:YES];
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

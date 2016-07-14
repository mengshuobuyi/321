//
//  CirclerListViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CirclerListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CirclerTableCell.h"
#import "Forum.h"
#import "SVProgressHUD.h"
@interface CirclerListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_bottomViewHeight;  // default is 49
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic, strong) NSArray* circlerArray;

- (IBAction)bottomBtnAction:(id)sender;

@end

@implementation CirclerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CirclerTableCell" bundle:nil] forCellReuseIdentifier:@"CirclerTableCell"];
    [self loadData];
}

- (void)UIGlobal
{
    self.bottomBtn.layer.masksToBounds = YES;
    self.bottomBtn.layer.cornerRadius = 4;
//    self.bottomBtn.backgroundColor = RGBHex(qwColor2);
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS3];
    [self.bottomBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
}

- (void)loadData
{
    GetCirclerInfoR* getCirclerInfoR = [GetCirclerInfoR new];
    getCirclerInfoR.token = QWGLOBALMANAGER.configure.expertToken;
    getCirclerInfoR.teamId = self.circleId;
    [Forum getCirclerInfoList:getCirclerInfoR success:^(NSArray *responseModelArray) {
        self.circlerArray = responseModelArray;
    } failure:^(HttpException *e) {
        DebugLog(@"get circlerList error : %@", e);
    }];
}

- (void)setCirclerArray:(NSArray *)circlerArray
{
    _circlerArray = circlerArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.circlerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CirclerTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CirclerTableCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    if (self.circlerArray.count > indexPath.row) {
        QWCirclerModel* circlerModel = self.circlerArray[indexPath.row];
        [cell setCell:circlerModel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"CirclerTableCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
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

- (IBAction)bottomBtnAction:(id)sender {
    ApplyCirclerR* applyCircleR = [ApplyCirclerR new];
    applyCircleR.teamId = self.circleId;
    applyCircleR.token = QWGLOBALMANAGER.configure.expertToken;
    [Forum applyCircler:applyCircleR success:^(BaseAPIModel *baseAPIModel) {
        if ([baseAPIModel.apiStatus integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功！"];
            DebugLog(@"申请成功 : %@", baseAPIModel);
        }
        else
        {
            if (!StrIsEmpty(baseAPIModel.apiMessage)) {
                [SVProgressHUD showErrorWithStatus:baseAPIModel.apiMessage];
            }
        }
    } failure:^(HttpException *e) {
        NSLog(@"apply circler Error : %@", e);
    }];
}
@end

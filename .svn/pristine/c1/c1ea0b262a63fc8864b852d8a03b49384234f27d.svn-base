//
//  MarketSelectProductViewController.m
//  wenYao-store
//
//  选择活动商品页面
//  /h5/mmall/mktg/queryActs
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MarketSelectProductViewController.h"
#import "ActivityModel.h"
#import "WechatActivityCell.h"
#import "MemberMarket.h"

#define WechatActivityCellIdentifier @"WechatActivityCell"
static maxSelectNum = 6;
@interface MarketSelectProductViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (nonatomic, strong) NSMutableArray *arrProduct;
@property (nonatomic, strong) NSMutableArray *arrSelected;
@end

@implementation MarketSelectProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择商品";
    UINib *nibFour = [UINib nibWithNibName:@"WechatActivityCell" bundle:nil];
    [self.tbViewContent registerNib:nibFour forCellReuseIdentifier:WechatActivityCellIdentifier];
    self.arrProduct = [NSMutableArray array];
    self.arrSelected = [NSMutableArray array];
    [self setViewStyle];
    [self getAllProducts];
    [self setBtnStatus];
    [self.btnConfirm setTitle:[NSString stringWithFormat:@"确定（ %ld/%d ）",self.arrPre.count,maxSelectNum] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)setViewStyle
{
    self.btnConfirm.layer.cornerRadius = 4.0f;
    self.btnConfirm.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllProducts
{
    MarketQueryProductModelR *modelR = [MarketQueryProductModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [MemberMarket queryProductList:modelR success:^(MktgActListVo *responseModel) {
        [self.arrProduct removeAllObjects];
        [self.arrProduct addObjectsFromArray:responseModel.acts];
        [self.tbViewContent reloadData];
        if (self.arrProduct.count == 0) {
            [self showInfoView:@"暂无活动" image:@"ic_img_fail"];
        } else {
            [self setCurSelect];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)setCurSelect
{
    for (MicroMallActivityVO *model in self.arrProduct) {
        for (MicroMallActivityVO *modelSel in self.arrPre) {
            if ([modelSel.actId isEqualToString:model.actId]) {
                model.isSelected = YES;
                [self.arrSelected addObject:model];
                break;
            }
        }
    }
    [self setBtnStatus];
    [self.tbViewContent reloadData];
}

#pragma mark - UITableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrProduct.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MicroMallActivityVO *model = self.arrProduct[indexPath.row];
    WechatActivityCell *marketCell = (WechatActivityCell *)[tableView dequeueReusableCellWithIdentifier:WechatActivityCellIdentifier];
    [marketCell setCell:model];
    marketCell.perryBtn.hidden = NO;
    if (model.isSelected == YES) {
        [marketCell.perryBtn setImage:[UIImage imageNamed:@"img_no_selected"] forState:UIControlStateNormal];
    } else {
        [marketCell.perryBtn setImage:[UIImage imageNamed:@"img_no_select"] forState:UIControlStateNormal];
    }
    return marketCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MicroMallActivityVO *model = self.arrProduct[indexPath.row];
    if (model.isSelected) {
        [self.arrSelected removeObject:model];
        model.isSelected = !model.isSelected;
    } else {
        if (self.arrSelected.count >= 6) {
//            [[[UIAlertView alloc] initWithTitle:@"" message:@"最多只能选择6个商品" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
            [self showError:@"最多只能选择6个商品"];
        } else {
            [self.arrSelected addObject:model];
            model.isSelected = !model.isSelected;
        }
    }
    [self setBtnStatus];
    [self.btnConfirm setTitle:[NSString stringWithFormat:@"确定（ %ld/%d ）",self.arrSelected.count,maxSelectNum] forState:UIControlStateNormal];
    [self.tbViewContent reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setBtnStatus
{
    if (self.arrSelected.count > 0) {
        self.btnConfirm.backgroundColor = RGBHex(qwColor2);
        self.btnConfirm.enabled = YES;
    } else {
        self.btnConfirm.backgroundColor = RGBHex(qwColor9);
        self.btnConfirm.enabled = NO;
    }
}

- (IBAction)btnConfirmProduct:(id)sender {
    self.block(self.arrSelected);
    [self.navigationController popViewControllerAnimated:YES];
}

@end

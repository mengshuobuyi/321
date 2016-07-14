//
//  MarketSelectBrochureViewController.m
//  wenYao-store
//
//  选择活动海报页面
//  h5/mmall/mktg/queryDms
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MarketSelectBrochureViewController.h"
#import "MarketingActivityTableViewCell.h"

#import "MarketingActivityTableViewCell.h"
#import "MemberMarket.h"
#define MarketingActivityTableViewCellIdentifier @"MarketingActivityTableViewCellIdentifier"
@interface MarketSelectBrochureViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (nonatomic, strong) NSMutableArray *arrBrochures;
@property (nonatomic, assign) NSInteger intSelectTicket;
@end

@implementation MarketSelectBrochureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择门店海报";
    UINib *nibThree = [UINib nibWithNibName:@"MarketingActivityTableViewCell" bundle:nil];
    [self.tbViewContent registerNib:nibThree forCellReuseIdentifier:MarketingActivityTableViewCellIdentifier];
    self.arrBrochures = [NSMutableArray array];
    self.intSelectTicket = 0;
    [self getAllBrochures];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllBrochures
{
    MarketQueryBrochureModelR *modelR = [MarketQueryBrochureModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [MemberMarket queryBrochureList:modelR success:^(MktgDmListVo *responseModel) {
        [self.arrBrochures removeAllObjects];
        [self.arrBrochures addObjectsFromArray:responseModel.dms];
        [self.tbViewContent reloadData];
        if (self.arrBrochures.count == 0) {
            [self showInfoView:@"暂无海报" image:@"ic_img_fail"];
        } else {
//            [self setCurSelectVo];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)setCurSelectVo
{
    for (int i = 0; i < self.arrBrochures.count; i++) {
        QueryActivityInfo *model = self.arrBrochures[i];
        if ([model.id isEqualToString:self.modelVo.id]) {
            self.intSelectTicket = i+1;
        }
    }
    if (self.intSelectTicket > 0) {
        [self.tbViewContent reloadData];
    }
}
#pragma mark - UITableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrBrochures.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryActivityInfo *model = self.arrBrochures[indexPath.row];
    MarketingActivityTableViewCell *marketCell = (MarketingActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MarketingActivityTableViewCellIdentifier];
    marketCell.titleLabel.text = model.title;
    marketCell.contentLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:model.content];
    marketCell.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    [marketCell.avatarImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    marketCell.avatarImage.hidden = NO;
    NSString *strSource = @"";
    NSString *strSourceAndDate=@"";
    if ([model.source intValue] == 1) {
        strSource = @"全维";
    } else if ([model.source intValue] == 2) {
        strSource = @"商户";
    } else if ([model.source intValue] == 3){
        strSource = @"门店";
    }
    if(strSource==nil||[strSource isEqualToString:@""]){
        strSourceAndDate = [NSString stringWithFormat:@""];
    }else{
        strSourceAndDate = [NSString stringWithFormat:@"来源: %@",strSource];
    }
    
    marketCell.sourceLable.text = strSourceAndDate;
    marketCell.dateLabel.text=model.publish;
    marketCell.viewContent.layer.borderWidth = 0.0f;
    if (self.intSelectTicket == indexPath.row + 1) {
        marketCell.viewContent.layer.borderColor = RGBHex(qwColor2).CGColor;
        marketCell.viewContent.layer.borderWidth = 2.0f;
    }
    return marketCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryActivityInfo *model = self.arrBrochures[indexPath.row];
    self.intSelectTicket = indexPath.row+1;
    [self.tbViewContent reloadData];
    self.block(model);
    [self.navigationController popViewControllerAnimated:YES];
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

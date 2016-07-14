//
//  ScoreRankDetailViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    积分排行详情
    h5/branch/score/emp/rank
 */

#import "ScoreRankDetailViewController.h"
#import "PieChartView.h"
#import "Branch.h"
#import "ScoreModel.h"

@interface ScoreRankDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PieChartViewDataSource,PieChartViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//header
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;  //头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;            //姓名
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;           //销售等级
@property (weak, nonatomic) IBOutlet UIImageView *statuImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;         //排名
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;      //累计积分
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;    //当前积分

//footer
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet UILabel *oneScoreLabel;        //培训
@property (weak, nonatomic) IBOutlet UILabel *twoScorelabel;        //营销
@property (weak, nonatomic) IBOutlet UILabel *threeScoreLabel;      //日常
@property (weak, nonatomic) IBOutlet UILabel *fourScoreLabel;       //其他

//区分是否开通微商 （未开通微商去掉营销）
@property (weak, nonatomic) IBOutlet UILabel *twoColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeColor_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeTip_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeScore_layout_top;

//饼状图
@property (strong, nonatomic) PieChartView *pieChartView;
@property (nonatomic, strong) NSMutableArray *slices;
@property (nonatomic, strong) NSArray        *sliceColors;

@property (strong, nonatomic) ScoreRankDetailModel *scoreDetailModel;

@end

@implementation ScoreRankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoreDetailModel = [ScoreRankDetailModel new];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self queryInfo];
}

#pragma mark ---- 查询详情数据 ----
- (void)queryInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"empId"] = StrFromObj(self.empId);
    [Branch BranchScoreEmpRankWithParams:setting success:^(id obj) {
        
        ScoreRankDetailModel *model = [ScoreRankDetailModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            self.scoreDetailModel = model;
            
            if (!self.scoreDetailModel.mshopFlag) {
                self.scoreDetailModel.market = 0;
            }
            
            self.slices = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",model.train],[NSString stringWithFormat:@"%d",model.market],[NSString stringWithFormat:@"%d",model.daily],[NSString stringWithFormat:@"%d",model.other], nil];
            [self configureHeaderUI];
            [self configureFooterUI];
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置列表header ----
- (void)configureHeaderUI
{
    //头像
    self.headerImageView.layer.cornerRadius = 32;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:self.scoreDetailModel.headImg] placeholderImage:[UIImage imageNamed:@"my_img_head"]];
    
    //等级
    if (self.scoreDetailModel.lvl == 5)
    {
        //销售大师
        self.statuLabel.text = @"     销售大师";
        self.statuImageView.image = [UIImage imageNamed:@"integral_ranking_one"];
        
    }else if (self.scoreDetailModel.lvl == 4)
    {
        //销售专家
        self.statuLabel.text = @"     销售专家";
        self.statuImageView.image = [UIImage imageNamed:@"integral_ranking_two"];
        
    }else if (self.scoreDetailModel.lvl == 3)
    {
        //销售达人
        self.statuLabel.text = @"     销售达人";
        self.statuImageView.image = [UIImage imageNamed:@"integral_ranking_three"];
        
    }else if (self.scoreDetailModel.lvl == 2)
    {
        //销售骨干
        self.statuLabel.text = @"     销售骨干";
        self.statuImageView.image = [UIImage imageNamed:@"integral_ranking_four"];
        
    }else if (self.scoreDetailModel.lvl == 1)
    {
        //销售能手
        self.statuLabel.text = @"     销售能手";
        self.statuImageView.image = [UIImage imageNamed:@"integral_ranking_five"];
        
    }else if (self.scoreDetailModel.lvl == 0)
    {
        //普通会员
        self.statuLabel.text = @"     销售新手";
        self.statuImageView.image = [UIImage imageNamed:@"integral_ranking_sixo"];
    }
    
    //排名
    self.rankingLabel.text = [NSString stringWithFormat:@"%d",self.scoreDetailModel.rank];
    
    //总积分
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d",self.scoreDetailModel.totalScore];
    
    //当前积分
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d",self.scoreDetailModel.score];
}

#pragma mark ---- 设置列表footer ----
- (void)configureFooterUI
{
    if (self.scoreDetailModel.mshopFlag)
    {
        //开通微商
        self.twoColorLabel.hidden = NO;
        self.twoTipLabel.hidden = NO;
        self.twoScorelabel.hidden = NO;
        self.threeColor_layout_top.constant = 57;
        self.threeTip_layout_top.constant = 55;
        self.threeScore_layout_top.constant = 55;
    }else
    {
        //未开通微商 隐藏营销积分
        self.twoColorLabel.hidden = YES;
        self.twoTipLabel.hidden = YES;
        self.twoScorelabel.hidden = YES;
        self.threeColor_layout_top.constant = 32;
        self.threeTip_layout_top.constant = 30;
        self.threeScore_layout_top.constant = 30;
    }
    
    //培训积分
    self.oneScoreLabel.text = [NSString stringWithFormat:@"%d积分",self.scoreDetailModel.train];
    
    //营销积分
    self.twoScorelabel.text = [NSString stringWithFormat:@"%d积分",self.scoreDetailModel.market];
    
    //日常积分
    self.threeScoreLabel.text = [NSString stringWithFormat:@"%d积分",self.scoreDetailModel.daily];
    
    //其他积分
    self.fourScoreLabel.text = [NSString stringWithFormat:@"%d积分",self.scoreDetailModel.other];
    
    self.pieChartView  = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
    [self.pieChartView setPieCenter:CGPointMake(APP_W/2, 132)];
    [self.pieChartView setShowPercentage:NO];
    self.pieChartView.userInteractionEnabled = NO;
    self.pieChartView.backgroundColor = [UIColor clearColor];
    [self.tableFooterView addSubview:self.pieChartView];
    
    [self.pieChartView setDataSource:self];
    [self.pieChartView setStartPieAngle:M_PI_2];
    [self.pieChartView setAnimationSpeed:0.5];
    [self.pieChartView setLabelFont:[UIFont systemFontOfSize:15]];
    [self.pieChartView setLabelRadius:60];
    
    
    UIView *centerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
    centerView.center = CGPointMake(APP_W/2, 132);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 45;
    centerView.layer.masksToBounds = YES;
    [self.pieChartView addSubview:centerView];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 90, 20)];
    lab1.text = @"总积分";
    lab1.textColor = RGBHex(qwColor6);
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 90, 20)];
    lab2.text = [NSString stringWithFormat:@"%d",self.scoreDetailModel.totalScore];
    lab2.textColor = RGBHex(qwColor3);
    lab2.font = [UIFont systemFontOfSize:15];
    lab2.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:lab2];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       RGBHex(qwColor15),
                       RGBHex(qwColor3),
                       RGBHex(qwColor14),
                       RGBHex(qwColor13), nil];
    
    CGRect frame = self.tableFooterView.frame;
    if (IS_IPHONE_6P || IS_IPHONE_6)
    {
        frame.size.height = SCREEN_H-64-206-7;
    }else
    {
        frame.size.height = 345;
    }
    self.tableFooterView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartView reloadData];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(PieChartView *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(PieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(PieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(PieChartView *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"ScoreRankDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

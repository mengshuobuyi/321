//
//  CommonDiseaseDetailViewController.m
//  APP
//
//  Created by Meng on 15/6/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CommonDiseaseDetailViewController.h"
#import "ZhPMethod.h"
//model
#import "Drug.h"
//controllers
#import "DiseaseTreatRuleMedicineViewController.h"
#import "LoginViewController.h"
//views
#import "QCSlideSwitchView.h"
#import "WebDirectViewController.h"

static NSString * const descCellIdentifier = @"descCellIdentifier";
static NSString * const sectionCellIdentifier = @"sectionCellIdentifier";

@interface CommonDiseaseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,QCSlideSwitchViewDelegate>
{
    CGFloat rowHeight;
    
    DiseaseTreatRuleMedicineViewController *currentViewController;
    
}
//head view
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *diseaseTitle;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
//head view action
- (IBAction)collectButtonClick:(UIButton *)sender;
- (IBAction)shareButtonClick:(UIButton *)sender;
//table view
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;
@property (weak, nonatomic) IBOutlet UITableView *diseaseTableView;

//foundation class
@property (nonatomic ,strong) NSMutableDictionary *diseaseDict;
@property (nonatomic ,strong) NSMutableArray *formulaListArray;
@property (nonatomic ,strong) NSMutableArray *formulaDetailArray;
@property (nonatomic ,strong) NSMutableArray *sliderViewControllers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstraints;
@property (assign, nonatomic) int passNumber;


@end

@implementation CommonDiseaseDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initObj];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initObj];
    }
    return self;
}

- (void)initObj
{
    self.diseaseDict = [NSMutableDictionary dictionary];
    self.formulaDetailArray = [NSMutableArray array];
    self.formulaListArray = [NSMutableArray array];
    self.sliderViewControllers = [NSMutableArray array];
}

- (void)awakeFromNib
{
    self.lineConstraints.constant = 0.5;
    [self.collectButton setBackgroundImage:[[UIImage imageNamed:@"ic_btn_collect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[[UIImage imageNamed:@"icon_share_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowHeight = 300;
    [self.diseaseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:descCellIdentifier];
    [self.diseaseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sectionCellIdentifier];
    [self.diseaseTableView addStaticImageHeader];
    self.diseaseTableView.tableHeaderView = self.headView;
    self.diseaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupSliderViewControllers];
    [self setupSliderView];
    [self requestDiseaseInfomation];
    [self.diseaseTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.diseaseTableView.footerPullToRefreshText = kWaring6;
    self.diseaseTableView.footerReleaseToRefreshText = kWaring7;
    self.diseaseTableView.footerRefreshingText = kWaring9;
    self.diseaseTableView.footerNoDataText = kWaring55;


   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}



- (void)setupSliderViewControllers
{
    DiseaseTreatRuleMedicineViewController *treatMedicine = [[DiseaseTreatRuleMedicineViewController alloc] init];
    treatMedicine.navigationController = self.navigationController;
    treatMedicine.title = @"治疗用药";
    treatMedicine.requestType = @"1";
    treatMedicine.diseaseId = self.diseaseId;
    
    DiseaseTreatRuleMedicineViewController *healthFood = [[DiseaseTreatRuleMedicineViewController alloc] init];
    healthFood.navigationController = self.navigationController;
    healthFood.title = @"健康食品";
    healthFood.requestType = @"2";
    healthFood.diseaseId = self.diseaseId;
    
    DiseaseTreatRuleMedicineViewController *medicineGoods = [[DiseaseTreatRuleMedicineViewController alloc] init];
    medicineGoods.navigationController = self.navigationController;
    medicineGoods.title = @"医疗用品";
    medicineGoods.requestType = @"3";
    medicineGoods.diseaseId = self.diseaseId;
    
    currentViewController = treatMedicine;
    
    [self.sliderViewControllers addObject:treatMedicine];
    [self.sliderViewControllers addObject:healthFood];
    [self.sliderViewControllers addObject:medicineGoods];
}

- (void)setupSliderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 500)];
    [self.slideSwitchView.rootScrollView setFrame:CGRectMake(0, 0, APP_W, self.slideSwitchView.rootScrollView.bounds.size.height)];
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor7);
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwColor4)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwColor1);
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(kFontS4)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 38.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.slideSwitchView.topScrollView addSubview:line];
}


- (void)viewInfoClickAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
        [self removeInfoView];
        [self requestDiseaseInfomation];
    }
}


- (void)requestDiseaseInfomation
{
    DiseaseDetailIosR *detaileR=[DiseaseDetailIosR new];
    detaileR.diseaseId = self.diseaseId;
    
    [Drug DiseaseDetailIosWithParam:detaileR success:^(id obj) {
        [self.diseaseDict addEntriesFromDictionary:obj];
        
        self.diseaseTitle.text = self.diseaseDict[@"name"];
        
        [self.formulaListArray removeAllObjects];
        if ([self.diseaseDict[@"formulaList"] isKindOfClass:[NSArray class]]) {
            [self.formulaListArray addObjectsFromArray:self.diseaseDict[@"formulaList"]];
        }
        [self.diseaseTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(HttpException *e) {
        //217的修改点  cj
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [self showInfoView:kWaring12 image:@"网络信号icon.png"];
            return;
        }else{
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"img_preferential"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"img_preferential"];
                }
                
            }
            return;
        }
    }];
}


#pragma mark section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 39.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return _slideSwitchView.topScrollView;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 10)];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
        topLine.backgroundColor = RGBHex(qwColor10);
        [v addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, v.frame.origin.y + v.frame.size.height-0.5, APP_W, 0.5)];
        bottomLine.backgroundColor = RGBHex(qwColor10);
        [v addSubview:bottomLine];
        
        v.backgroundColor = self.view.backgroundColor;
        return v;
    }
    return 0;
}


#pragma mark row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *desc = self.diseaseDict[@"desc"];
        if (!StrIsEmpty(desc)) {
            CGSize adjustSize = getTempTextSize(desc, fontSystem(kFontS4), 270 +2);
            if (adjustSize.height > 60) {
                return 60+20;
            }else if(adjustSize.height < 20){
                return 20 + 20+20;
            }else{
                return adjustSize.height + 20+20;
            }
        }else{
            return 20;
        }
    }else if (indexPath.section == 1){
        return rowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.diseaseTableView dequeueReusableCellWithIdentifier:descCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *desc = self.diseaseDict[@"desc"];
        if (!StrIsEmpty(desc)) {
            cell.textLabel.text = desc;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = fontSystem(kFontS4);
            cell.textLabel.textColor = RGBHex(qwColor6);
            CGSize adjustSize = getTempTextSize(self.diseaseDict[@"desc"], fontSystem(kFontS4), 270 +2);
            CGFloat x = cell.textLabel.frame.origin.x;
            CGFloat y = cell.textLabel.frame.origin.y;
            if (adjustSize.height > 60) {
                [cell.textLabel setFrame:CGRectMake(0, y , APP_W, 60)];
            }else if(adjustSize.height < 20){
                [cell.textLabel setFrame:CGRectMake(0, y , APP_W, 20)];
            }else{
                [cell.textLabel setFrame:CGRectMake(0, y , APP_W, adjustSize.height)];
            }
        }else{
            
        }
        
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.slideSwitchView];
        return cell;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString *diseaseId = self.diseaseId;
        NSString *title = [NSString stringWithFormat:@"%@详情",self.title];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDiseaseDetailModel *modelDisease = [[WebDiseaseDetailModel alloc] init];
        modelDisease.diseaseId = diseaseId;
        
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelDisease = modelDisease;
        modelLocal.title = title;
        modelLocal.typeLocalWeb = WebPageToWebTypeDisease;
        [vcWebDirect setWVWithLocalModel:modelLocal];
                
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
        
    }
}

#pragma mark QCSliderView

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return self.sliderViewControllers.count;
}
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.sliderViewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view willselectTab:(NSUInteger)number
{
    self.diseaseTableView.footerNoDataText = kWaring55;
    [self.diseaseTableView.footer setDiseaseCanLoadMore:YES];
    currentViewController = self.sliderViewControllers[number];
    [currentViewController currentViewSelected:^(CGFloat height) {
        rowHeight = height;
        [self.slideSwitchView setFrame:CGRectMake(0, 0, APP_W, rowHeight)];
        [self.slideSwitchView.rootScrollView setFrame:CGRectMake(0, 0, APP_W, rowHeight)];
        [self.diseaseTableView reloadData];
    }];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
}

- (void)footerRereshing
{
    [currentViewController footerRereshing:^(CGFloat height) {
        rowHeight = height;
        [self.slideSwitchView.rootScrollView setFrame:CGRectMake(0, 0, APP_W, rowHeight)];
        [self.slideSwitchView setFrame:CGRectMake(0, 0, APP_W, rowHeight)];
        [self.diseaseTableView reloadData];
        [self.diseaseTableView footerEndRefreshing];
    }:^(BOOL canLoadMore) {
    
        if (canLoadMore == NO) {
            [self.diseaseTableView.footer setCanLoadMore:canLoadMore];
        }
    }:^{
        [self.diseaseTableView footerEndRefreshing];
    }];
}


@end

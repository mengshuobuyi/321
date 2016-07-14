//
//  InteractiveStatisticViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "InteractiveStatisticViewController.h"
#import "InteractiveStatisticCell.h"
#import "ConsultMode.h"
#import "Consult.h"
//#import "StatisticHelpViewController.h"
#import "SVProgressHUD.h"
#import "CustomDatePicker.h"
#import "ServiceSpecificationViewController.h"

#define Im_Help_Url           API_APPEND_V2(@"api/helpClass/im_help")

@interface InteractiveStatisticViewController ()<UITableViewDataSource,UITableViewDelegate,CustomDatePickerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (strong, nonatomic) UIView *notWifiBgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *sectionTitle;
@property (strong, nonatomic) ConsultStatisticsModel *consultModel;

@property (weak, nonatomic) IBOutlet UIView *othersBgView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlChangeType:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *queryButton;

- (IBAction)startDateAction:(id)sender;
- (IBAction)endDateAction:(id)sender;
- (IBAction)queryAction:(id)sender;

@end

@implementation InteractiveStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.title = @"互动统计";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.dataList = @[@[],@[@"抢答次数",@"应答次数",@"抢而未答次数",@"平均响应时间"],@[@"咨询人次",@"应答人次",@"互动条数",@"平均响应时间"]];
    self.sectionTitle = @[@"qq",@"抢答问题",@"本店咨询"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)];

    self.queryButton.layer.cornerRadius = 3.0;
    self.queryButton.layer.masksToBounds = YES;
    
    self.segmentedControl.tintColor = RGBHex(qwColor1);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwColor6),UITextAttributeTextColor,fontSystem(kFontS5),UITextAttributeFont ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.segmentedHeightConstraint.constant = 36.0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footView;
    self.tableView.allowsSelection = NO;
}

- (void)setDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSDate *yesterday =[NSDate dateWithTimeInterval:-60*60*24 sinceDate:date];
//    NSDate *tomorrow =[NSDate dateWithTimeInterval:60*60*24 sinceDate:date];
    [self.startDateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:yesterday]] forState:UIControlStateNormal];
    [self.endDateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:yesterday]] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDate];
    self.othersBgView.hidden = YES;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.tableViewHeightConstraint.constant = [[UIScreen mainScreen] bounds].size.height-59-64;
    [self queryRecentData];
}

#pragma mark ---- 请求数据 ----

- (void)queryRecentData
{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"img_network"];
        return;
    }
    
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    if (self.segmentedControl.selectedSegmentIndex ==0) {
        setting[@"field"] = @"4";
        setting[@"value"] = @"1";
    }else if (self.segmentedControl.selectedSegmentIndex == 1){
        setting[@"field"] = @"2";
        setting[@"value"] = @"1";
    }else if (self.segmentedControl.selectedSegmentIndex == 2){
        setting[@"field"] = @"2";
        setting[@"value"] = @"3";
    }
    
    [[QWLoading instance] showLoading];
    
    [Consult consultStatisticsByRecentWithParam:setting success:^(id obj) {
        
        [[QWLoading instance] removeLoading];
        
        self.consultModel = (ConsultStatisticsModel *)obj;
        if ([self.consultModel.apiStatus integerValue] == 0) {
            self.tableView.hidden = NO;

            [self.tableView reloadData];
        }else
        {
            self.tableView.hidden = YES;
            [SVProgressHUD showErrorWithStatus:self.consultModel.apiMessage duration:0.8];
        }
        
    } failure:^(HttpException * e) {
        [[QWLoading instance] removeLoading];
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
            }else{
                [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
            }
        }
    }];
    
}

- (void)queryDateData
{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8];
        return;
    }
    
    int i = [self compareDate:self.startDateBtn.titleLabel.text withDate:self.endDateBtn.titleLabel.text];
    if (i == -1) {
        [SVProgressHUD showErrorWithStatus:kWarning215N39 duration:0.8];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"beginTime"] = StrFromObj(self.startDateBtn.titleLabel.text);
    setting[@"endTime"] = StrFromObj(self.endDateBtn.titleLabel.text);
    
    [[QWLoading instance] showLoading];
    [Consult consultStatisticsByDateWithParam:setting success:^(id obj) {
        
        [[QWLoading instance] removeLoading];
        self.consultModel = (ConsultStatisticsModel *)obj;
        if ([self.consultModel.apiStatus integerValue] == 0) {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else
        {
            self.tableView.hidden = YES;
            [SVProgressHUD showErrorWithStatus:self.consultModel.apiMessage duration:0.8];
        }
        
    } failure:^(HttpException *e) {
//        [self showInfoVie:kWarning215N0 image:@"ic_img_fail"];
        [[QWLoading instance] removeLoading];
        [SVProgressHUD showErrorWithStatus:@"通讯异常" duration:0.8];
    }];
}

//比较两个日期大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8.0;
    }
    return 34.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 8)];
        vi.backgroundColor = RGBHex(qwColor11);
        return vi;
    }else
    {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 34)];
        vi.backgroundColor = RGBHex(qwColor4);
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, APP_W, 34)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = self.sectionTitle[section];
        lab.font = fontSystem(kFontS4);
        lab.textColor = RGBHex(qwColor6);
        [vi addSubview:lab];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 33.0, APP_W-20, 1)];
        line.backgroundColor = RGBHex(qwColor1);
        [vi addSubview:line];
        return vi;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InteractiveStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InteractiveStatisticCell"];
    cell.title.text = self.dataList[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 0){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@次",self.consultModel.racedCountDetail];
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@次",self.consultModel.answerCountDetail];
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@次",self.consultModel.racedWithoutAnswerCountDetail];
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 3){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@",self.consultModel.averageResponseTimeDetail];
        }
    }else if (indexPath.section == 2 && indexPath.row == 0){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@次",self.consultModel.imServerUsersIMBranch];
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@次",self.consultModel.imServerCountsIMBranch];
        }
    }else if (indexPath.section == 2 && indexPath.row == 2){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@条",self.consultModel.imRecordCountsIMBranch];
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 3){
        
        if (self.consultModel == nil){
            cell.content.text = @"";
        }else{
            cell.content.text = [NSString stringWithFormat:@"%@",self.consultModel.imResponseIMBranch];
        }
    }
    
    return cell;
}

#pragma mark ---- 跳转至帮助页面 ----

- (void)helpClick
{
    ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
    serviceV.TitleStr = @"帮助";
    serviceV.UrlStr = Im_Help_Url;
    [self.navigationController pushViewController:serviceV animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---- 改变选择项 ----

- (IBAction)segmentedControlChangeType:(id)sender {
    
//    [self noDataRemove];
    [self removeInfoView];
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == Enum_InteractiveStatistic_Items_OneWeek)
    {
        //最近一周
        
        self.tableViewHeightConstraint.constant = [[UIScreen mainScreen] bounds].size.height-59-64;
        self.tableView.tableFooterView = self.footView;
        self.consultModel = nil;
        [self.tableView reloadData];
        [self queryRecentData];
    }
    else if (seg.selectedSegmentIndex == Enum_InteractiveStatistic_Items_OneMonth)
    {
        //最近一月
        
        self.tableViewHeightConstraint.constant = [[UIScreen mainScreen] bounds].size.height-59-64;
        self.tableView.tableFooterView = self.footView;
        self.consultModel = nil;
        [self.tableView reloadData];
        [self queryRecentData];
    }
    else if (seg.selectedSegmentIndex == Enum_InteractiveStatistic_Items_ThreeMonth)
    {
        //最近三月
        
        self.tableViewHeightConstraint.constant = [[UIScreen mainScreen] bounds].size.height-59-64;
        self.tableView.tableFooterView = self.footView;
        self.consultModel = nil;
        [self.tableView reloadData];
        [self queryRecentData];
    }
    else if (seg.selectedSegmentIndex == Enum_InteractiveStatistic_Items_Others)
        
    {
        //其他
        
        [self setDate];
        self.tableViewHeightConstraint.constant = [[UIScreen mainScreen] bounds].size.height-200-64;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.consultModel = nil;
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.othersBgView.hidden = NO;
    }
}

#pragma mark ---- 日期控件代理 ----

- (void)makeSureDateActionWithDate:(NSDate *)date type:(int)type
{
    [date compare:date];
    if (type == 1) {
        
        //开始日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [self.startDateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
    }else if (type == 2)
    {
        //结束日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [self.endDateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
    }
}

#pragma mark ---- 选择开始日期 ----

- (IBAction)startDateAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    CustomDatePicker *datePicker = [[CustomDatePicker alloc] initWithButtonType:(int)btn.tag];
    datePicker.delegate = self;
    [datePicker show];
}

#pragma mark ---- 选择结束日期 ----

- (IBAction)endDateAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
   CustomDatePicker *datePicker = [[CustomDatePicker alloc] initWithButtonType:(int)btn.tag];
    datePicker.delegate = self;
    [datePicker show];
}

#pragma mark ---- 其他查询 ----

- (IBAction)queryAction:(id)sender
{
    [self queryDateData];
}

@end

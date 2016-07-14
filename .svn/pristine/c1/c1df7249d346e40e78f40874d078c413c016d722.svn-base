//
//  EmployeeShareToOrderStatisticsViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/10.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    员工分享转化订单统计
 
 */

#import "EmployeeShareToOrderStatisticsViewController.h"
#import "EmployeeShareToOrderStatisticsCell.h"
#import "CustomDatePicker.h"
#import "Order.h"
#import "OrderModel.h"

@interface EmployeeShareToOrderStatisticsViewController()<CustomDatePickerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerImage_layout_top;
@property (strong, nonatomic) NSMutableArray *dataList;

//开始日期
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
//结束日期
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
//查询
@property (weak, nonatomic) IBOutlet UIButton *queryButton;

- (IBAction)startDateAction:(id)sender;
- (IBAction)endDateAction:(id)sender;
- (IBAction)queryAction:(id)sender;

@end

@implementation EmployeeShareToOrderStatisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"员工分享转化订单统计";
    
    self.dataList = [NSMutableArray array];
    
    self.queryButton.layer.cornerRadius = 3.0;
    self.queryButton.layer.masksToBounds = YES;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDate];
}

#pragma mark ---- 设置初始日期 昨天 ----
- (void)setDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSDate *yesterday =[NSDate dateWithTimeInterval:-60*60*24 sinceDate:date];
    [self.startDateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:yesterday]] forState:UIControlStateNormal];
    [self.endDateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:yesterday]] forState:UIControlStateNormal];
}

#pragma mark ---- 请求数据 ----
- (void)queryDateData
{

    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"beginTime"] = StrFromObj(self.startDateBtn.titleLabel.text);
    setting[@"endTime"] = StrFromObj(self.endDateBtn.titleLabel.text);
    
    [Order BmmallQueryShareOrderWithParams:setting success:^(id obj) {
        
        ShareOrderPageModel *page = [ShareOrderPageModel parse:obj Elements:[ShareOrderListModel class] forAttribute:@"resultList"];
        if ([page.apiStatus integerValue] == 0)
        {
            self.tableView.hidden = NO;
            self.tableView.tableHeaderView = self.tableHeaderView;
            
            if (page.resultList.count>0)
            {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.resultList];
                self.tableView.tableFooterView = [[UIView alloc] init];
                [self.tableView reloadData];
                
            }else
            {
                [self.dataList removeAllObjects];
                CGRect frame = self.tableFooterView.frame;
                frame.size.height = SCREEN_H-64-141-48;
                self.tableFooterView.frame = frame;
                self.footerImage_layout_top.constant = 72*frame.size.height/315;
                self.tableView.tableFooterView = self.tableFooterView;
                [self.tableView reloadData];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:@"通讯异常" duration:0.8];
    }];

}

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EmployeeShareToOrderStatisticsCell getCellHeight:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeShareToOrderStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeShareToOrderStatisticsCell"];
    [cell setCell:self.dataList[indexPath.row]];
    return cell;
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

#pragma mark ---- 查询 ----
- (IBAction)queryAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (StrIsEmpty(self.startDateBtn.titleLabel.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入查询日起"];
        return;
    }
    
    int i = [self compareDate:self.startDateBtn.titleLabel.text withDate:self.endDateBtn.titleLabel.text];
    if (i == -1) {
        [SVProgressHUD showErrorWithStatus:@"起始日期大于终止日期，请重新输入！" duration:0.8];
        return;
    }
    
    [self queryDateData];
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

#pragma mark ---- 比较两个日期大小 ----
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
        default:
        break;
    }
    return ci;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

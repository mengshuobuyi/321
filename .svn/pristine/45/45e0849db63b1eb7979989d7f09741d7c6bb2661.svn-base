//
//  NewMessageAwokeViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "NewMessageAwokeViewController.h"
#import "NewMessageAwokeCell.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "System.h"

@interface NewMessageAwokeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * titleArr;
}
@property (nonatomic ,strong) UITableView * tableView;

@end

@implementation NewMessageAwokeViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新消息提醒";
    
    if (AUTHORITY_ROOT) {
        titleArr = @[@[@"消息声音",@"消息震动",@"新问题消息推送"]];
    }else{
        titleArr = @[@[@"消息声音",@"消息震动"]];
    }
    
    // 设置tableView
    [self setupTableView];
    
    self.messageVoiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    self.messageVoiceSwitch.tag = 101;
    [self.messageVoiceSwitch addTarget:self action:@selector(swicthSetting:) forControlEvents:UIControlEventValueChanged];
    self.messageVoiceSwitch.onTintColor = RGBHex(qwColor2);
    
    self.messageVibrationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    self.messageVibrationSwitch.tag = 102;
    [self.messageVibrationSwitch addTarget:self action:@selector(swicthSetting:) forControlEvents:UIControlEventValueChanged];
    self.messageVibrationSwitch.onTintColor = RGBHex(qwColor2);
    
    self.nnewQuestionPushSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    self.nnewQuestionPushSwitch.tag = 103;
    [self.nnewQuestionPushSwitch addTarget:self action:@selector(swicthSetting:) forControlEvents:UIControlEventValueChanged];
    self.nnewQuestionPushSwitch.onTintColor = RGBHex(qwColor2);
}

#pragma mark ---- 设置tableView ----

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.messageVoiceSwitch.on = [QWUserDefault getBoolBy:APP_VOICE_NOTIFICATION];
    self.messageVibrationSwitch.on = [QWUserDefault getBoolBy:APP_VIBRATION_NOTIFICATION];
    self.nnewQuestionPushSwitch.on = [QWUserDefault getBoolBy:APP_QUESTIONPUSH_NOTIFICATION];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    BOOL questionPushIsOpen = [QWUserDefault getBoolBy:APP_QUESTIONPUSH_NOTIFICATION];
    
    if (questionPushIsOpen) {
        //开启消息推送
        [self setUpPushStatu:0];
    }else{
        //关闭消息推送
        [self setUpPushStatu:1];
    }
}

#pragma mark ---- 设置消息推送 ----

- (void)setUpPushStatu:(int)statu
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"source"] = @"2";
    setting[@"pushStatus"] = [NSString stringWithFormat:@"%d",statu];
    
    [System systemPushSetWithParams:setting success:^(id obj) {
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置开关 ----

- (void)swicthSetting:(UISwitch *)changeSwitch
{
    switch (changeSwitch.tag) {
        case 101:
        {
            [QWUserDefault setBool:changeSwitch.isOn key:APP_VOICE_NOTIFICATION];
            break;
        }
        case 102:
        {
            [QWUserDefault setBool:changeSwitch.isOn key:APP_VIBRATION_NOTIFICATION];
            break;
        }
        case 103:
        {
            [QWUserDefault setBool:changeSwitch.isOn key:APP_QUESTIONPUSH_NOTIFICATION];
            break;
        }
        default:
            break;
    }
}

#pragma mark ---- 列表代理 ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)titleArr[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, APP_W-20, 20)];
    view.backgroundColor = [UIColor clearColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, APP_W-20, 20)];
    label.font = fontSystem(kFontS5);
    label.textColor = RGBHex(qwColor8);
    
    if (section == 0){
        label.text = @"新消息提醒";
    }else if (section == 1){
        label.text = @"用药闹钟提醒";
    }
    [view addSubview:label];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"NewMessageAwokeCell";
    NewMessageAwokeCell * cell = (NewMessageAwokeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewMessageAwokeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            cell.accessoryView = self.messageVoiceSwitch;
            break;
        }
        case 1:
        {
            cell.accessoryView = self.messageVibrationSwitch;
            break;
        }
        case 2:
        {
            cell.accessoryView = self.nnewQuestionPushSwitch;
            break;
        }
            
        default:
            break;
    }
    if (indexPath.row==0) {
        cell.backline.hidden=YES;
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

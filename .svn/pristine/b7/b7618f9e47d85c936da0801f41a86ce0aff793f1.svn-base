//
//  ChooseExpertViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/14.
//  Copyright © 2016年 carret. All rights reserved.
//
//    SeparateStr  分隔符
#import "ChooseExpertViewController.h"
#import "NewExpertTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Forum.h"
#import "SVProgressHUD.h"
#import "ConstraintsUtility.h"
#import "cssex.h"

#define ChooseExpert_MaxSelectExpertNum 100

@interface ChooseExpertViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* expertArray;
@property (strong, nonatomic) UIView* promptView;
@property (nonatomic, strong) UIButton* attentionExpertBtn;

@end

@implementation ChooseExpertViewController
@synthesize expertArray = expertArray;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"提醒专家看";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewExpertTableCell" bundle:nil] forCellReuseIdentifier:@"NewExpertTableCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadData];
}

- (void)UIGlobal
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(finishBtnAction:)];
}

- (void)finishBtnAction:(id)sender
{
    if (self.CallBackBlock) {
        self.CallBackBlock(self.selectedExpertArray);
    }
    [self popVCAction:nil];
}

- (NSMutableArray *)selectedExpertArray
{
    if (!_selectedExpertArray) {
        _selectedExpertArray = [NSMutableArray array];
    }
    else if (![_selectedExpertArray isKindOfClass:[NSMutableArray class]])
    {
        if ([_selectedExpertArray isKindOfClass:[NSArray class]]) {
            _selectedExpertArray = [NSMutableArray arrayWithArray:_selectedExpertArray];
        }
    }
    return _selectedExpertArray;
}

- (UIView *)promptView
{
    if (!_promptView) {
        _promptView = [[UIView alloc] init];
        _promptView.backgroundColor = [UIColor whiteColor];
        UIImageView* promptImageView = [[UIImageView alloc] init];
        promptImageView.image = [UIImage imageNamed:@"ic_quanzi_noattention"];
        
        UILabel* promptLabel1 = [[UILabel alloc] init];
        promptLabel1.text = @"想提醒专家查看您的问题？";
        promptLabel1.font = [UIFont systemFontOfSize:18];
        promptLabel1.textColor = RGBHex(qwColor9);
        
        UILabel* promptLabel2 = [[UILabel alloc] init];
        promptLabel2.text = @"那先去关注专家吧";
        promptLabel2.font = [UIFont systemFontOfSize:18];
        promptLabel2.textColor = RGBHex(qwColor9);
        
        [_promptView addSubview:promptImageView];
        [_promptView addSubview:promptLabel1];
        [_promptView addSubview:promptLabel2];
        [_promptView addSubview:self.attentionExpertBtn];
        [self.view addSubview:_promptView];
        
        PREPCONSTRAINTS(_promptView);
        PREPCONSTRAINTS(promptImageView);
        PREPCONSTRAINTS(promptLabel1);
        PREPCONSTRAINTS(promptLabel2);
        PREPCONSTRAINTS(self.attentionExpertBtn);

        ALIGN_TOPLEFT(_promptView, 0);
        ALIGN_BOTTOMRIGHT(_promptView, 0);
        
        CENTER_H(promptImageView);
        ALIGN_TOP(promptImageView, 68);
        
        LAYOUT_V(promptImageView, 28, promptLabel1);
        LAYOUT_V(promptLabel1, 5, promptLabel2);
        LAYOUT_V(promptLabel2, 21, self.attentionExpertBtn);
        CONSTRAIN_SIZE(self.attentionExpertBtn, 208, 42);
    }
    return _promptView;
}

- (UIButton *)attentionExpertBtn
{
    if (!_attentionExpertBtn) {
        _attentionExpertBtn = [[UIButton alloc] init];
        [_attentionExpertBtn setTitle:@"去关注专家" forState:UIControlStateNormal];
        _attentionExpertBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_attentionExpertBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
//        QWCSS(_attentionExpertBtn, 13, 7);
        _attentionExpertBtn.backgroundColor = RGBHex(qwColor4);
        [_attentionExpertBtn addTarget:self action:@selector(gotoALLExpertVC:) forControlEvents:UIControlEventTouchUpInside  ];
        _attentionExpertBtn.layer.masksToBounds = YES;
        _attentionExpertBtn.layer.cornerRadius = 7;
        _attentionExpertBtn.layer.borderWidth = 1;
        _attentionExpertBtn.layer.borderColor = RGBHex(qwColor10).CGColor;
    }
    return _attentionExpertBtn;
}

- (void)gotoALLExpertVC:(id)sender
{
    NSLog(@"去所有专家页面看看");
}

- (void)showPrompView:(BOOL)show
{
    if (show) {
        [self.view addSubview:self.promptView];
    }
    else
    {
        [_promptView removeFromSuperview];
        _promptView = nil;
    }
}

- (void)loadData
{
//    [Forum getAllExpertInfoSuccess:^(NSArray *expertArray_) {
//        expertArray = expertArray_;
//        [self.tableView reloadData];
//    } failure:^(HttpException *e) {
//        DebugLog(@"getAllExpertInfo error : %@", e);
//    }];
    GetMyAttnExpertListR* getMyAttnExpertListR = [GetMyAttnExpertListR new];
    getMyAttnExpertListR.token = QWGLOBALMANAGER.configure.expertToken;
    __weak typeof(self) weakSelf = self;
    [Forum getMyAttnExpertList:getMyAttnExpertListR success:^(NSArray *expertList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf removeInfoView];
            strongSelf.expertArray = expertList;
            [strongSelf showPrompView:(strongSelf.expertArray.count == 0)];
            [strongSelf.tableView reloadData];
        }
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [weakSelf showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [weakSelf showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [weakSelf showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }        DebugLog(@"getMyAttnExpertList error : %@", e);
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return expertArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewExpertTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewExpertTableCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"NewExpertTableCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewExpertTableCell* expertTableCell = [tableView cellForRowAtIndexPath:indexPath];
    QWExpertInfoModel* expertInfo = expertArray[indexPath.row];
    if ([expertTableCell isKindOfClass:[NewExpertTableCell class]]) {
        
        if (!expertTableCell.chooseBtn.selected) {
            if (self.selectedExpertArray.count >= ChooseExpert_MaxSelectExpertNum) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多可选择%ld个专家", (long)ChooseExpert_MaxSelectExpertNum]];
                return;
            }
            expertTableCell.chooseBtn.selected = YES;
            [self.selectedExpertArray addObject:expertInfo];
        }
        else
        {
            expertTableCell.chooseBtn.selected = NO;
            [self.selectedExpertArray removeObject:expertInfo];
        }
    }
}

- (void)configure:(NewExpertTableCell*)cell indexPath:(NSIndexPath*)indexPath
{
    QWExpertInfoModel* expertInfo = expertArray[indexPath.row];
    [cell showChooseBtn:YES];
    cell.chooseBtn.selected = [self.selectedExpertArray containsObject:expertInfo];
    [cell setCell:expertInfo];
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

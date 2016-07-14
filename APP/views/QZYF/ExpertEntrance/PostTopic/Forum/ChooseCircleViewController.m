//
//  ChooseCircleViewController.m
//  APP
//
//  Created by Martin.Liu on 16/6/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ChooseCircleViewController.h"
#import "Forum.h"
#import "SimpleCircleTableCell.h"
#import "SVProgressHUD.h"
#import "ConstraintsUtility.h"
#import "cssex.h"
#import "AllCircleViewController.h"

NSString *const kChooseCircleCellIdentifier = @"SimpleCircleTableCell";

@interface ChooseCircleViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic , strong) NSArray* myAttnCircleArray;
@property (nonatomic , strong) NSMutableArray* circleArray;
@property (strong, nonatomic) UIView* promptView;
@property (nonatomic, strong) UIButton* attentionCircleBtn;
@end

@implementation ChooseCircleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"选择圈子";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = RGBHex(qwColor11);
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleCircleTableCell" bundle:nil] forCellReuseIdentifier:kChooseCircleCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (NSMutableArray *)circleArray
{
    if (!_circleArray) {
        _circleArray = [NSMutableArray array];
    }
    return _circleArray;
}

- (UIView *)promptView
{
    if (!_promptView) {
        _promptView = [[UIView alloc] init];
        _promptView.backgroundColor = [UIColor whiteColor];
        UIImageView* promptImageView = [[UIImageView alloc] init];
        promptImageView.image = [UIImage imageNamed:@"ic_quanzi_noattention"];
        
        NSString* tipString = @"想分享到其他圈子?\n先去关注圈子吧";
        UILabel* promptLabel = [[UILabel alloc] init];
        promptLabel.numberOfLines = 0;
        promptLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 8;
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString* attString = [[NSAttributedString alloc] initWithString:tipString attributes:@{NSForegroundColorAttributeName:RGBHex(qwColor20), NSFontAttributeName:[UIFont systemFontOfSize:18.f],NSParagraphStyleAttributeName:style}];
        promptLabel.attributedText = attString;

    
        
        [_promptView addSubview:promptImageView];
        [_promptView addSubview:promptLabel];
        [_promptView addSubview:self.attentionCircleBtn];
        [self.view addSubview:_promptView];
        
        PREPCONSTRAINTS(_promptView);
        PREPCONSTRAINTS(promptImageView);
        PREPCONSTRAINTS(promptLabel);
        PREPCONSTRAINTS(self.attentionCircleBtn);
        
        ALIGN_TOPLEFT(_promptView, 0);
        ALIGN_BOTTOMRIGHT(_promptView, 0);
        
        CENTER_H(promptImageView);
        ALIGN_TOP(promptImageView, 68);
        
        LAYOUT_V(promptImageView, 28, promptLabel);
        LAYOUT_V(promptLabel, 21, self.attentionCircleBtn);
        CONSTRAIN_SIZE(self.attentionCircleBtn, 208, 42);
    }
    return _promptView;
}

- (UIButton *)attentionCircleBtn
{
    if (!_attentionCircleBtn) {
        _attentionCircleBtn = [[UIButton alloc] init];
        [_attentionCircleBtn setTitle:@"去关注圈子" forState:UIControlStateNormal];
        _attentionCircleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_attentionCircleBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        _attentionCircleBtn.backgroundColor = RGBHex(qwColor4);
        [_attentionCircleBtn addTarget:self action:@selector(gotoALLCircleVC:) forControlEvents:UIControlEventTouchUpInside];
        _attentionCircleBtn.layer.masksToBounds = YES;
        _attentionCircleBtn.layer.cornerRadius = 7;
        _attentionCircleBtn.layer.borderWidth = 1;
        _attentionCircleBtn.layer.borderColor = RGBHex(qwColor10).CGColor;
    }
    return _attentionCircleBtn;
}

- (void)gotoALLCircleVC:(id)sender
{
    AllCircleViewController* allCircleVC = (AllCircleViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"AllCircleViewController"];
    [self.navigationController pushViewController:allCircleVC animated:YES];
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
    GetSyncTeamListR* getSyncTeamListR = [GetSyncTeamListR new];
    getSyncTeamListR.token = QWGLOBALMANAGER.configure.expertToken;
    getSyncTeamListR.type = 2;
    __weak __typeof(self) weakSelf = self;
    [Forum getSyncTeamList:getSyncTeamListR success:^(QWSyncTeamListModel *syncTeamListModel) {
        if ([syncTeamListModel.apiStatus integerValue] == 0) {
            [weakSelf removeInfoView];
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.circleArray removeAllObjects];
                [strongSelf.circleArray addObjectsFromArray:syncTeamListModel.teamInfoList];
                [strongSelf showPrompView:(strongSelf.circleArray.count == 0)];
                [strongSelf.tableView reloadData];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:syncTeamListModel.apiMessage duration:DURATION_LONG];
        };
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
        }
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.circleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleCircleTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kChooseCircleCellIdentifier forIndexPath:indexPath];
    if (self.circleArray.count > indexPath.row) {
        QWCircleModel* circle = self.circleArray[indexPath.row];
        cell.chooseBtn.selected = [circle isEqual:self.selectedCircleModel];
        [cell setCell:circle];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.circleArray.count > indexPath.row) {
        QWCircleModel* circle = self.circleArray[indexPath.row];
        self.selectedCircleModel = circle;
        [self.tableView reloadData];
        if (self.SelectCircleBlock) {
            self.SelectCircleBlock(self.selectedCircleModel);
        }
        [self popVCAction:nil];
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

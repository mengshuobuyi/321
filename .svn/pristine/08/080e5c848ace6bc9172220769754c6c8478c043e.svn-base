//
//  CircleDetailViewController.m
//  APP
//
//  Created by Martin.Liu on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWCircleDetailViewController.h"
#import "PostInCircleTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "QCSlideSwitchView.h"
#import "CirclePostListViewController.h"
#import "UILabel+MAAttributeString.h"
#import "Forum.h"
#import "CirclerListViewController.h"
#import "SVProgressHUD.h"
@interface QWCircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,QCSlideSwitchViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;
@property (nonatomic, strong) NSMutableArray* sliderViewControllers;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *circleSubTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *circleDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *circlerCountTipLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstPositionImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondPositionImageView;

@property (nonatomic, strong) QWCircleModel* circleModel;

@property (strong, nonatomic) IBOutlet UIButton *careBtn;


- (IBAction)careBtnAction:(UIButton*)sender;

- (IBAction)expandBtnAction:(UIButton *)sender;
- (IBAction)circlerListBtnAction:(id)sender;

@end

@implementation QWCircleDetailViewController
{
    CGFloat rowHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    rowHeight = 300;
    [self configChildrenViewControllers];
    [self setupSliderView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PostInCircleTableCell" bundle:nil] forCellReuseIdentifier:@"PostInCircleTableCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellReuseIdentifier"];

    [self loadCircleData];
}

- (void)UIGlobal
{
    self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS1];
    [self.careBtn setTitleColor:RGBHex(qwMcolor4) forState:UIControlStateNormal];
    self.careBtn.backgroundColor = RGBHex(qwMcolor1);
    self.careBtn.layer.masksToBounds = YES;
    self.careBtn.layer.cornerRadius = 4;
    
    // 隐藏圈子介绍标签
    [self.circleDescriptionLabel ma_setAttributeText:nil];
    [self resetTableHearderViewHeight];
}

// 重新显示表格头视图的高度
- (void)resetTableHearderViewHeight
{
    
    CGRect headerFrame = self.tableHeaderView.frame;
    headerFrame.size.height = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableHeaderView.frame = headerFrame;
    self.tableView.tableHeaderView = self.tableHeaderView;

}

// 获取圈子信息
- (void)loadCircleData
{
    if (!StrIsEmpty(self.circleId)) {
        GetCircleDetailsInfoR* getCircleDetailInfoR = [GetCircleDetailsInfoR new];
        getCircleDetailInfoR.token = QWGLOBALMANAGER.configure.userToken;
        getCircleDetailInfoR.teamId = self.circleId;
        [Forum getCircleDetailsInfo:getCircleDetailInfoR success:^(QWCircleModel *responseModel) {
            self.circleModel = responseModel;
        } failure:^(HttpException *e) {
            DebugLog(@"error : %@", e);
        }];
    }
}

- (void)setCircleModel:(QWCircleModel *)circleModel
{
    _circleModel = circleModel;
    if (_circleModel) {
        [self.circleImageView setImageWithURL:[NSURL URLWithString:_circleModel.teamLogo] placeholderImage:ForumDefaultImage];
        self.circleTitleLabel.text = _circleModel.teamName;
        self.circleSubTitleLabel.text = [NSString stringWithFormat:@"%ld人关注    %ld个帖子", (long)_circleModel.attnCount, (long)_circleModel.postCount];
//        [self.circleDescriptionLabel ma_setAttributeText:_circleModel.teamDesc];
//        [self resetTableHearderViewHeight];
        [self setAttention:_circleModel.flagAttn];
        
        self.circlerCountTipLabel.text = [NSString stringWithFormat:@"查看圈主(%ld)", (long)_circleModel.master];
        
        NSMutableArray* imageNameArray = [NSMutableArray array];
        if (_circleModel.flagPhar) {
            [imageNameArray addObject:@"pharmacist"];
        }
        if (_circleModel.flagDietitian) {
            [imageNameArray addObject:@"ic_expert"];
        }
        switch (MIN(2, imageNameArray.count)) {
            case 2:
                self.firstPositionImageView.image = [UIImage imageNamed:imageNameArray[0]];
                self.secondPositionImageView.image = [UIImage imageNamed:imageNameArray[1]];
                break;
            case 1:
                self.firstPositionImageView.image = [UIImage imageNamed:imageNameArray[0]];
                self.secondPositionImageView.image = nil;
            default:
                self.firstPositionImageView.image = nil;
                self.secondPositionImageView.image = nil;
                break;
        }
    }
}
// 是否关注
- (void)setAttention:(BOOL)attentionFlag
{
    if (attentionFlag) {
        [self.careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.careBtn setBackgroundColor:RGBHex(qwGcolor8)];
    }
    else
    {
        [self.careBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.careBtn setBackgroundColor:RGBHex(qwMcolor1)];
    }
}

- (void)setupSliderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, rowHeight)];
    [self.slideSwitchView.rootScrollView setFrame:CGRectMake(0, 0, APP_W, self.slideSwitchView.rootScrollView.bounds.size.height)];
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwGcolor7);
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwMcolor4)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwMcolor1);
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(kFontS4)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 34.5, APP_W, 0.5)];
//    line.backgroundColor = RGBHex(qwGcolor10);
//    [self.slideSwitchView.topScrollView addSubview:line];
    
//    self.slideSwitchView.rootScrollView.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)sliderViewControllers
{
    if (!_sliderViewControllers) {
        _sliderViewControllers = [NSMutableArray array];
        
        CirclePostListViewController* postListVC1 = [CirclePostListViewController new];
        postListVC1.circleId = self.circleId;
        postListVC1.sortType = CirclePostType_Nomal;
        postListVC1.title = @"看帖";
        postListVC1.navigationController = self.navigationController;
        
        CirclePostListViewController* postListVC2 = [CirclePostListViewController new];
        postListVC2.circleId = self.circleId;
        postListVC2.sortType = CirclePostType_Hot;
        postListVC2.title = @"热门";
        postListVC2.navigationController = self.navigationController;
        
        CirclePostListViewController* postListVC3 = [CirclePostListViewController new];
        postListVC3.circleId = self.circleId;
        postListVC3.sortType = CirclePostType_Expert;
        postListVC3.title = @"专家";
        postListVC3.navigationController = self.navigationController;
        [_sliderViewControllers addObject:postListVC1];
        [_sliderViewControllers addObject:postListVC2];
        [_sliderViewControllers addObject:postListVC3];
    }
    return _sliderViewControllers;
}

- (void)configChildrenViewControllers
{
    CirclePostListViewController* postListVC1 = [CirclePostListViewController new];
    postListVC1.circleId = self.circleId;
    postListVC1.sortType = CirclePostType_Nomal;
    postListVC1.title = @"看帖";
    postListVC1.navigationController = self.navigationController;
    
    CirclePostListViewController* postListVC2 = [CirclePostListViewController new];
    postListVC2.circleId = self.circleId;
    postListVC2.sortType = CirclePostType_Hot;
    postListVC2.title = @"热门";
    postListVC2.navigationController = self.navigationController;
    
    CirclePostListViewController* postListVC3 = [CirclePostListViewController new];
    postListVC3.circleId = self.circleId;
    postListVC3.sortType = CirclePostType_Expert;
    postListVC3.title = @"专家";
    postListVC3.navigationController = self.navigationController;
    [self addChildViewController:postListVC1];
    [self addChildViewController:postListVC2];
    [self addChildViewController:postListVC3];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51; // 35 + 8 + 8
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, height)];
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 8)];
    separatorView1.backgroundColor = RGBHex(0xecf0f1);
    [view addSubview:separatorView1];
    
    UIView* separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(0, height - 8, APP_W, 8)];
    separatorView2.backgroundColor = RGBHex(0xecf0f1);
    [view addSubview:separatorView2];
    
    UIView* scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, APP_W, height - 16)];
    [scrollView addSubview:self.slideSwitchView.topScrollView];
    [view addSubview:scrollView];

    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostInCircleTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
//    self.slideSwitchView.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.slideSwitchView];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    [cell setCell:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView fd_heightForCellWithIdentifier:@"PostInCircleTableCell" configuration:^(id cell) {
//        [self configure:cell indexPath:indexPath];
//    }];
    return rowHeight;
}

#pragma mark - QCSlider Delegate
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return self.childViewControllers.count;
//    return self.sliderViewControllers.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.childViewControllers[number];
//    return self.sliderViewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view willselectTab:(NSUInteger)number
{
    CirclePostListViewController* postListVC = self.childViewControllers[number];
//    CirclePostListViewController* postListVC = self.sliderViewControllers[number];
    [postListVC currentViewSelected:^(CGFloat height) {
        rowHeight = height;
        [self.slideSwitchView setFrame:CGRectMake(0, 0, APP_W, rowHeight)];
        [self.tableView reloadData];
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

- (IBAction)careBtnAction:(UIButton*)sender {
//    DebugLog(@"UUID: %@", [QWGLOBALMANAGER randomUUID]);
    AttentionCircleR* attentionCircleR = [AttentionCircleR new];
    attentionCircleR.teamId = self.circleModel.teamId;
    attentionCircleR.isAttentionTeam = self.circleModel.flagAttn ? 1 : 0;
    attentionCircleR.token = QWGLOBALMANAGER.configure.userToken;
    [Forum attentionCircle:attentionCircleR success:^(BaseAPIModel *baseAPIModel) {
        if ([baseAPIModel.apiStatus integerValue] == 0) {
            self.circleModel.flagAttn = !self.circleModel.flagAttn;
            [self setAttention:_circleModel.flagAttn];
        }
        else
        {
            if (!StrIsEmpty(baseAPIModel.apiMessage)) {
                [SVProgressHUD showErrorWithStatus:baseAPIModel.apiMessage];
            }
        }
    } failure:^(HttpException *e) {
        DebugLog(@"attention circle error : %@", e);
    }];

}

- (IBAction)expandBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    CGRect headerFrame = self.tableHeaderView.frame;
    if (sender.selected) {
        [self.circleDescriptionLabel ma_setAttributeText:_circleModel.teamDesc];
    }
    else
    {
        [self.circleDescriptionLabel ma_setAttributeText:nil];
    }
    headerFrame.size.height = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [self.tableView beginUpdates];
    self.tableHeaderView.frame = headerFrame;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView endUpdates];
}


- (IBAction)circlerListBtnAction:(id)sender {
    if (_circleModel && _circleModel.master > 0) {
        CirclerListViewController* circlerListVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"CirclerListViewController"];
        circlerListVC.hidesBottomBarWhenPushed = YES;
        circlerListVC.circleId = self.circleId;
        [self.navigationController pushViewController:circlerListVC animated:YES];
    }
}
@end

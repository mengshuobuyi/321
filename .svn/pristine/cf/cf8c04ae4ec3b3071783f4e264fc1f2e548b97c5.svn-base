//
//  MemeberRootListViewController.m
//  wenYao-store
//
//  会员营销root列表页面
//  h5/mmall/mktg/queryNcds   - 列表
//  Created by PerryChen on 5/5/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemeberRootListViewController.h"
#import "MemberMarketSelectUserViewController.h"
#import "MemberCollectionViewCell.h"
#import "MemberMarket.h"
#import "MemberMarketModel.h"
#import "SearchDefineViewController.h"
#import "MemberGroupNCDListViewController.h"
#import "WebDirectViewController.h"
@interface MemeberRootListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *memberListCollectionView;
@property (weak, nonatomic) IBOutlet UIView *memberListFooterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCollectionBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHelpButtonWidth;
@property (nonatomic, strong) NSMutableArray *arrMembers;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberNum;
@property (nonatomic, strong) MemberNcdListVo *modelVo;

@end

@implementation MemeberRootListViewController
#define PADDING_ITEM 5
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"memberRootCollectionCell" bundle:nil];
    [self.memberListCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"MemberCollectionViewCell"];
    
    self.arrMembers = [NSMutableArray array];
    self.modelVo = [MemberNcdListVo new];
    if (AUTHORITY_ROOT) {       // 店长
        self.navigationItem.title = @"会员营销";
        self.constraintCollectionBottom.constant = 44.0f;//*kAutoScale;//
//        self.constraintHelpButtonWidth.constant = 44.0f*kAutoScale;
        self.memberListFooterView.hidden = NO;
    } else {
        self.navigationItem.title = @"会员";
        self.constraintCollectionBottom.constant = 0.0f;
        self.memberListFooterView.hidden = YES;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self constructBaseUI];
    [self setupRightItem];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    } else {
        [self getAllMembers];
    }
    
    
    // Do any additional setup after loading the view.
}

 /**
 *  获取所有会员标签
 */
- (void)getAllMembers
{
    MarketMemberNcdsModelR *modelR = [MarketMemberNcdsModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [MemberMarket queryCustomerNcds:modelR success:^(MemberNcdListVo *responseModel) {
        if (responseModel.ncds.count > 0) {
            self.arrMembers = [responseModel.ncds mutableCopy];
            self.lblMemberNum.text = [NSString stringWithFormat:@"我的会员: %@人",responseModel.counts];
            [self.memberListCollectionView reloadData];
        } else {
            [self showInfoView:@"暂无分组" image:@"ic_img_fail"];
        }
    } failure:^(HttpException *e) {
        
    }];
}

/**
 *  创建基础的placeholderUI
 */
- (void)constructBaseUI
{
    self.lblMemberNum.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToMemeberMarket"]) {
    }
}

/**
 *  设置导航栏右侧按钮
 */
- (void)setupRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    //三个点button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, -2, 50, 40);
    [button setImage:[UIImage imageNamed:@"navBar_icon_search_white"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navBar_icon_search_white_click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
}

/**
 *  点击导航栏右侧按钮事件
 */
- (void)rightAction
{
    [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_ss" withLable:@"会员营销" withParams:nil];
    SearchDefineViewController *searchV = [[SearchDefineViewController alloc] initWithNibName:@"SearchDefineViewController" bundle:nil];
    searchV.fromWechatMemberMarket = YES;
    searchV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchV animated:YES];
}

#pragma mark - UIButton actions
/**
 *  跳转到帮助页面
 *
 *  @param sender
 */
- (IBAction)btnPressedHelp:(id)sender {
    WebDirectLocalModel *modelDirect = [WebDirectLocalModel new];
    modelDirect.typeLocalWeb = WebLocalTypeMemberMarketHelp;
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    [vcWebDirect setWVWithLocalModel:modelDirect];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

/**
 *  跳转到自主营销页面
 *
 *  @param sender 
 */
- (IBAction)btnPressedToMemberMarket:(id)sender {
    [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_zzyx" withLable:@"会员营销" withParams:nil];
    [self performSegueWithIdentifier:@"segueToMemeberMarket" sender:sender];
}

#pragma mark - UICollection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrMembers.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberNcdVo *model = self.arrMembers[indexPath.item];
    MemberCollectionViewCell *cell = (MemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MemberCollectionViewCell" forIndexPath:indexPath];
    cell.lblMemberInfo.text = model.ncdName;
    cell.lblMemberCount.text = [NSString stringWithFormat:@"%@ 人",model.userCounts];
    [cell setCellContent];
    return  cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat scaleX = 320 / self.view.frame.size.width;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, PADDING_ITEM / scaleX, PADDING_ITEM / scaleX, PADDING_ITEM / scaleX);
    return  insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scaleX = 320 / self.view.frame.size.width;
    CGFloat itemWidth = (self.view.frame.size.width - (PADDING_ITEM / scaleX) * 4) / 3;
    CGFloat scaleWH = 100.0 / 70.0;
    CGFloat itemHeight = itemWidth / scaleWH;
    CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat scaleX = 320 / self.view.frame.size.width;
    return PADDING_ITEM / scaleX;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat scaleX = 320 / self.view.frame.size.width;
    return PADDING_ITEM / scaleX;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_hyfl" withLable:@"会员营销" withParams:nil];
    MemberNcdVo *model = self.arrMembers[indexPath.item];
    MemberGroupNCDListViewController *vcMember = [[UIStoryboard storyboardWithName:@"MemberGroup" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberGroupNCDListViewController"];
    vcMember.hidesBottomBarWhenPushed = YES;
    vcMember.modelNcd = model;
    [self.navigationController pushViewController:vcMember animated:YES];
}

@end

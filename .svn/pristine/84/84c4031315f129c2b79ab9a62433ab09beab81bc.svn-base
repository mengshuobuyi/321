//
//  MemberMarketSelectUserViewController.m
//  wenYao-store
//
//  会员营销选择会员页面
//  h5/mmall/mktg/check
//  h5/mmall/mktg/queryNcds   - 列表
//  Created by PerryChen on 5/9/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberMarketSelectUserViewController.h"
#import "MemberMarketContentViewController.h"
#import "MemberCollectionViewCell.h"
#import "MemberSelectReusableView.h"
#import "MemberMarketSelectOrderNumView.h"
#import "MemberMarketSuccessStepTwoView.h"
#import "MemberMarket.h"

@interface MemberMarketSelectUserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, memberSelectReuseDelegate,selectOrderNumDelegate,MemberMarketSuccessTwoDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewContent;
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintResetWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewFooterHeight;

@property (nonatomic, assign) NSInteger intSelectGender; // 1 all 2 male 3 female
@property (nonatomic, assign) NSInteger intSelectMemberGroup;
@property (nonatomic, strong) NSMutableArray *arrSelectGroup;
@property (nonatomic, assign) NSInteger intSelectOrderNum;  // 0 不限 1 1-2单 2 3-5单 3 5单以上
@property (nonatomic, strong) NSMutableArray *arrMembers;
@property (nonatomic, strong) MemberCheckVo *modelSelectVo;
@end

@implementation MemberMarketSelectUserViewController
#define PADDING_ITEM 5
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择会员";
    UINib *cellNib = [UINib nibWithNibName:@"memberRootCollectionCell" bundle:nil];
    [self.collectionViewContent registerNib:cellNib forCellWithReuseIdentifier:@"MemberCollectionViewCell"];
    self.collectionViewContent.hidden = YES;
    self.intSelectGender = 0;
    self.intSelectMemberGroup = 0;
    self.intSelectOrderNum = 0;
    // 未来6P可能的适配
//    self.constraintResetWidth.constant = 100*kAutoScale;
//    self.constraintViewFooterHeight.constant = 44*kAutoScale;
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    self.arrSelectGroup = [NSMutableArray array];
    self.arrMembers = [NSMutableArray array];
    [self actionReset:nil];
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
    [MemberMarket queryMktgNcds:modelR success:^(MemberNcdListVo *responseModel) {
    if (responseModel.ncds.count > 0) {
        self.collectionViewContent.hidden = NO;
        self.modelList = responseModel;
        [self.collectionViewContent reloadData];
    } else {
        [self showInfoView:@"暂无分组" image:@"ic_img_fail"];
    }
    } failure:^(HttpException *e) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置性别之类的
 */
- (void)setNextStepViewStatus
{
    BOOL setContent = NO;
//    if (self.intSelectGender > 0) {
//        setContent = YES;
//    }
//    if (self.intSelectOrderNum >= 0) {
//        setContent = YES;
//    }
    if ((self.intSelectGender == 1)&&(self.intSelectOrderNum == 0)&&(self.arrSelectGroup.count == 0)) {
        setContent = NO;
    } else {
        setContent = YES;
    }
//    if (self.arrSelectGroup.count > 0) {
//        setContent = YES;
//    }
    if (setContent == YES) {
        self.viewFooter.backgroundColor = RGBHex(qwColor2);
        [self.btnNextStep setEnabled:YES];
    } else {
        self.viewFooter.backgroundColor = RGBHex(qwColor9);
        [self.btnNextStep setEnabled:NO];
    }
}


#pragma mark - Navigation
- (void)actionConfirm
{
    
}

- (void)showCompleteView
{
    MemberMarketSuccessStepTwoView *view = [[NSBundle mainBundle]loadNibNamed:@"MemberMarketSuccessStepTwoView" owner:nil options:nil][0];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    NSString *strContent = [NSString stringWithFormat:@"您本次的营销，共营销了%@人。可以在会员营销统计中查看本次营销信息",self.modelSelectVo.counts];
    [view setViewContent:strContent];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:view];
    view.delegate = self;
    view.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
    }];

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToContent"]) {
        MemberMarketContentViewController *vc = segue.destinationViewController;
        vc.modelCheck = self.modelSelectVo;
        vc.block = ^(){
            [self actionReset:nil];
        };
        vc.blockComplete = ^(){
            [self actionReset:nil];
            [self showCompleteView];
            [self getAllMembers];
        };
    }
}

/**
 *  检查积分是否够用
 */
- (void)actionCheckMembers
{
    MarketCheckMarkModelR *modelR = [MarketCheckMarkModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    if (self.intSelectGender == 1) {
        modelR.sex = @"";
    } else if (self.intSelectGender == 2) {
        modelR.sex = @"M";
    } else if (self.intSelectGender == 3) {
        modelR.sex = @"F";
    }
    if (self.intSelectOrderNum == 0) {
        modelR.min = @"";
        modelR.max = @"";
    } else if (self.intSelectOrderNum == 1) {
        modelR.min = @"1";
        modelR.max = @"2";
    } else if (self.intSelectOrderNum == 2) {
        modelR.min = @"3";
        modelR.max = @"5";
    } else if (self.intSelectOrderNum == 3) {
        modelR.min = @"5";
        modelR.max = @"";
    }
    NSMutableArray *arrIds = [NSMutableArray array];
    NSInteger intTotalSelect = 0;
    for (MemberNcdVo *modelVo in self.arrSelectGroup) {
        [arrIds addObject:modelVo.ncdId];
        intTotalSelect += [modelVo.userCounts intValue];
    }
    
    NSString *strNcd = [arrIds componentsJoinedByString:SeparateStr];
    modelR.ncd = strNcd;
    [MemberMarket queryMktgCheck:modelR success:^(MemberCheckVo *responseModel) {
        if ([responseModel.apiStatus intValue] != 0) {
            if ([responseModel.apiStatus intValue] == 2020001) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:responseModel.apiMessage delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] show];
            } else {
                [self showError:responseModel.apiMessage];
            }
        } else {
            self.modelSelectVo = responseModel;
            [self performSegueWithIdentifier:@"segueToContent" sender:nil];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}

#pragma mark - UIButton action
/**
 *  重置
 *
 *  @param sender <#sender description#>
 */
- (IBAction)actionReset:(UIButton *)sender {
    self.intSelectGender = 1;
    self.intSelectMemberGroup = 0;
    self.intSelectOrderNum = 0;
    [self.arrSelectGroup removeAllObjects];
    for (MemberNcdVo *model in self.modelList.ncds) {
        model.isSelected = NO;
    }
    [self.collectionViewContent reloadData];
    [self setNextStepViewStatus];
}

/**
 *  下一步
 *
 *  @param sender <#sender description#>
 */
- (IBAction)actionNextStep:(UIButton *)sender {
    [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzhy_xyb" withLable:@"会员营销" withParams:nil];
    [self actionCheckMembers];
}

#pragma mark - select order num action
- (void)chooseOrderNum:(NSInteger)intSelect
{
    self.intSelectOrderNum = intSelect;
    [self.collectionViewContent reloadData];
    [self setNextStepViewStatus];
}

#pragma mark - UICollectionView reuse delegate methods
/**
 *  选择订单
 */
- (void)chooseOrderNum
{
    MemberMarketSelectOrderNumView *view = [[NSBundle mainBundle]loadNibNamed:@"MemberMarketSelectOrderNumView" owner:nil options:nil][0];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:view];
    view.delegate = self;
    [UIView animateWithDuration:0.25 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        view.selectOrderNo = self.intSelectOrderNum;
        [view setViewSelectStyle];
    }];
}

- (void)chooseGender:(NSInteger)intGender
{
    self.intSelectGender = intGender;
    [self.collectionViewContent reloadData];
    [self setNextStepViewStatus];
}

#pragma mark - UICollection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelList.ncds.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberNcdVo *model = self.modelList.ncds[indexPath.item];
    MemberCollectionViewCell *cell = (MemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MemberCollectionViewCell" forIndexPath:indexPath];
    cell.lblMemberInfo.text = model.ncdName;
    cell.lblMemberCount.text = [NSString stringWithFormat:@"%@ 人",model.userCounts];
    cell.showBorder = YES;
    cell.isSelected = NO;
    if (model.isSelected == YES) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    [cell setCellContent];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberNcdVo *model = self.modelList.ncds[indexPath.item];
    if (model.isSelected) {
        [self.arrSelectGroup removeObject:model];
    } else {
        [self.arrSelectGroup addObject:model];
    }
    model.isSelected = !model.isSelected;
    [self.collectionViewContent reloadData];
    [self setNextStepViewStatus];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *resuableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        MemberSelectReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"memberSelectView" forIndexPath:indexPath];
        headerView.imgViewMale.hidden = headerView.imgViewFemale.hidden = headerView.imgViewAllGender.hidden = YES;
        headerView.viewMale.layer.borderColor = headerView.viewFemale.layer.borderColor = headerView.viewAllGender.layer.borderColor = RGBHex(qwColor10).CGColor;
        headerView.viewMale.layer.borderWidth = headerView.viewFemale.layer.borderWidth = headerView.viewAllGender.layer.borderWidth = 0.5;
        headerView.viewMale.layer.cornerRadius = headerView.viewFemale.layer.cornerRadius = headerView.viewAllGender.layer.cornerRadius = 2.0f;
        headerView.viewMale.layer.masksToBounds = headerView.viewFemale.layer.masksToBounds = headerView.viewAllGender.layer.masksToBounds = YES;
        headerView.viewStepOne.layer.cornerRadius = headerView.viewStepTwo.layer.cornerRadius = 2.0f;
        headerView.delegate = self;
        headerView.lblMemberSelect.text = [NSString stringWithFormat:@"当前商家积分还能营销%@人",self.modelList.mktgCounts];
        if (self.intSelectGender == 1) {
            headerView.imgViewAllGender.hidden = NO;
            headerView.viewAllGender.layer.borderColor = RGBHex(qwColor2).CGColor;
        } else if (self.intSelectGender == 2) {
            headerView.imgViewMale.hidden = NO;
            headerView.viewMale.layer.borderColor = RGBHex(qwColor2).CGColor;
        } else if (self.intSelectGender == 3) {
            headerView.imgViewFemale.hidden = NO;
            headerView.viewFemale.layer.borderColor = RGBHex(qwColor2).CGColor;
        }
        
        if (self.intSelectOrderNum == 0) {
            headerView.lblOrderNum.text = @"不限";
        } else if (self.intSelectOrderNum == 1) {
            headerView.lblOrderNum.text = @"1-2单";
        } else if (self.intSelectOrderNum == 2) {
            headerView.lblOrderNum.text = @"3-5单";
        } else if (self.intSelectOrderNum == 3) {
            headerView.lblOrderNum.text = @"5单以上";
        }
        resuableView = headerView;
    }
    
    return resuableView;
}

@end

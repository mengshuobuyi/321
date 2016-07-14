//
//  MyLevelInfoViewController.m
//  wenYao-store
//  我的等级页面
//  我的等级接口 QueryEmpLvlInfo
//  Created by qw_imac on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyLevelInfoViewController.h"
#import "LevelCollectionViewCell.h"
#import "LevelInfoTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "WebDirectViewController.h"
#import "Employee.h"
#import "UIImageView+WebCache.h"
#import "LevelUpAlertView.h"
@interface MyLevelInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *levelInfoArray;
    NSArray             *imgArray;
    NSArray             *selectedImgArray;
    NSArray             *highLightImgArray;
    NSInteger           clickIndex;
    NSInteger           levelIndex;
    LevelUpAlertView    *levelupView;
}
@property (weak, nonatomic) IBOutlet UICollectionView   *levelCollectionView;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) IBOutlet UIView           *oneHeader;
@property (strong, nonatomic) IBOutlet UIView           *twoHeader;
@property (weak, nonatomic) IBOutlet UILabel            *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel            *nexLevelLabel;
@property (nonatomic,strong)EmpLvlInfoVo                *infoVo;
@property (nonatomic,strong)NSMutableArray              *nextLevelArray;
@end

@implementation MyLevelInfoViewController
static NSString *const collectionCellIdentifier = @"LevelCollectionViewCell";
static NSString *const levelInfoCellIdentifier = @"LevelInfoTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的等级";
    [self setNaviItem];
    [_levelCollectionView registerNib:[UINib nibWithNibName:@"LevelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionCellIdentifier];
    _levelCollectionView.showsHorizontalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"LevelInfoTableViewCell" bundle:nil] forCellReuseIdentifier:levelInfoCellIdentifier];
    imgArray = @[@"my_btn_one_normal",@"my_btn_two_normal",@"my_btn_three_normal",@"my_btn_four_normal",@"my_btn_five_normal",@"my_btn_six_normal"];
    selectedImgArray = @[@"my_btn_one_select",@"my_btn_two_select",@"my_btn_three_select",@"my_btn_four_select",@"my_btn_five_select",@"my_btn_six_select"];
    highLightImgArray = @[@"my_btn_one_this",@"my_btn_two_this",@"my_btn_three_this",@"my_btn_four_this",@"my_btn_five_this",@"my_btn_six_this"];
    clickIndex = -1;
    levelIndex = -1;
    levelInfoArray = [@[] mutableCopy];
    [self queryEmpInfoData];
}

-(void)setNaviItem {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"my_ic_ask"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(levelDetail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = naviBtn;
}
//等级说明
-(void)levelDetail {
    WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
    modelLocal.typeLocalWeb = WebLocalTypeOuterLink;
    modelLocal.title = @"等级说明";
    modelLocal.url = [NSString stringWithFormat:@"%@QWSH/web/ruleDesc/html/gradeExplain.html",H5_BASE_URL];
    [vcWebMedicine setWVWithLocalModel:modelLocal];
    [self.navigationController pushViewController:vcWebMedicine animated:YES];
}
//等级转换等级名称
-(NSString *)matchLvl:(NSUInteger)lvl {
    NSString *lvlStr = @"";
    switch (lvl) {
        case 0:
            lvlStr = @"销售新手";
            break;
        case 1:
            lvlStr = @"销售能手";
            break;
        case 2:
            lvlStr = @"销售骨干";
            break;
        case 3:
            lvlStr = @"销售达人";
            break;
        case 4:
            lvlStr = @"销售专家";
            break;
        case 5:
            lvlStr = @"销售大师";
            break;
    }
    return lvlStr;
}
#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LevelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    if (indexPath.item == levelIndex) {
        cell.nickImg.hidden = NO;
        if (levelIndex == clickIndex) {
            cell.arrowImg.hidden = NO;
        }else {
            cell.arrowImg.hidden = YES;
        }
        [cell.nickImg setImageWithURL:[NSURL URLWithString:_infoVo.headImg] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
        cell.showImg.image = [UIImage imageNamed:selectedImgArray[indexPath.item]];
    }else {
        cell.nickImg.hidden = YES;
        if (indexPath.item != clickIndex) {
            cell.showImg.image = [UIImage imageNamed:imgArray[indexPath.item]];
            cell.arrowImg.hidden = YES;
        }else {
            cell.showImg.image = [UIImage imageNamed:highLightImgArray[indexPath.item]];
            cell.arrowImg.hidden = NO;
        }
    }
    cell.memberLevel.text = [self matchLvl:indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    clickIndex = indexPath.item;
   levelInfoArray = [self matchLvlInfo:clickIndex];
    [_tableView reloadData];
    [collectionView reloadData];
}
//sectionHeader
-(void)matchSectionHeaderTitle {
    if (clickIndex == levelIndex) {
        _levelLabel.text = @"当前等级说明";
        NSString *levelInfo = [self matchLvl:clickIndex + 1];
        _nexLevelLabel.text = [NSString stringWithFormat:@"%@",levelInfo];
    }else {
        NSString *levelInfo = [self matchLvl:clickIndex];
        _levelLabel.text = levelInfo;
    }
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(levelIndex == clickIndex) {
        return 2;
    }else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return levelInfoArray.count;
    }else {
        return _nextLevelArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LevelInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:levelInfoCellIdentifier forIndexPath:indexPath];
    [self configerCell:cell for:indexPath];
    return cell;
}

-(void)configerCell:(LevelInfoTableViewCell *)cell for:(NSIndexPath *)indexPath {
    NSMutableArray *array = [@[] mutableCopy];
    if (indexPath.section == 0) {
        array = levelInfoArray;
    }else {
        array = _nextLevelArray;
    }
    ShowType type;
    if (array.count == 1) {
        type = ShowTypeOnlyOne;
    }else {
        if (indexPath.row == 0) {
            type = ShowTypeTop;
        }else if (indexPath.row == array.count -1){
            type = ShowTypeBottom;
        }else {
            type = ShowTypeMid;
        }
    }
    [cell setCell:array[indexPath.row] With:type];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return  [tableView fd_heightForCellWithIdentifier:levelInfoCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configerCell:cell for:indexPath];
   }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self matchSectionHeaderTitle];
    if(section == 0){
        return _oneHeader;
    }else {
        return _twoHeader;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7.0;
}

#pragma mark - queryData
-(void)queryEmpInfoData {
    EmployeeLvlInfoR *modelR = [EmployeeLvlInfoR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken?QWGLOBALMANAGER.configure.userToken:@"";
    [Employee employeeQueryEmpLvlInfo:modelR success:^(EmpLvlInfoVo *response) {
        self.infoVo = response;
        if (response.upgrade) {
            [self showLevelupView];
        }
        if (response.apiStatus.integerValue == 0) {
            levelIndex = response.lvl.integerValue;
            clickIndex = levelIndex;
            levelInfoArray =[self matchLvlInfo:clickIndex];
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:clickIndex inSection:0];
            [_levelCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [_levelCollectionView reloadData];
            [_tableView reloadData];
            [self matchSectionHeaderTitle];
        }
    } failure:^(HttpException *e) {
        
    }];
}
//升级提示框
-(void)showLevelupView {
    if (!levelupView) {
        levelupView = [[NSBundle mainBundle]loadNibNamed:@"LevelUpAlertView" owner:nil options:nil][0];
        levelupView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    }
    NSInteger lvl = _infoVo.lvl.integerValue;
    [levelupView setAlertView:_infoVo.name With:[self matchLvl:lvl] And:lvl + 1];
    levelupView.bgView.alpha = 0.0;
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:levelupView];
    [UIView animateWithDuration:0.5 animations:^{
        levelupView.bgView.alpha = 0.4;
        levelupView.contentView.hidden = NO;
    }];
}

-(void)setInfoVo:(EmpLvlInfoVo *)infoVo {
    _infoVo = infoVo;
    NSString *rule1 = [NSString stringWithFormat:@"订单处理%@单",infoVo.trade];
    NSString *rule2 = [NSString stringWithFormat:@"成长值%@",infoVo.growth];
    if(infoVo.lvl.integerValue != 5){//到达顶级下面隐藏
        self.nextLevelArray = [@[rule1,rule2] mutableCopy];
    }else {
        self.nextLevelArray = [@[] mutableCopy];
    }
}

-(void)setNextLevelArray:(NSMutableArray *)nextLevelArray {
    _nextLevelArray = nextLevelArray;
    [_tableView reloadData];
}

-(NSMutableArray *)matchLvlInfo:(NSUInteger)lvl {
    NSString *lvlStrInfo = @"";
    switch (lvl) {
        case 0:
            lvlStrInfo = @"你还是销售新手，快去提升你的等级吧!";
            break;
        case 1:
            lvlStrInfo = @"您当前等级是销售能手，可在积分商城中兑换专属等级的商品!";
            break;
        case 2:
            lvlStrInfo = @"您当前等级是销售骨干，可在积分商城中兑换专属等级的商品!";
            break;
        case 3:
            lvlStrInfo = @"您当前等级是销售达人，可在积分商城中兑换专属等级的商品!";
            break;
        case 4:
            lvlStrInfo = @"您当前等级是销售专家，可在积分商城中兑换专属等级的商品!";
            break;
        case 5:
            lvlStrInfo = @"您当前等级是销售大师，可在积分商城中兑换专属等级的商品!";
            break;
    }
//    NSMutableArray *array = [@[@"可以在积分商城中兑换指定等级商品",@"销售达人等级以上（包含）可以获得全维平台提供的专属礼品一份",lvlStrInfo,@"销售精英会在问药app展示你的风采"] mutableCopy];
    NSMutableArray *array = [@[lvlStrInfo] mutableCopy];
    return [array mutableCopy];
}
@end

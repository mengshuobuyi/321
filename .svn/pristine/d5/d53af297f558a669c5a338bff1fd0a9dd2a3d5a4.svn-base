//
//  ActivityDetailViewController.m
//  wenYao-store
//  微商活动-活动详情
//  套餐活动详情：QueryActivityCombo
//  优惠活动详情：QueryActivityPromotion
//  换购活动详情：QueryActivityRepd
//  抢购活动详情：QueryActivityRush
//  Created by qw_imac on 16/3/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityProductTableViewCell.h"
#import "OffSellViewController.h"
#import "InternalProductDetailViewController.h"
#import "WechatActivity.h"

@interface ActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BusinessComboVO     *comboModel;
    BusinessPromotionVO *promotionModel;
    BusinessRedpVO      *redpModel;
    BusinessRushVO      *rushModel;
    SetHeadModel        *setHeadModel;
}
@property (weak, nonatomic)     IBOutlet UIView         *headerView;
@property (weak, nonatomic)     IBOutlet UIImageView    *markImg;
@property (weak, nonatomic)     IBOutlet UIImageView    *statusImg;
@property (strong, nonatomic)   IBOutlet UIView         *sectionView;
@property (weak, nonatomic)     IBOutlet UITableView    *tableView;
@property (weak, nonatomic)     IBOutlet UIView         *descriptionView;
@property (weak, nonatomic)     IBOutlet UIView         *storeView;
@property (weak, nonatomic)     IBOutlet UILabel        *desName;
@property (weak, nonatomic)     IBOutlet UILabel        *typeName;
@property (weak, nonatomic)     IBOutlet UIView         *footView;
@property (weak, nonatomic)     IBOutlet UILabel        *headTitle;
@property (weak, nonatomic)     IBOutlet UILabel        *activityType;
@property (weak, nonatomic)     IBOutlet UILabel        *activityDes;
@property (weak, nonatomic)     IBOutlet UILabel        *activityDate;
@property (weak, nonatomic)     IBOutlet UILabel        *activitySource;
@property (weak, nonatomic)     IBOutlet UILabel        *activityStore;
@property (weak, nonatomic)     IBOutlet UIButton       *offSellBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLine;
@property (weak, nonatomic)     IBOutlet UIView         *typeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footSpace;

@end

@implementation SetHeadModel

@end
@implementation ActivityDetailViewController
static NSString *const cellIdentifier = @"ActivityProductTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    self.offSellBtn.layer.cornerRadius = 5.0;
    self.offSellBtn.layer.masksToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityProductTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    setHeadModel = [SetHeadModel new];
    [self getModel];    
}

-(void)getModel {
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
    }else {
        [self removeInfoView];
        if (!AUTHORITY_ROOT) {//店员账号
            self.footView.hidden = YES;
            self.footSpace.constant = 0.0;
        }
        CGFloat height = 0;
        switch (_type) {
            case 3://套餐
                comboModel = [BusinessComboVO new];
                height = 140;
                [self getActivityCombo];
                break;
            case 1://优惠
                promotionModel = [BusinessPromotionVO new];
                height = 140;
                [self getActivityPromotion];
                break;
            case 4://换购
                redpModel = [BusinessRedpVO new];
                height = 120;
                [self getActivityRepd];
                break;
            case 2://抢购
                self.footView.hidden = YES;
                self.footSpace.constant = 0.0;
                rushModel = [BusinessRushVO new];
                height = 100;
                [self getActivityRush];
                break;
        }
        self.headerView.frame = CGRectMake(0, 0, APP_W, height);
        self.tableView.tableHeaderView = self.headerView;
    }
    
}

-(void)setHeaderUI {
    self.headTitle.text = setHeadModel.title;
    self.activityDate.text = [NSString stringWithFormat:@"%@",setHeadModel.date];
    self.activitySource.text = [NSString stringWithFormat:@"%@",setHeadModel.source.integerValue == 1?@"全维":@"商家"];
    switch ([setHeadModel.actType integerValue]) {
        case 3://套餐
        {
            self.storeView.hidden = YES;
            self.typeName.text = @"套餐价格:  ";
            self.activityType.text = [NSString stringWithFormat:@"%@",setHeadModel.price];
            self.desName.text = @"套餐描述:  ";
            self.activityDes.text = setHeadModel.desc;
            self.markImg.image  = [UIImage imageNamed:@"label_tao"];
        }
             break;
        case 2://抢购
            self.typeView.hidden = YES;
            self.descriptionView.hidden = YES;
            self.storeView.hidden = YES;
            self.markImg.image  = [UIImage imageNamed:@"label_rob"];
            break;
        case 1://优惠
        {
            self.descriptionView.hidden = YES;
            self.storeLine.constant = 70.0;
            NSString *activity;
            switch ([setHeadModel.activityType integerValue]) {//1:买赠, 2:折扣, 3:立减, 4:特价,
                case 1:
                    activity = @"买赠";
                    break;
                case 2:
                    activity = @"折扣";
                    break;
                case 3:
                    activity = @"立减";
                    break;
                case 4:
                    activity = @"特价";
                    break;
            }
            self.activityType.text = activity;
            self.activityStore.text = [NSString stringWithFormat:@"%@件",setHeadModel.promotionStock];
            self.markImg.image  = [UIImage imageNamed:@"label_hui"];
        }
            break;
        case 4://换购
            self.typeView.hidden = YES;
            self.storeView.hidden = YES;
            self.desLine.constant = 50.0;
            self.activityDes.text = setHeadModel.desc;
            self.markImg.image  = [UIImage imageNamed:@"label_huan"];
            break;
    }
//    self.headTitle.text = setHeadModel.title;
    if ([setHeadModel.status integerValue] == 2) {
        self.statusImg.hidden = NO;
    }else {
        self.statusImg.hidden = YES;
    }
    if ([setHeadModel.status integerValue] == 2) {//已下架
        [self.offSellBtn setBackgroundColor:RGBHex(qwColor9)];
        self.offSellBtn.userInteractionEnabled = NO;
        [self.offSellBtn setTitle:@"活动下线" forState:UIControlStateNormal];
    }else if ([setHeadModel.status integerValue] == 7) {
        [self.offSellBtn setBackgroundColor:RGBHex(qwColor9)];
        [self.offSellBtn setTitle:@"活动已下线" forState:UIControlStateNormal];
        self.offSellBtn.userInteractionEnabled = NO;
    }else {
        [self.offSellBtn setBackgroundColor:RGBHex(qwColor2)];
        self.offSellBtn.userInteractionEnabled = YES;
        [self.offSellBtn setTitle:@"活动下线" forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    DebugLog(@"dealloc");
}
#pragma - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return setHeadModel.proList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ActivityCellModel *model = [ActivityCellModel new];
    switch (_type) {
        case 3://套餐
        {
            model.cellType = ActivityTypeCombo;
            BusinessComboProductVO *vo = setHeadModel.proList[indexPath.row];
            model.name = vo.name;
            model.imgUrl = vo.imgUrl;
            model.price = vo.price;
            model.quantity = vo.quantity;
        }
            break;
        case 1://优惠
        {
            model.cellType = ActivityTypePromotion;
            BusinessPromotionProductVO *vo = setHeadModel.proList[indexPath.row];
            model.name = vo.name;
            model.imgUrl = vo.imgUrl;
            model.price = vo.price;
        }
            break;
        case 4://换购
        {
            model.cellType = ActivityTypeRepd;
             BusinessRedpProductVO *vo = setHeadModel.proList[indexPath.row];
            model.name = vo.name;
            model.imgUrl = vo.imgUrl;
            model.price = vo.price;
        }
            break;
        case 2://抢购
        {
            model.cellType = ActivityTypeRush;
            BusinessRushProductVO *vo = setHeadModel.proList[indexPath.row];
            model.name = vo.name;
            model.imgUrl = vo.imgUrl;
            model.price = vo.price;
            model.rushPrice = vo.rushPrice;
            model.rushStock = vo.rushStock;
            model.useQuantity = vo.useQuantity;
        }
            break;
    }
    [cell setCell:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 2) {
        return 95.0;
    }else {
        return 85.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
    switch (_type) {
        case 3://套餐
        {
            BusinessComboProductVO *vo = setHeadModel.proList[indexPath.row];
            vc.proId = vo.proId;
        }
            break;
        case 1://优惠
        {
            BusinessPromotionProductVO *vo = setHeadModel.proList[indexPath.row];
            vc.proId = vo.proId;
        }
            break;
        case 4://换购
        {
            BusinessRedpProductVO *vo = setHeadModel.proList[indexPath.row];
            vc.proId = vo.proId;
        }
            break;
        case 2://抢购
        {
            BusinessRushProductVO *vo = setHeadModel.proList[indexPath.row];
           vc.proId = vo.proId;
        }
            break;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)offSell:(UIButton *)sender {
    OffSellViewController *vc = [[OffSellViewController alloc]initWithNibName:@"OffSellViewController" bundle:nil];
    vc.type = _type;
    vc.actId = setHeadModel.actId;
    __weak typeof(self) weakSelf = self;
    vc.refresh = ^{
        [weakSelf getModel];
        [SVProgressHUD showSuccessWithStatus:@"下线成功" duration:0.8];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- getdata
-(void)getActivityCombo {
    ActivityComboR *modelR = [ActivityComboR new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.comboId = _activityId;
    [WechatActivity queryActivityCombo:modelR success:^(BusinessComboVO *responseModel) {
        if ([responseModel.apiStatus integerValue] == 0) {
            comboModel = responseModel;
            setHeadModel.actId = comboModel.actId;
            setHeadModel.title = comboModel.title;
            setHeadModel.desc = comboModel.desc;
            setHeadModel.source = comboModel.source;
            setHeadModel.date = comboModel.date;
            setHeadModel.status = comboModel.status;
            setHeadModel.actType = comboModel.actType;
            setHeadModel.price = comboModel.price;
            setHeadModel.proList = comboModel.list;
            [self setHeaderUI];
            [self.tableView reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}
-(void)getActivityPromotion {
    ActivityPromotionR *modelR = [ActivityPromotionR new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.promotionId = _activityId;
    [WechatActivity queryActivityPromotion:modelR success:^(BusinessPromotionVO *responseModel) {
        if ([responseModel.apiStatus integerValue] == 0) {
            promotionModel = responseModel;
            setHeadModel.actId = promotionModel.actId;
            setHeadModel.title = promotionModel.title;
            setHeadModel.desc = promotionModel.desc;
            setHeadModel.source = promotionModel.source;
            setHeadModel.date = promotionModel.date;
            setHeadModel.status = promotionModel.status;
            setHeadModel.actType = promotionModel.actType;
            setHeadModel.activityType = promotionModel.activityType;
            setHeadModel.promotionStock = promotionModel.promotionStock;
            setHeadModel.proList = promotionModel.list;
            [self setHeaderUI];
            [self.tableView reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}
-(void)getActivityRepd {
    ActivityRepdR *modelR = [ActivityRepdR new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.redpId = _activityId;
    [WechatActivity queryActivityRepd:modelR success:^(BusinessRedpVO *responseModel) {
        if ([responseModel.apiStatus integerValue] == 0) {
            redpModel = responseModel;
            setHeadModel.actId = redpModel.actId;
            setHeadModel.title = redpModel.title;
            setHeadModel.desc = redpModel.desc;
            setHeadModel.source = redpModel.source;
            setHeadModel.date = redpModel.date;
            setHeadModel.status = redpModel.status;
            setHeadModel.actType = redpModel.actType;
            setHeadModel.proList = redpModel.list;
            [self setHeaderUI];
            [self.tableView reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}
-(void)getActivityRush {
    ActivityRushR *modelR = [ActivityRushR new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.rushId = _activityId;
    [WechatActivity queryActivityRush:modelR success:^(BusinessRushVO *responseModel) {
        if ([responseModel.apiStatus integerValue] == 0) {
            rushModel = responseModel;
            setHeadModel.actId = rushModel.actId;
            setHeadModel.title = rushModel.title;
            //setHeadModel.desc = rushModel.desc;
            setHeadModel.source = rushModel.source;
            setHeadModel.date = rushModel.date;
            setHeadModel.status = rushModel.status;
            setHeadModel.actType = rushModel.actType;
            setHeadModel.proList = rushModel.list;
            [self setHeaderUI];
            [self.tableView reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}

@end

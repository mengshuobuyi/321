//
//  ProTableViewCell.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndentOders.h"
typedef NS_ENUM(NSInteger,CellType) {
    CellTypeNormal,         //普通商品
    CellTypeCombo,          //套餐
    CellTypeComboLast,      //套餐最后一个
    CellTypeRedemption,     //换购
};

@interface setCellModel:BaseModel
@property (nonatomic,strong) NSString   *proImg;
@property (nonatomic,strong) NSString   *proName;
@property (nonatomic,assign) CellType   type;
@property (nonatomic,strong)NSString    *productCode;//商品编码,
@property (nonatomic,strong)NSString    *price;//商品价格,
@property (nonatomic,strong)NSString    *priceDiscount;// 优惠价,
@property (nonatomic,strong)NSString    *actType;//微商优惠活动类型（1:微商优惠商品 2:抢购 3:优惠券）,
@property (nonatomic,strong)NSString    *actId;//优惠活动ID,
@property (nonatomic,strong)NSString    *actTitle;//优惠活动标题,
@property (nonatomic,strong)NSString    *proAmount;//商品件数
@property (nonatomic,strong)NSString    *freeBieQty;// 赠品数量,
@property (nonatomic,strong)NSString    *freeBieName;// 赠品名称
@property (nonatomic,strong)NSString    *comboPrice; //套餐价格
@property (nonatomic,strong)NSString    *comboCount;//套餐数量
@property (nonatomic,strong)NSString    *actDesc;
@property (nonatomic,strong)NSString    *spec;
@property (nonatomic,strong)NSString    *copEmpScore;//工业品赠送店员积分
+(setCellModel *)creatSetCellModel:(ShopMicroMallOrderDetailVO *)vo;
@end

@interface ProTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spec;
@property (weak, nonatomic) IBOutlet UIImageView *proImg;
@property (weak, nonatomic) IBOutlet UIImageView *giftImg;
@property (weak, nonatomic) IBOutlet UILabel *proPrice;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *giftNumber;
@property (weak, nonatomic) IBOutlet UILabel *proNumber;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIView *comboView;
@property (weak, nonatomic) IBOutlet UILabel *comboPrice;
@property (weak, nonatomic) IBOutlet UIView *firstInfoView;
@property (weak, nonatomic) IBOutlet UIView *secInfoView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *comboCount;
@property (weak, nonatomic) IBOutlet UIImageView *intergralLabel;
@property (weak, nonatomic) IBOutlet UILabel *intergral;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topspace;
-(void)setCell:(setCellModel *)vo;
@end

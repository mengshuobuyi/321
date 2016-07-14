//
//  ActivityProductTableViewCell.h
//  wenYao-store
//
//  Created by qw_imac on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ActivityType) {
    ActivityTypeCombo,
    ActivityTypePromotion,
    ActivityTypeRepd,
    ActivityTypeRush,
};

@interface ActivityCellModel : NSObject
@property (nonatomic,assign)ActivityType    cellType;
@property (nonatomic,strong)NSString *proId;//商品ID,
@property (nonatomic,strong)NSString *name;//名称,
@property (nonatomic,strong)NSString *imgUrl;//图片,
@property (nonatomic,strong)NSString *price;//价格,
@property (nonatomic,strong)NSString *quantity;//数量
@property (nonatomic,strong)NSString *rushPrice;//抢购价,
@property (nonatomic,strong)NSString *rushStock;//抢购库存,
@property (nonatomic,strong)NSString *useQuantity;//抢购使用量
@end
@interface ActivityProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *proImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *caseOneView;
@property (weak, nonatomic) IBOutlet UILabel *priceOne;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UIView *purView;
@property (weak, nonatomic) IBOutlet UILabel *rushPrice;
@property (weak, nonatomic) IBOutlet UILabel *discountPrice;
@property (weak, nonatomic) IBOutlet UILabel *storeAmount;
@property (weak, nonatomic) IBOutlet UIView *rushView;
@property (weak, nonatomic) IBOutlet UILabel *rushNumber;
-(void)setCell:(ActivityCellModel *)model;
@end

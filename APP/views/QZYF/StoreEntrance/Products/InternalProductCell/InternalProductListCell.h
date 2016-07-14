//
//  InternalProductListCell.h
//  wenYao-store
//
//  Created by PerryChen on 3/9/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"

@protocol ProductlistCellDelegate <NSObject>

- (void)editStackAction:(NSInteger)index;
- (void)editCateAction:(NSInteger)index;
- (void)editRecoAction:(NSInteger)index;
- (void)editViewAction:(NSInteger)index;

@end

@interface InternalProductListCell : QWBaseCell

@property (weak, nonatomic) IBOutlet UILabel *productStackLbl;          // 库存label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImgTipHeight;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;           
@property (weak, nonatomic) IBOutlet UILabel *productSpecLbl;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UIImageView *productPlaceHolderImgView;
@property (weak, nonatomic) IBOutlet UIButton *productStockBtn;
@property (weak, nonatomic) IBOutlet UIView *viewEditStock;
@property (weak, nonatomic) IBOutlet UIImageView *productTipImgView;
@property (weak, nonatomic) IBOutlet UILabel *productTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLimitLabel;
@property (weak, nonatomic) IBOutlet UIView *viewEditContent;
@property (nonatomic, assign) NSInteger intProType;     //0 是普通分类下商品 ，1 是优惠商品和本店推荐下商品. 2 是套餐商品
@property (weak, nonatomic) IBOutlet UILabel *lblRecoContent;
@property (assign, nonatomic) BOOL showEditContent;

@property (weak, nonatomic) id<ProductlistCellDelegate> delegate;
- (IBAction)actionReco:(UIButton *)sender;
- (IBAction)actionStock:(UIButton *)sender;
- (IBAction)actionCategory:(UIButton *)sender;
- (IBAction)actionEdit:(UIButton *)sender;
@end

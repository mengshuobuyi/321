//
//  CouponView.h
//  APP
//
//  Created by 李坚 on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponGrayViewDelegate <NSObject>

- (void)didSelectedAtIndex:(NSInteger)index;

@end

@interface CouponGrayView : UIView

@property (assign, nonatomic) id<CouponGrayViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *dataIn;
@property (weak, nonatomic) IBOutlet UILabel *coupnValue;
@property (weak, nonatomic) IBOutlet UILabel *lableFlag;
@property (weak, nonatomic) IBOutlet UIImageView *slowImage;

@end

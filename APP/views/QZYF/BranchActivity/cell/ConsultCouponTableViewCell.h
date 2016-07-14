//
//  ConsultCouponTableViewCell.h
//  APP
//
//  Created by 李坚 on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponView.h"
#import "CouponPresentView.h"
@protocol ConsultCouponTableViewCellDelegate <NSObject>

- (void)didSelectedCouponView:(NSInteger)index;

@end


@interface ConsultCouponTableViewCell : UITableViewCell<CouponViewDelegate,CouponPresentViewDelegate>{
    
    NSMutableArray *dataArray;
}

@property (assign, nonatomic) id<ConsultCouponTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (void)setScrollView:(NSArray *)array;

@end

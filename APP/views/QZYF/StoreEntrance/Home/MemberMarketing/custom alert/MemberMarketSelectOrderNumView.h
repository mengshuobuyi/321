//
//  MemberMarketSelectOrderNumView.h
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectOrderNumDelegate <NSObject>

- (void)chooseOrderNum:(NSInteger)intSelect;

@end

@interface MemberMarketSelectOrderNumView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblOrderInfinite;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderOne;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOrderInfinite;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOrderOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOrderTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIewOrderThree;
@property (assign, nonatomic) NSInteger selectOrderNo;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) id<selectOrderNumDelegate> delegate;

- (void)setViewSelectStyle;

@end

//
//  PopupMarketActivityView.h
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  Enum_Activity_Items {
    Enum_Items_Activity             = 1,             //营销活动
    Enum_Items_Coupn                = 2,             //优惠活动
}Activity_Items;
@protocol MarketActivityViewDelegate <NSObject>

- (void)didSendMarketActivityWithDict:(NSDictionary *)dict;

@end


@interface PopupMarketActivityView : UIView<UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet  UIControl       *activityView;
@property (nonatomic, strong) IBOutlet  UILabel         *contentLabel;
@property (nonatomic, strong) IBOutlet  UITextField     *replyTextField;
@property (nonatomic, strong) IBOutlet  UIImageView     *imageView;
@property (nonatomic, strong) IBOutlet  UIImageView     *hintTextFieldImage;
@property (nonatomic, strong) NSMutableDictionary       *infoDict;
@property (nonatomic, assign) id <MarketActivityViewDelegate>   delegate;
@property (nonatomic, assign) NSInteger       enum_type;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)setContent:(NSString *)content avatarUrl:(NSString *)avatarUrl;
- (IBAction)cancelActivity:(id)sender;
- (IBAction)sendActivity:(id)sender;

@end

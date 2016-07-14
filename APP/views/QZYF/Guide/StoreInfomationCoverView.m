//
//  StoreInfomationCoverView.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/24.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreInfomationCoverView.h"
#import "AppDelegate.h"

@implementation StoreInfomationCoverView
{
    UIWindow *window;
}

+ (StoreInfomationCoverView *)sharedManager
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"StoreInfomationCoverView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        NSString *desc = @"单击这里，分享门店信息到朋友圈和好友，朋友打开门店成功下单，订单完成后给分享人赠送积分哦！";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSDictionary *attributes = @{NSFontAttributeName:fontSystem(15),NSParagraphStyleAttributeName:paragraphStyle};
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:desc attributes:attributes];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction
{
    [self hidden];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"storeInfomationCover+%@",QWGLOBALMANAGER.configure.passportId]];
}

-(void)hidden
{
    __weak StoreInfomationCoverView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end

void ShowStoreInfomationCover()
{
    if (QWGLOBALMANAGER.configure.storeType == 3)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if([[userDefault objectForKey:[NSString stringWithFormat:@"storeInfomationCover+%@",QWGLOBALMANAGER.configure.passportId]] boolValue]){
            return;
        }
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        StoreInfomationCoverView* cover = [StoreInfomationCoverView sharedManager];
        [[UIApplication sharedApplication].keyWindow addSubview:cover];
    }
}

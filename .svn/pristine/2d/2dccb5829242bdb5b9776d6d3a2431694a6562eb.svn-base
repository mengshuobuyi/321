//
//  ProfessionTempletView.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProfessionTempletView.h"
#import "AppDelegate.h"

@implementation ProfessionTempletView
{
    UIWindow *window;
}

+ (ProfessionTempletView *)sharedManagerWithIamge:(NSString *)imageName;
{
    return [[self alloc] initWithImageStr:imageName];
}

- (id)initWithImageStr:(NSString *)imageName
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"ProfessionTempletView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        self.templetImageView.image = [UIImage imageNamed:imageName];
        
        self.templetImage_layout_height.constant = 190*(APP_W-30)/290;
        
        if (IS_IPHONE_4_OR_LESS) {
            self.button_layout_top.constant = 117;
        }else if (IS_IPHONE_5){
            self.button_layout_top.constant = 160;
        }else if (IS_IPHONE_6){
            self.button_layout_top.constant = 190;
        }else if (IS_IPHONE_6P){
            self.button_layout_top.constant = 212;
        }
    }
    return self;
}

-(void)show
{
    self.bgView.alpha = 0.55;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
}

-(void)hidden
{
    self.bgView.alpha = 0;
    [self removeFromSuperview];
}

- (IBAction)hiddenAction:(id)sender
{
    [self hidden];
}

@end

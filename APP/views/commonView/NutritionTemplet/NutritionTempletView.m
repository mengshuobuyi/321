//
//  NutritionTempletView.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NutritionTempletView.h"
#import "AppDelegate.h"

@implementation NutritionTempletView

{
    UIWindow *window;
}

+ (NutritionTempletView *)sharedManagerWithImage:(NSString *)imageName type:(int)type;

{
    return [[self alloc] initWithImageStr:imageName type:type];
}

- (id)initWithImageStr:(NSString *)imageName type:(int)type
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"NutritionTempletView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        self.templetImageView.image = [UIImage imageNamed:imageName];
        
        self.templet_layout_height.constant = 386*(APP_W-30)/290;
        if (type == 1)
        {
            //药师
            if (IS_IPHONE_4_OR_LESS) {
                self.button_layout_top.constant = 40;
            }else if (IS_IPHONE_5){
                self.button_layout_top.constant = 82;
            }else if (IS_IPHONE_6){
                self.button_layout_top.constant = 98;
            }else if (IS_IPHONE_6P){
                self.button_layout_top.constant = 110;
            }
            
        }else
        {
            if (IS_IPHONE_4_OR_LESS) {
                self.button_layout_top.constant = 20;
            }else if (IS_IPHONE_5){
                self.button_layout_top.constant = 64;
            }else if (IS_IPHONE_6){
                self.button_layout_top.constant = 78;
            }else if (IS_IPHONE_6P){
                self.button_layout_top.constant = 83;
            }

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

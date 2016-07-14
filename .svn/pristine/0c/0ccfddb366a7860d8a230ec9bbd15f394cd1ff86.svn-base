//
//  DFNavgateionController.m
//  DFace
//
//  Created by FanYuandong on 14-4-3.
//
//

#import "DFNavgateionController.h"
#import "DFNavBarButtonItem.h"

@interface DFNavgateionController ()

@end

@implementation DFNavgateionController

- (id)init
{
    self = [super init];
    if (self) {
        [self setBackgroundImage];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setBackgroundImage];

        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],
                                                               UITextAttributeFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setBackgroundImage
{
//    if (IS_IOS7_OR_LATER) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"DFMainNavigationBg_ios7"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        //iOS7 阴影需单独设定 UIColor clearColor 是去掉字段 1像素阴影
//        [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"4fb1ef"]]];
//    } else {
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"DFMainNavigation_Bg"] forBarMetrics:UIBarMetricsDefault];
//    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.navigationItem.leftBarButtonItem = [[DFNavBarButtonItem alloc] initLeftWithImage:[UIImage imageNamed:@"ic_nav_back"] target:viewController action:@selector(backAction:)];
    }
    
    if ([self.viewControllers containsObject:viewController]) {
        [super popToViewController:viewController animated:YES];
    } else {
        [super pushViewController:viewController animated:animated];
    }
}

- (void)setBackgroundAlpha:(CGFloat)alpha
{
    UIColor *color = [UIColor colorWithRed:16.0/255.0 green:152.0/255.0 blue:218.0/255.0 alpha:alpha];
//    UIImage *image = [UIImage imageWithColor:color];
//    if (IS_IOS7_OR_LATER) {
//        [self.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        //iOS7 阴影需单独设定 UIColor clearColor 是去掉字段 1像素阴影
//        [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
//    } else {
//        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    }
}
@end

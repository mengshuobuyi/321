//
//  DFNavBarButtonItem.m
//  DFace
//
//  Created by FanYuandong on 14-4-10.
//
//

#import "DFNavBarButtonItem.h"

static const CGFloat ios7_later_padding = 2.0;
static const CGFloat ios6_below_padding = 2.0;

@interface DFNavBarButtonItem ()

@end

@implementation DFNavBarButtonItem
- (id)initLeftWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)aAction
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateHighlighted];
    [button setTitle:aTitle forState:UIControlStateSelected];
    [button setTitle:aTitle forState:UIControlStateSelected|UIControlStateHighlighted];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithHexString:@"55bff3"] forState:UIControlStateDisabled];
    CGSize size = CGSizeZero;
    
//    if (IS_IOS7_OR_LATER) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -ios7_later_padding, 0, ios7_later_padding);
        size = [aTitle sizeWithFont:[UIFont systemFontOfSize:18.0]];
//    } else {
//        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, ios6_below_padding, 0, -ios6_below_padding);
//        size = [aTitle sizeWithFont:[UIFont systemFontOfSize:15.0]];
//    }
    button.frame = CGRectMake(0.0, 0.0, size.width, size.height);

    self = [super initWithCustomView:button];
    if (self) {
        
    }
    return self;
}

- (id)initLeftWithImage:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction
{
    return [self initLeftWithImage:aImage backgroundImage:aImage target:aTarget action:aAction];
}

- (id)initLeftWithImage:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction
{
    CGSize size = aImage.size;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:aImage forState:UIControlStateNormal];
    [button setImage:aBackgroundImage forState:UIControlStateHighlighted];
    [button setImage:aBackgroundImage forState:UIControlStateSelected];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0.0, 0.0, size.width, size.height);

//    if (IS_IOS7_OR_LATER) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0 , -ios7_later_padding, 0, ios7_later_padding);
//    } else {
//        button.imageEdgeInsets = UIEdgeInsetsMake(0.0 , ios6_below_padding, 0, -ios6_below_padding);
//    }

    self = [super initWithCustomView:button];
    if (self) {
        
    }
    return self;
}

- (id)initLeftWithTitle:(NSString *)aTitle image:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction
{
    return [self initLeftWithTitle:aTitle image:aImage backgroundImage:aImage target:aTarget action:aAction];
}

- (id)initLeftWithTitle:(NSString *)aTitle image:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

- (id)initRightWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)aAction
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateHighlighted];
    [button setTitle:aTitle forState:UIControlStateSelected];
    [button setTitle:aTitle forState:UIControlStateSelected|UIControlStateHighlighted];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithHexString:@"55bff3"] forState:UIControlStateDisabled];
    CGSize size = CGSizeZero;
//    if (IS_IOS7_OR_LATER) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, ios7_later_padding, 0, -ios7_later_padding);
        size = [aTitle sizeWithFont:[UIFont systemFontOfSize:18.0]];
//    } else {
//        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -ios6_below_padding, 0, ios6_below_padding);
//        size = [aTitle sizeWithFont:[UIFont systemFontOfSize:15.0]];
//    }
    button.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    self = [super initWithCustomView:button];
    if (self) {
        
    }
    return self;
}

- (id)initRightWithImage:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction
{
    return [self initRightWithImage:aImage backgroundImage:aImage target:aTarget action:aAction];
}

- (id)initRightWithImage:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction
{
    CGSize size = aImage.size;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:aImage forState:UIControlStateNormal];
    [button setImage:aBackgroundImage forState:UIControlStateHighlighted];
    [button setImage:aBackgroundImage forState:UIControlStateSelected];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0.0, 0.0, size.width, size.height);
//    if (IS_IOS7_OR_LATER) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, ios7_later_padding, 0, -ios7_later_padding);
//    } else {
//        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, -ios6_below_padding, 0, ios6_below_padding);
//    }
    self = [super initWithCustomView:button];
    if (self) {

    }
    return self;
}

- (id)initRightWithTitle:(NSString *)aTitle image:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction
{
    return [self initRightWithTitle:aTitle image:aImage backgroundImage:aImage target:aTarget action:aAction];
}

- (id)initRightWithTitle:(NSString *)aTitle image:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

@end

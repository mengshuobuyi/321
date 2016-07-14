//
//  DFSelectorBar.m
//  DFace
//
//  Created by kabda on 7/23/14.
//
//

#import "DFSelectorBar.h"

#define BUTTON_WIDTH 46.0
#define BUTTON_HEIGHT 33.0
#define NUM_RADIUS 10.0

@interface DFSelectorBar ()
@property (nonatomic, strong) UIButton *numberButton;
@end

@implementation DFSelectorBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        
        _selectedPhotosCount = 0;
        
        UIImage *imageNormal = [UIImage imageNamed:@"ic_next"];
//        UIImage *imageHighlighted = [UIImage imageWithColor:[UIColor colorWithHexString:@"0f7db3"]];
        
        _completeButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_completeButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
//        [_completeButton setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
        [_completeButton addTarget:self action:@selector(completeHandler) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.enabled = NO;
        _completeButton.layer.cornerRadius = 4.0;
        _completeButton.clipsToBounds = YES;
        [self addSubview:_completeButton];
        
        _numberButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _numberButton.userInteractionEnabled = NO;
        [_numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numberButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [_numberButton setBackgroundImage:[UIImage imageNamed:@"bg_green_dot"] forState:UIControlStateNormal];
        _numberButton.titleLabel.textAlignment = UITextAlignmentCenter;
        _numberButton.hidden = YES;
        _numberButton.clipsToBounds = YES;
        [self addSubview:_numberButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGRect buttonBounds = CGRectMake(0.0, 0.0, BUTTON_WIDTH, BUTTON_HEIGHT);
    CGFloat buttonYCenter = CGRectGetHeight(bounds) / 2;
    self.completeButton.bounds = buttonBounds;
    CGPoint completeCenter = CGPointMake(CGRectGetWidth(bounds) * 7 / 8, buttonYCenter);
    self.completeButton.center = completeCenter;
    
    CGRect numBounds = CGRectMake(0.0, 0.0, NUM_RADIUS * 2 + 2.0, NUM_RADIUS * 2 + 2.0);
    CGPoint numCenter = CGPointMake(CGRectGetMinX(self.completeButton.frame), CGRectGetMinY(self.completeButton.frame) + 4.0);
    self.numberButton.bounds = numBounds;
    self.numberButton.center = numCenter;
}

- (void)completeHandler
{
    if (!self.completeButton.isEnabled) {
        return; // 不知道为什么, completeButton 设置 enable = NO 后(l108), 仍旧会响应此方法;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(complete)]) {
        [self.delegate performSelector:@selector(complete)];
        self.completeButton.enabled = NO;
    }
}

- (void)setSelectedPhotosCount:(NSInteger)selectedPhotosCount
{
    [self setSelectedPhotosCount:selectedPhotosCount animated:NO];
}

- (void)setSelectedPhotosCount:(NSInteger)selectedPhotosCount animated:(BOOL)animated
{
    _selectedPhotosCount = selectedPhotosCount;
    
    [self.numberButton.layer removeAnimationForKey:@"bounce"]; // CAMediaTimingFunction.removedOnCompletion = YES 移除不及时, 路手动移除;
    if (_selectedPhotosCount > 0) {
        self.completeButton.enabled = YES;
        self.numberButton.hidden = NO;
//        NSString *text = [NSString stringWithFormat:@"%d", _selectedPhotosCount];
//        [self.numberButton setTitle:text forState:UIControlStateNormal];
//        if (animated) {
//            [self setUpAnimation];
//        }
    } else {
        self.completeButton.enabled = NO;
        self.numberButton.hidden = YES;
    }
}

- (void)setUpAnimation
{
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.0;
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation1.fromValue = @0.0;
    scaleAnimation1.toValue = @1.2;
    scaleAnimation1.duration = 0.4;
    scaleAnimation1.beginTime = 0.0;
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation2.fromValue = @1.2;
    scaleAnimation2.toValue = @0.9;
    scaleAnimation2.duration = 0.2;
    scaleAnimation2.beginTime = 0.4;
    
    CABasicAnimation *scaleAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation3.fromValue = @0.9;
    scaleAnimation3.toValue = @1.1;
    scaleAnimation3.duration = 0.2;
    scaleAnimation3.beginTime = 0.6;
    
    CABasicAnimation *scaleAnimation4 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation4.fromValue = @1.1;
    scaleAnimation4.toValue = @1.0;
    scaleAnimation4.duration = 0.2;
    scaleAnimation4.beginTime = 0.8;
    
    NSArray *animations = @[scaleAnimation1, scaleAnimation2, scaleAnimation3, scaleAnimation4];
    animationGroup.animations = animations;
    [self.numberButton.layer addAnimation:animationGroup forKey:@"bounce"];
}

@end

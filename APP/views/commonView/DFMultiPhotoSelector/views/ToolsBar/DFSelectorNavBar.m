//
//  DFSelectorNavBar.m
//  DFace
//
//  Created by kabda on 7/24/14.
//
//

#import "DFSelectorNavBar.h"
#import "Constant.h"
@interface DFSelectorNavBar ()
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation DFSelectorNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        _currentIndex = NSNotFound;
        _selectedIndex = NSNotFound;
        _needsAnimated = NO;
        
        _backButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
//        [_backButton setTitle:@"取消" forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        [_backButton setTitleColor:RGBHex(0x45c01a) forState:UIControlStateSelected];
        _actionButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_actionButton setTitle:@"发送" forState:UIControlStateNormal];
        //        _actionButton setFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        _actionButton.backgroundColor = [UIColor clearColor];
        [_actionButton addTarget:self action:@selector(handleSelectAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_actionButton setTitleColor:RGBHex(0x45c01a) forState:UIControlStateSelected];
        [self addSubview:_actionButton];
        //
        //        _selectButton = [[UIButton alloc]initWithFrame:CGRectZero];
        //        _selectButton.backgroundColor = [UIColor clearColor];
        //        _selectButton.userInteractionEnabled = NO;
        //        [self addSubview:_selectButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect backRect = CGRectMake(20.0, CGRectGetHeight(bounds) - 44.0, 48.0, 44.0);
    self.backButton.frame = backRect;
    
    CGFloat selectButtonHeight = 44.0;
    
    CGRect selectRect = CGRectMake(CGRectGetWidth(bounds) - 40.0 - selectButtonHeight, CGRectGetHeight(bounds) -44, selectButtonHeight * 2, selectButtonHeight);
    NSLog(@"完成=======》%@",NSStringFromCGRect(selectRect));
    //    self.selectButton.frame = selectRect;
    //    self.selectButton.layer.cornerRadius = CGRectGetWidth(selectRect) / 2;
    //    self.selectButton.layer.borderWidth = 1.0;
    //    self.selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionButton.frame = selectRect;
    //    self.actionButton.bounds = self.backButton.bounds;
    //    self.actionButton.center = self.selectButton.center;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    _selectedIndex = selectedIndex;
    NSString *title = @"";
    if (_selectedIndex != NSNotFound) {
        title = [NSString stringWithFormat:@"%d", _selectedIndex + 1];
        [self.selectButton setTitle:title forState:UIControlStateNormal];
        //        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"4fb1ef"];
    } else {
        [self.selectButton setTitle:@"" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor clearColor];
    }
    if (animated) {
        [self setUpAnimation];
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
    [self.selectButton.layer addAnimation:animationGroup forKey:@"bounce"];
}

- (void)handleBackAction
{
    _backButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate performSelector:@selector(back)];
    }
}

- (void)handleSelectAction
{
    _actionButton.selected = YES;
    if (self.selectedIndex == NSNotFound) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(markSelected)]) {
            [self.delegate markSelected];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(markUnSelected)]) {
            [self.delegate markUnSelected];
        }
    }
}
@end

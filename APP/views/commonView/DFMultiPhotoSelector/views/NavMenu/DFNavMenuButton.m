//
//  DFNavMenuButton.m
//  DFace
//
//  Created by kabda on 8/27/14.
//
//

#import "DFNavMenuButton.h"
//#import "DFNavMenuViewConfiguration.h"

@interface DFNavMenuButton ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@end

@implementation DFNavMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        frame.origin.y -= 2.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        self.titleLabel.font = FONT(20.0);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.titleLabel.textColor = currentStyle[UITextAttributeTextColor];
        self.titleLabel.shadowColor = currentStyle[UITextAttributeTextShadowColor];
        NSValue *shadowOffset = currentStyle[UITextAttributeTextShadowOffset];
        self.titleLabel.shadowOffset = shadowOffset.CGSizeValue;
        [self addSubview:self.titleLabel];
        
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        //        self.arrow.image = [DFNavMenuViewConfiguration arrowImage];
        self.arrow.bounds = CGRectMake(0.0, 0.0, 25.0, 25.0);
        [self addSubview:self.arrow];
    }
    return self;
}

- (UIImageView *)defaultGradient
{
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat height = CGRectGetHeight(bounds) - 2.0;
    self.titleLabel.center = CGPointMake(CGRectGetWidth(bounds) / 2, height / 2);
    CGSize titleSize = CGSizeZero;
    //    if (IS_IOS7_OR_LATER) {
    //        NSDictionary *attribute = @{NSFontAttributeName:FONT(20.0)};
    //        titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(bounds), height) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //    } else {
    //        titleSize = [self.titleLabel.text sizeWithFont:FONT(20.0) forWidth:CGRectGetWidth(bounds) lineBreakMode:NSLineBreakByTruncatingTail];
    //    }
    //    self.titleLabel.bounds = CGRectMake(0.0, 0.0, titleSize.width, titleSize.height);
    //    if (self.titleLabel.text.length > 13) {
    //        self.titleLabel.minimumFontSize = 15.0;
    //    } else {
    //        self.titleLabel.minimumFontSize = 20.0;
    //    }
    //    self.arrow.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + [DFNavMenuViewConfiguration arrowPadding], self.frame.size.height / 2);
    self.arrow.bounds = CGRectMake(0.0, 0.0, 25.0, 25.0);
}

#pragma mark -
#pragma mark Handle taps
- (void)setActive:(BOOL)active
{
    _active = active;
    if (self.isActive) {
        [self rotateArrow:M_PI];
    } else {
        [self rotateArrow:0];
    }
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)rotateArrow:(float)degrees
{
    //    [UIView animateWithDuration:[DFNavMenuViewConfiguration animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    //        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    //    } completion:NULL];
}

@end

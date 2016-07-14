//
//  DFSelectablePhotoCell.m
//  DFace
//
//  Created by kabda on 7/21/14.
//
//

#import "DFSelectablePhotoCell.h"

@interface DFSelectablePhotoCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DFSelectedMarkView *markView;
@end

@implementation DFSelectablePhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedMode = NO;
        _selectedIndex = NSNotFound;
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
        
//        _markView = [[DFSelectedMarkView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_markView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [self.contentView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.imageView.frame = bounds;
    self.markView.frame = bounds;
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image animated:NO];
}

- (void)setImage:(UIImage *)image animated:(BOOL)animated
{
    _image = image;
    if (animated) {
        [self.imageView.layer removeAnimationForKey:@"dface_imageview_animation"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.imageView.layer addAnimation:transition forKey:@"dface_imageview_animation"];
    }
    self.imageView.image = _image;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    _selectedIndex = selectedIndex;
    self.markView.indexLabel.text = [NSString stringWithFormat:@"%d", (_selectedIndex + 1)];
    self.markView.needsAnimated = animated;
    if (_selectedIndex == NSNotFound) {
        self.selectedMode = NO;
    } else {
        self.selectedMode = YES;
    }
}

- (void)setSelectedMode:(BOOL)selectedMode
{
    _selectedMode = selectedMode;
    self.markView.selectedMode = _selectedMode;
}

#pragma mark - TapHandler
- (void)handleSingleTap:(UITapGestureRecognizer*)singleTapGestureRecognizer
{
//    CGPoint point = [singleTapGestureRecognizer locationInView:self.contentView];
//    CGFloat width = CGRectGetWidth(self.contentView.frame);
//    CGFloat height = CGRectGetHeight(self.contentView.frame);
//    if (point.x >= (width / 2) && point.y <= (height / 2)) {
//        if (self.selectedMode) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(selectablePhotoCellDidUnMarked:)]) {
//                [self.delegate selectablePhotoCellDidUnMarked:self];
//            }
//        } else {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(selectablePhotoCellDidMarked:)]) {
//                [self.delegate selectablePhotoCellDidMarked:self];
//            }
//        }
//    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectablePhotoCellTappedToShowAllPhotos:)]) {
            [self.delegate selectablePhotoCellTappedToShowAllPhotos:self];
         }
//    }
}

@end

@implementation DFSelectedMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _selectedMode = NO;
        _needsAnimated = NO;
        
        _foregroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _foregroundImageView.backgroundColor = [UIColor clearColor];
//        _foregroundImageView.layer.borderColor = [UIColor colorWithHexString:@"4fb1ef"].CGColor;
        _foregroundImageView.layer.borderWidth = 3.0;
        _foregroundImageView.hidden = YES;
        [self addSubview:_foregroundImageView];
        
        _indexLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _indexLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        _indexLabel.clipsToBounds = YES;
        _indexLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_indexLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.foregroundImageView.frame = bounds;
    
    CGPoint center = CGPointMake(CGRectGetWidth(bounds) * 3 / 4, CGRectGetHeight(bounds) / 4);
    CGSize size = CGSizeMake(CGRectGetWidth(bounds) / 3 - 4.0, CGRectGetHeight(bounds) / 3 - 4.0);
    self.indexLabel.bounds = CGRectMake(0.0, 0.0, size.width, size.height);
    self.indexLabel.center = center;
    self.indexLabel.layer.cornerRadius = size.width / 2;
    self.indexLabel.layer.borderWidth = 1.0;
    self.indexLabel.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelectedMode:(BOOL)selectedMode
{
    [self.indexLabel.layer removeAnimationForKey:@"bounce"]; // CAMediaTimingFunction.removedOnCompletion = YES 移除不及时, 路手动移除;
    _selectedMode = selectedMode;
    if (_selectedMode) {
        self.foregroundImageView.hidden = NO;
        self.indexLabel.textColor = [UIColor whiteColor];
//        self.indexLabel.backgroundColor = [UIColor colorWithHexString:@"4fb1ef"];
        if (self.needsAnimated) {
            [self setUpAnimation];
            self.needsAnimated = NO;
        }
    } else {
        self.foregroundImageView.hidden = YES;
        self.indexLabel.textColor = [UIColor clearColor];
        self.indexLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
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
    [self.indexLabel.layer addAnimation:animationGroup forKey:@"bounce"];
}

@end
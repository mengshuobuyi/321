 

#import "QWLoadView.h"
#import <QuartzCore/QuartzCore.h>
#import "QWAnimation.h"


@interface QWLoadView()
-(void)initSubViews:(UIImage *)loadingImage;
@end

@implementation QWLoadView

@synthesize m_loadImgView;

- (id)initWithFrame:(CGRect)frame loadingImage:(UIImage *)loadingImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubViews:loadingImage];
    }
    return self;
}

-(void)dealloc
{
 
}

-(void)initSubViews:(UIImage *)loadingImage
{
    
    [self setBgView];
    float width,height;

    if (self.frame.size.width/2 <= loadingImage.size.width) {
        width = self.frame.size.width * 1 / 3;
    }
    else
    {
        width = loadingImage.size.width;
    }

    height = width;
    
    m_loadImgView = [[UIImageView alloc] initWithImage:loadingImage];
    
    m_loadImgView.frame = CGRectMake(0, 0, width, height);
    
    m_loadImgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addSubview:m_loadImgView];
}


//can overwrite
-(void)setBgView
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
}

-(CAAnimation *)getLodingAnimation:(double)duration
{

    CABasicAnimation * basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.duration = duration;
    basicAnim.fromValue = [NSNumber numberWithDouble:0];
    basicAnim.toValue = [NSNumber numberWithDouble:2*M_PI];
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    basicAnim.repeatCount = FLT_MAX;
    
    
    return basicAnim;
    
}

-(void)startLoading:(double)duration
{
    self.hidden = NO;
    [m_loadImgView.layer addAnimation:[self getLodingAnimation:duration] forKey:@"loadingAnimation"];
    [QWAnimation SetOpacityBasicAnimation:self delegate:nil key:nil duration:0.3 fromValue:0 toValue:1];
}

-(void)endLoading
{
    
    [QWAnimation SetOpacityBasicAnimation:self delegate:self key:nil duration:0.3 fromValue:1 toValue:0];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.hidden = YES;
        [m_loadImgView.layer removeAllAnimations];
        [self.layer removeAllAnimations];
    }
}




@end

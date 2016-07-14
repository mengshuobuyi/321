#import "QWH5Loading.h"

@interface QWH5Loading()
{
    UIImageView *imgvLoading, *imgvBG;
    UIView      *backGroundView;
    BOOL canMove;
}
@end

@implementation QWH5Loading
@synthesize delegate=_delegate;

+ (instancetype)instance{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+(instancetype)instanceWithDelegate:(id)delegate{
    QWH5Loading* obj=[self instance];
    obj.delegate=delegate;
    return obj;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.minShowTime=0.0;
        backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H)];
        backGroundView.backgroundColor = [UIColor whiteColor];
        canMove=YES;
        [self addSubview:backGroundView];
    }
    return self;
}

- (void)showLoading{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    self.frame=win.bounds;
    
    CGRect frm;

    if (imgvLoading==nil) {
        
        CGSize sz=CGSizeMake(80, 80);

        frm.size=sz;
        frm.origin.x=win.bounds.size.width/2-sz.width/2;
        frm.origin.y=win.bounds.size.height/2-sz.height/2;
        
        imgvBG = nil;
        imgvBG = [[UIImageView alloc] initWithFrame:frm];
//        [imgvBG setImage:bg];
        
        [self addSubview:imgvBG];
        NSMutableArray *arrImgs = [NSMutableArray arrayWithCapacity:30];
        for(NSInteger index = 0; index < 30; ++index)
        {
            [arrImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%ld",240+index]]];
        }
        //  change  end
        frm.size=sz;
        frm.origin.x=win.bounds.size.width/2-sz.width/2;
        frm.origin.y=win.bounds.size.height/2-sz.height/2;
        
        imgvLoading = [[UIImageView alloc] initWithFrame:frm];
        imgvLoading.animationImages = arrImgs;
        imgvLoading.animationDuration = 1.8;
        imgvLoading.animationRepeatCount = 0;
        [imgvLoading startAnimating];
        
        [self addSubview:imgvLoading];
    }
    
    [win addSubview:self];
    [win bringSubviewToFront:imgvBG];
    [win bringSubviewToFront:imgvLoading];
    canMove=NO;
    [self performSelector:@selector(removeLoading) withObject:nil afterDelay:2.5f];
}

- (void)removeLoading{
    canMove=YES;
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:self.minShowTime];
}

- (void)stopLoading{
    if (canMove==NO) {
        return;
    }
    
    [self removeFromSuperview];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(hudStopByTouch:)]) {
//        [self.delegate hudStopByTouch:self];
//    }
}

- (void)closeLoading{

    [self removeFromSuperview];
}

- (void)removeLoadingByTouch{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(hudStopByTouch:)]) {
        [self.delegate hudStopByTouch:self];
    }
    
    [self removeFromSuperview];
}

#pragma mark - 触摸关闭loading

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UIWindow *win=[UIApplication sharedApplication].delegate.window;
    UITouch *et = [[event allTouches] anyObject];
    CGPoint ep = [et locationInView:win];
    
    
    CGRect navRect=(CGRect){0,0,120,64};
    if (([self superview].bounds.size.height>=win.bounds.size.height) && CGRectContainsPoint(navRect, ep)) {
        DebugLog(@"返回");
        [self removeLoadingByTouch];
    }
}
@end

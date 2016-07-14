//
//  QWProgressLoading.m
//  APP
//
//  Created by Yan Qingyang on 15/4/23.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWLoading.h"

@interface QWLoading()
{
    UIImageView *imgvLoading, *imgvBG;
    BOOL canMove;
}
@end

@implementation QWLoading
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
    QWLoading* obj=[self instance];
    obj.delegate=delegate;
    return obj;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.minShowTime=0.5;
        canMove=YES;
        //        self.backgroundColor=[UIColor redColor];
    }
    return self;
}


- (void)showLoading {
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _showLoading];
    });
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
//        [self _showLoading];
//    });
}

- (void)removeLoading
{
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _removeLoading];
    });
}

- (void)stopLoading
{
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _stopLoading];
    });
}

- (void)closeLoading
{
    if (![NSThread isMainThread]) {
        DDLogError(@"QWLoading bg thread\n<<<<<\n%@\n>>>>>\n", [NSThread callStackSymbols]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _closeLoading];
    });
}

- (void)_showLoading{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    if(win == nil){
        return;
    }
    self.frame=CGRectMake(0, 0, APP_W, SCREEN_H);
    
    CGRect frm;
//    if (imgvBG==nil) {
//
//        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, APP_W, SCREEN_H)];
//        imgvBG.backgroundColor = [UIColor whiteColor];
//        [self addSubview:imgvBG];
//    }
    
    if (imgvLoading==nil) {
        
        CGSize sz=CGSizeMake(86, 80);
        
        //        UIImage *bg=[UIImage imageNamed:@"loading_first"];
        //        sz=bg.size;
        frm.size=sz;
        frm.origin.x=win.bounds.size.width/2-sz.width/2;
        frm.origin.y=win.bounds.size.height/2-sz.height/2;
        
        imgvBG = nil;
        imgvBG = [[UIImageView alloc] initWithFrame:frm];
        //        [imgvBG setImage:bg];
        
        //  change  by  shen
        //        int num=24;
        //        NSMutableArray *arrImgs = [[NSMutableArray alloc]initWithCapacity:num];
        //        for (int i = 0; i < num; i++) {
        //            UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i+1]];
        //            [arrImgs addObject:img];
        //            sz=img.size;
        //        }
        
        int num=5;
        NSMutableArray *arrImgs = [NSMutableArray arrayWithCapacity:49];
        for(NSInteger index = 0; index < 49; ++index)
        {
            [arrImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%ld",240+index]]];
        }
        
        //  change  end
        frm.size=sz;
        frm.origin.x=win.bounds.size.width/2-sz.width/2;
        frm.origin.y=win.bounds.size.height/2-sz.height/2;
        
        imgvLoading = [[UIImageView alloc] initWithFrame:frm];
        imgvLoading.animationImages = arrImgs;
        imgvLoading.animationDuration = 0.8;
        imgvLoading.animationRepeatCount = 0;
        [imgvLoading startAnimating];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:imgvBG];
            [self addSubview:imgvLoading];
//        });
        
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
        [win addSubview:self];
        [win bringSubviewToFront:imgvBG];
        [win bringSubviewToFront:imgvLoading];
//    });

    canMove=NO;
}

- (void)_removeLoading{
    canMove=YES;
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:self.minShowTime];
}

- (void)_stopLoading{
    if (canMove==NO) {
        return;
    }
    
    [self removeFromSuperview];
}

- (void)removeLoadingByTouch{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(hudStopByTouch:)]) {
        [self.delegate hudStopByTouch:self];
    }
    
    [self removeFromSuperview];
}

- (void)_closeLoading{
    
    [self removeFromSuperview];
}
#pragma mark - 触摸关闭loading

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UIWindow *win=[UIApplication sharedApplication].delegate.window;
    UITouch *et = [[event allTouches] anyObject];
    CGPoint ep = [et locationInView:win];
    
    
    CGRect navRect=(CGRect){0,0,120,64};
    if (([self superview].bounds.size.height>=win.bounds.size.height) && CGRectContainsPoint(navRect, ep)) {
        NSLog(@"返回");
        [self removeLoadingByTouch];
        
        //        if (<#condition#>) {
        //            if (self.delegate  && [self.delegate respondsToSelector:@selector(hudStopByTouch:)]) {
        //                [self.delegate hudStopByTouch:self];
        //            }
        //        }
    }
}
@end

//
//  NLImageCropper.m
//  getImage
//
//  Created by 李坚 on 15/8/5.
//  Copyright (c) 2015年 李坚. All rights reserved.
//

#import "NLImageCropper.h"

@implementation NLImageCropper



+ (NLImageCropper *)imageSelecter:(UIWindow *)aView andImage:(UIImage *)image callBack:(SelectedBack)callBack{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"NLImageCropper" owner:nil options:nil];
    NLImageCropper *imageSelecter = [nibView objectAtIndex:0];
    imageSelecter.beforeImage = image;
    imageSelecter.frame = CGRectMake(0, 0, APP_W, APP_H + 44);
    imageSelecter.NLImageView.frame =  CGRectMake(0, 0, APP_W, APP_H-50);
    imageSelecter.NLImageView.image = image;

    
    imageSelecter.selectView.center = imageSelecter.NLImageView.center;
    imageSelecter.downView.frame = CGRectMake(0, aView.frame.size.height - 50, APP_W, 50);
    
    imageSelecter.callBack = callBack;
    
    [aView addSubview:imageSelecter];
    
    return imageSelecter;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    self.moveEnable = NO;
    self.selectView.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    pinch.delegate = self;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveToLocation:)];
    [self.selectView addGestureRecognizer:pinch];
    [self.selectView addGestureRecognizer:pan];
}

- (void)addSubview:(UIView *)view{
    [super addSubview:view];
    
    
    self.NLImageView.image = self.beforeImage;
    
}


- (void)moveToLocation:(UIPanGestureRecognizer *)recognizer{
    
    
    CGPoint translation = [recognizer translationInView:self.NLImageView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.NLImageView];
}


- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    float ttScale = 1.0f;
    CGRect rect = recognizer.view.frame;
    
    NSLog(@"Pinch height: %f", rect.size.height);
    
    if(rect.size.height > 102 && rect.size.height < 162){
        
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
        
    }else if(rect.size.height >= 102 && ttScale > recognizer.scale){
        
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
        
    }else if(rect.size.height <= 162 && ttScale < recognizer.scale){
        
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
        
    }else{
        return;
    }
    
    ttScale = recognizer.scale;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    
}


- (IBAction)cropImage:(id)sender {
    
    NSLog(@"x:%.2fy:%.2fscale:%.2f",self.beforeImage.size.width,self.beforeImage.size.height,self.beforeImage.scale);
    
    NSLog(@"x:%.2fy:%.2fwidth:%.2fheight:%.2f",self.selectView.frame.origin.x,self.selectView.frame.origin.y,self.selectView.frame.size.width,self.selectView.frame.size.height);
    
    CGPoint point = CGPointMake(self.selectView.frame.origin.x, self.selectView.frame.origin.y);
    CGPoint tt = [self.NLImageView convertPoint:point toView:self.NLImageView];
    
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor whiteColor];
//    view.frame = CGRectMake(tt.x+10, tt.y+10, self.selectView.frame.size.width - 20, self.selectView.frame.size.height - 20);
//    [self addSubview:view];
    
    
    UIGraphicsBeginImageContext(self.NLImageView.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*  viewImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect imageRect = CGRectMake(tt.x + 15,
                                  tt.y + 15,
                            self.selectView.frame.size.width - 30,
                            self.selectView.frame.size.height - 30);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([viewImage CGImage], imageRect);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:viewImage.scale
                                    orientation:viewImage.imageOrientation];

    
    if (self.callBack) {
        self.callBack(result);
    }
    [self removeFromSuperview];
}


- (IBAction)cancel:(id)sender {
    
    [self removeFromSuperview];
    
}

@end













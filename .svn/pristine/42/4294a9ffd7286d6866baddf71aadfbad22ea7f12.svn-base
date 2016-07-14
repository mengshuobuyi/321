//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import "SJAvatarBrowser.h"
#import "XHBubblePhotoImageView.h"
#import "QWGlobalManager.h"


static CGRect oldframe;
@implementation SJAvatarBrowser{
    UIView *backgroundView;
}
+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image = nil;
    if([avatarImageView isKindOfClass:[XHBubblePhotoImageView class]]) {
        image = ((XHBubblePhotoImageView *)avatarImageView).messagePhoto;
    }else{
        image = avatarImageView.image;
    }
    if (image == nil) {
        return;
    }
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer: tap];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    
    [backgroundView addGestureRecognizer:longPressGestureRecognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        //[UIApplication sharedApplication].statusBarHidden = YES;
        
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        
        [backgroundView addGestureRecognizer:longPressGestureRecognizer];
        
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)saveImage:(UILongPressGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
        QWGLOBALMANAGER.saveImage = imageView.image;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:QWGLOBALMANAGER cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles: nil];
        [sheet showInView:tap.view];
    }
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    //[UIApplication sharedApplication].statusBarHidden = NO;
    __block UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        for(UIGestureRecognizer *gesture in backgroundView.gestureRecognizers)  {
            [backgroundView removeGestureRecognizer:gesture];
        }
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    }];
}
@end

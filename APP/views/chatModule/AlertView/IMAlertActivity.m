//
//  IMAlertActivity.m
//  wenYao-store
//
//  Created by Yan Qingyang on 15/9/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IMAlertActivity.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
@implementation IMAlertActivity

+(id)instance
{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IMAlertActivity" owner:nil options:nil];
        sharedInstance = [nibView objectAtIndex:0];
    });
    [sharedInstance UIInit];
    return sharedInstance;
}

- (void)show:(id)obj block:(AlertSelectedBlock)block{
     [super show:nil block:block];
    
    BranchNewPromotionModel *mm=obj;
    lblContent.text=mm.desc;
    lblTTL.text=mm.title;
    txtWord.delegate=self;
    txtWord.text=nil;
    
    [imgPhoto setImageWithURL:[NSURL URLWithString:mm.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
}

- (void)showNormal:(id)obj block:(AlertSelectedBlock)block{
    [super show:nil block:block];
    
    QueryActivityInfo *mm=obj;
    lblContent.text=mm.content;
    lblTTL.text=mm.title;
    txtWord.delegate=self;
    txtWord.text=nil;
    
    [imgPhoto setImageWithURL:[NSURL URLWithString:mm.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    
}


- (void)close:(int)tag{
    [UIView animateWithDuration:kAlertDur animations:^{
        //        self.backgroundColor=RGBAHex(kColor1, 0);
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.mainView=nil;
        
        if (self.selectedBlock) {
            self.selectedBlock(tag,txtWord.text);
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickAction:btn1];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    vBG.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGRect frm=vBG.frame;
    frm.origin.y -= 120;
    vBG.frame=frm;
    
//    vBG.center=self.center;
    return YES;
}

- (void)UIInit{
    CGRect frm;
    frm=vBG.frame;
    frm.size.width=270;
    frm.size.height=222;
    vBG.frame=frm;
    
    txtWord.layer.cornerRadius=4;
    txtWord.layer.borderWidth=0.5;
    txtWord.layer.borderColor=RGBHex(qwColor9).CGColor;
    txtWord.textColor=RGBHex(qwColor6);
    
    lblContent.textColor=RGBHex(qwColor7);
    lblTTL.textColor=RGBHex(qwColor6);
    
    
}
////添加到windows 不要用super
//- (void)addToWindow{
//    if (self.mainView!=nil) {
//        CGRect frm=self.mainView.bounds;
//        self.frame=frm;
//        [self.mainView addSubview:self];
//        [self.mainView bringSubviewToFront:self];
//    }
//    else {
//        UIWindow *win=[UIApplication sharedApplication].keyWindow;
//        CGRect frm=win.bounds;
//        self.frame=frm;
//        [win addSubview:self];
//        [win bringSubviewToFront:self];
//    }
//    
//    vBG.translatesAutoresizingMaskIntoConstraints = YES;
//    
//    //    CGRect frm=vBG.frame;
//    //    frm.size.width=AutoValue(frm.size.width);
//    //    frm.size.height=AutoValue(frm.size.height);
//    //    vBG.frame=frm;
//    
//    vBG.center=self.center;
//}
@end

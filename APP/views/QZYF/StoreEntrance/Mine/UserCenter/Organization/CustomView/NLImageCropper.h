//
//  NLImageCropper.h
//  getImage
//
//  Created by 李坚 on 15/8/5.
//  Copyright (c) 2015年 李坚. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedBack) (UIImage *image);

@interface NLImageCropper : UIView<UIGestureRecognizerDelegate>


@property (weak, nonatomic) UIImage *beforeImage;
@property (weak, nonatomic) IBOutlet UIImageView *NLImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectView;

@property (assign, nonatomic) BOOL moveEnable;
@property (weak, nonatomic) IBOutlet UIView *downView;

@property (nonatomic, copy) SelectedBack callBack ;
+ (NLImageCropper *)imageSelecter:(UIView *)aView andImage:(UIImage *)image callBack:(SelectedBack)callBack;

@end

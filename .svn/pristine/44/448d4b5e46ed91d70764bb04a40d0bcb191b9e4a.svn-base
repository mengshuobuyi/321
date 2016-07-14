//
//  BubblePhotoImageView.m
//  APP
//
//  Created by YYX on 15/5/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BubblePhotoImageView.h"
#import "XHMacro.h"
#import "UIView+XHRemoteImage.h"
#import "UIImage+Resize.h"
#import "Constant.h"
#import "XHCacheManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Ex.h"

@interface BubblePhotoImageView ()
{
    BOOL stopAc;
}
@end

@implementation BubblePhotoImageView

- (MessageDeliveryType)getBubbleMessageType {
    return self.bubbleMessageType;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}
- (void)setMessagePhoto:(UIImage *)messagePhoto {
    
    _messagePhoto = messagePhoto;
//   self.messageModel.photo = messagePhoto;
    [self setNeedsDisplay];
    
}
-(void)awakeFromNib
{
     [super awakeFromNib];
    self.updateFrame = YES;
    self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
}
-(void)updatePhoto
{
    WEAKSELF
    NSString *uuidP = self.messageModel.UUID;
    
    if (self.messageModel.photo) {
          [weakSelf.activityIndicatorView stopAnimating];
        weakSelf.messagePhoto = self.messageModel.photo;
    }
    else if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:uuidP]) {
        
        weakSelf.messagePhoto =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:uuidP];
        
//          weakSelf.messagePhoto =[UIImage scaleImage:weakSelf.messagePhoto toScale:0.25];
    }
    else
    {
       
        [self addSubview:weakSelf.activityIndicatorView];
         weakSelf.messagePhoto = [UIImage imageNamed: @"image_waiting2"];
        
        [self.activityIndicatorView startAnimating];

        [weakSelf.activityIndicatorView startAnimating];
        
        [weakSelf.photoImageView setImageWithURL:[NSURL URLWithString:self.messageModel.originPhotoUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            if (image) {
                
                UIImage *storedImage = [image resizedImage:image.size interpolationQuality:1.0];
//                    weakSelf.messagePhoto = storedImage;
                [[SDImageCache sharedImageCache] storeImage:storedImage forKey:uuidP];
                dispatch_async(dispatch_get_main_queue(), ^{
                [GLOBALMANAGER postNotif:NotimessageIMTabelUpdate data:weakSelf.messageModel object:nil];
//                 weakSelf.messagePhoto = storedImage;
                [weakSelf.activityIndicatorView stopAnimating];
             });
            }
        }];

    }

    
    [self setNeedsDisplay];

}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)dealloc {
    _messagePhoto = nil;
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView = nil;
}
-(void)layoutSubviews
{
    [super layoutSubviews];

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

//    if (self.updateFrame) {
//        self.updateFrame = NO;
    
//        if (self.bubbleMessageType == MessageTypeSending) {
//            //         frame.size.height = bubbleSize.height -1;
//            rect.origin.x = rect.origin.x+10 ;
//            rect.origin .y = rect.origin.y+0.5;
//        }else
//        {
//            rect.origin.x = rect.origin.x+0.5 ;
//            rect.origin.y = rect.origin.y+0.5;
//        }
//    }
//    rect.origin = CGPointZero;
    rect.origin.y = rect.origin.y + 1;
    [self.messagePhoto drawInRect:rect];
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height+1;//莫名其妙会出现绘制底部有残留 +1像素遮盖
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = 6;//6;
    CGFloat margin = 8;//留出上下左右的边距
    
    CGFloat triangleSize = 6;//8;//三角形的边长
    CGFloat triangleMarginTop = 8;//8;//三角形距离圆角的距离
    
    CGFloat borderOffset = 3;//阴影偏移量
    UIColor *borderColor = [UIColor clearColor];//阴影的颜色
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,0,0,0,1);//画笔颜色
    CGContextSetLineWidth(context, 1);//画笔宽度
    // 移动到初始点
    CGContextMoveToPoint(context, radius + margin, margin);
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius - margin, margin);
    CGContextAddArc(context, width - radius - margin, radius + margin, radius, -0.5 * M_PI, 0.0, 0);
    CGContextAddLineToPoint(context, width, margin + radius);
    CGContextAddLineToPoint(context, width, 0);
    CGContextAddLineToPoint(context, radius + margin,0);
    // 闭合路径
    CGContextClosePath(context);
    // 绘制第2条线和第2个1/4圆弧
    CGContextMoveToPoint(context, width - margin, margin + radius);
    CGContextAddLineToPoint(context, width, margin + radius);
    CGContextAddLineToPoint(context, width, height - margin - radius);
    CGContextAddLineToPoint(context, width - margin, height - margin - radius);
    
    float arcSize = 2;//3;//角度的大小
    
    if (self.bubbleMessageType == MessageTypeSending) {
        float arcStartY = margin + radius + triangleMarginTop + triangleSize - (triangleSize - arcSize / margin * triangleSize) / 2;//圆弧起始Y值
        float arcStartX = width - arcSize;//圆弧起始X值
        float centerOfCycleX = width - arcSize - pow(arcSize / margin * triangleSize / 2, 2) / arcSize;//圆心的X值
        float centerOfCycleY = margin + radius + triangleMarginTop + triangleSize / 2;//圆心的Y值
        float radiusOfCycle = hypotf(arcSize / margin * triangleSize / 2, pow(arcSize / margin * triangleSize / 2, 2) / arcSize);//半径
        float angelOfCycle = asinf(0.5 * (arcSize / margin * triangleSize) / radiusOfCycle) * 2;//角度
        //绘制右边三角形
        CGContextAddLineToPoint(context, width - margin , margin + radius + triangleMarginTop + triangleSize);
        CGContextAddLineToPoint(context, arcStartX , arcStartY);
        CGContextAddArc(context, centerOfCycleX-3, centerOfCycleY, radiusOfCycle, angelOfCycle / 2, 0.0 - angelOfCycle / 2, 1);
        CGContextAddLineToPoint(context, width - margin , margin + radius + triangleMarginTop);
    }
    
    
    CGContextMoveToPoint(context, width - margin, height - radius - margin);
    CGContextAddArc(context, width - radius - margin, height - radius - margin, radius, 0.0, 0.5 * M_PI, 0);
    CGContextAddLineToPoint(context, width - margin - radius, height);
    CGContextAddLineToPoint(context, width, height);
    CGContextAddLineToPoint(context, width, height - radius - margin);
    
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextMoveToPoint(context, width - margin - radius, height - margin);
    CGContextAddLineToPoint(context, width - margin - radius, height);
    CGContextAddLineToPoint(context, margin, height);
    CGContextAddLineToPoint(context, margin, height - margin);
    
    
    CGContextMoveToPoint(context, margin, height-margin);
    CGContextAddArc(context, radius + margin, height - radius - margin, radius, 0.5 * M_PI, M_PI, 0);
    CGContextAddLineToPoint(context, 0, height - margin - radius);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, margin, height);
    
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextMoveToPoint(context, margin, height - margin - radius);
    CGContextAddLineToPoint(context, 0, height - margin - radius);
    CGContextAddLineToPoint(context, 0, radius + margin);
    CGContextAddLineToPoint(context, margin, radius + margin);
    
    if (!self.bubbleMessageType == MessageTypeSending) {
        float arcStartY = margin + radius + triangleMarginTop + (triangleSize - arcSize / margin * triangleSize) / 2;//圆弧起始Y值
        float arcStartX = arcSize;//圆弧起始X值
        float centerOfCycleX = arcSize + pow(arcSize / margin * triangleSize / 2, 2) / arcSize;//圆心的X值
        float centerOfCycleY = margin + radius + triangleMarginTop + triangleSize / 2;//圆心的Y值
        float radiusOfCycle = hypotf(arcSize / margin * triangleSize / 2, pow(arcSize / margin * triangleSize / 2, 2) / arcSize);//半径
        float angelOfCycle = asinf(0.5 * (arcSize / margin * triangleSize) / radiusOfCycle) * 2;//角度
        //绘制左边三角形
        CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop);
        CGContextAddLineToPoint(context, arcStartX , arcStartY);
        CGContextAddArc(context, centerOfCycleX+3, centerOfCycleY, radiusOfCycle, M_PI + angelOfCycle / 2, M_PI - angelOfCycle / 2, 1);
        CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop + triangleSize);
    }
    CGContextMoveToPoint(context, margin, radius + margin);
    CGContextAddArc(context, radius + margin, margin + radius, radius, M_PI, 1.5 * M_PI, 0);
    CGContextAddLineToPoint(context, margin + radius, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, radius + margin);
    
    
    //
    
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    
    CGContextDrawPath(context, kCGPathFill);
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end

//
//  XHBubblePhotoImageView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-28.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBubblePhotoImageView.h"
#import "XHMacro.h"

#import "UIView+XHRemoteImage.h"

#import "UIImage+Resize.h"
#import "Constant.h"
#import "XHCacheManager.h"
#import "SDImageCache.h"
@interface XHBubblePhotoImageView ()

/**
 *  消息类型
 */
@property (nonatomic, assign) XHBubbleMessageType bubbleMessageType;

@end

@implementation XHBubblePhotoImageView

- (XHBubbleMessageType)getBubbleMessageType {
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
    [self setNeedsDisplay];
}

- (void)configureMessagePhoto:(UIImage *)messagePhoto thumbnailUrl:(NSString *)thumbnailUrl originPhotoUrl:(NSString *)originPhotoUrl onBubbleMessageType:(XHBubbleMessageType)bubbleMessageType uuid:(NSString *)uuid{
    self.bubbleMessageType = bubbleMessageType;
    self.messagePhoto = messagePhoto;
    if (self.messagePhoto) {
        CGSize  bubbleSize = CGSizeZero;
        bubbleSize = self.messagePhoto.size;
        
        CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
        bubbleSize.width = width;
        bubbleSize.height = MAX_SIZE;
        self.messagePhoto = self.messagePhoto;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y
                                  , width, MAX_SIZE)];
        return;
    }
    if (originPhotoUrl) {
        WEAKSELF
        
        
        weakSelf.messagePhoto = [UIImage  imageWithData:[[XHCacheManager shareCacheManager] localCachedDataWithURL:[NSURL URLWithString:originPhotoUrl]] ];
        if (!weakSelf.messagePhoto) {
            weakSelf.messagePhoto =    [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:uuid];
        }
        if (weakSelf.messagePhoto) {
            CGSize  bubbleSize = CGSizeZero;
            bubbleSize = weakSelf.messagePhoto.size;
            
            CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
            bubbleSize.width = width;
            bubbleSize.height = MAX_SIZE;
            weakSelf.messagePhoto = weakSelf.messagePhoto;
            [weakSelf setFrame:CGRectMake(weakSelf.frame.origin.x, weakSelf.frame.origin.y
                                          , width, MAX_SIZE)];
            
            NSLog(@"it has  image  in  cache");
            return;
        }
        [self addSubview:self.activityIndicatorView];
        self.messagePhoto =[UIImage imageNamed: @"image_waiting2"];
        [self.activityIndicatorView startAnimating];
        [self setImageWithURL:[NSURL URLWithString:originPhotoUrl] placeholer:[UIImage imageNamed: @"image_waiting2"] showActivityIndicatorView:NO completionBlock:^(UIImage *image, NSURL *url, NSError *error) {
            if ([url.absoluteString isEqualToString:originPhotoUrl]) {
                image = [image resizedImage:image.size interpolationQuality:1.0];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.messagePhoto = image;
                        
                        //                        NSLog(@"--------weakSelf--->%@",NSStringFromCGSize(image.size));
                        
                        [[SDImageCache sharedImageCache] storeImage:image forKey:uuid];
                        [weakSelf.activityIndicatorView stopAnimating];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:RELOADTABLEE object:nil];
                        [GLOBALMANAGER postNotif:NotimessageIMTabelUpdate data:nil object:nil];
                    });
                }
                
            }
        }];
    }
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    rect.origin = CGPointZero;
    [self.messagePhoto drawInRect:rect];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height+1;//莫名其妙会出现绘制底部有残留 +1像素遮盖
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = 6;
    CGFloat margin = 8;//留出上下左右的边距
    
    CGFloat triangleSize = 8;//三角形的边长
    CGFloat triangleMarginTop = 8;//三角形距离圆角的距离
    
    CGFloat borderOffset = 3;//阴影偏移量
    UIColor *borderColor = [UIColor blackColor];//阴影的颜色
    
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
    
    float arcSize = 3;//角度的大小
    
    if (self.bubbleMessageType == XHBubbleMessageTypeSending) {
        float arcStartY = margin + radius + triangleMarginTop + triangleSize - (triangleSize - arcSize / margin * triangleSize) / 2;//圆弧起始Y值
        float arcStartX = width - arcSize;//圆弧起始X值
        float centerOfCycleX = width - arcSize - pow(arcSize / margin * triangleSize / 2, 2) / arcSize;//圆心的X值
        float centerOfCycleY = margin + radius + triangleMarginTop + triangleSize / 2;//圆心的Y值
        float radiusOfCycle = hypotf(arcSize / margin * triangleSize / 2, pow(arcSize / margin * triangleSize / 2, 2) / arcSize);//半径
        float angelOfCycle = asinf(0.5 * (arcSize / margin * triangleSize) / radiusOfCycle) * 2;//角度
        //绘制右边三角形
        CGContextAddLineToPoint(context, width - margin , margin + radius + triangleMarginTop + triangleSize);
        CGContextAddLineToPoint(context, arcStartX , arcStartY);
        CGContextAddArc(context, centerOfCycleX, centerOfCycleY, radiusOfCycle, angelOfCycle / 2, 0.0 - angelOfCycle / 2, 1);
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
    
    if (!self.bubbleMessageType == XHBubbleMessageTypeSending) {
        float arcStartY = margin + radius + triangleMarginTop + (triangleSize - arcSize / margin * triangleSize) / 2;//圆弧起始Y值
        float arcStartX = arcSize;//圆弧起始X值
        float centerOfCycleX = arcSize + pow(arcSize / margin * triangleSize / 2, 2) / arcSize;//圆心的X值
        float centerOfCycleY = margin + radius + triangleMarginTop + triangleSize / 2;//圆心的Y值
        float radiusOfCycle = hypotf(arcSize / margin * triangleSize / 2, pow(arcSize / margin * triangleSize / 2, 2) / arcSize);//半径
        float angelOfCycle = asinf(0.5 * (arcSize / margin * triangleSize) / radiusOfCycle) * 2;//角度
        //绘制左边三角形
        CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop);
        CGContextAddLineToPoint(context, arcStartX , arcStartY);
        CGContextAddArc(context, centerOfCycleX, centerOfCycleY, radiusOfCycle, M_PI + angelOfCycle / 2, M_PI - angelOfCycle / 2, 1);
        CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop + triangleSize);
    }
    CGContextMoveToPoint(context, margin, radius + margin);
    CGContextAddArc(context, radius + margin, margin + radius, radius, M_PI, 1.5 * M_PI, 0);
    CGContextAddLineToPoint(context, margin + radius, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, radius + margin);
    
    
    //
    
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
//    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    
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

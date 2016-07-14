//
//  PhotoChatBubbleView.m
//  APP
//
//  Created by YYX on 15/5/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "PhotoChatBubbleView.h"
#import "UIImageView+WebCache.h"
#import "XHMessageBubbleFactory.h"

#define kMarginTop 8.0f
#define kMarginBottom 5.0f


NSString *const kRouterEventPhotoBubbleTapEventName = @"kRouterEventPhotoBubbleTapEventName";

@implementation PhotoChatBubbleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
    self.bubblePhotoImageView.backgroundColor = [UIColor clearColor];
    
    NSBundle * bundle = [NSBundle mainBundle];
    NSArray * progressViews = [bundle loadNibNamed:@"progressView" owner:self options:nil];
    
    progressView *dpMeterViews =[progressViews objectAtIndex:0];
         self.dpMeterView = dpMeterViews;
   self.dpMeterView.progressLabel.text = @"0%";
    self.dpMeterView.hidden = YES;
    [self addSubview:_dpMeterView];
    self.updateFrame = YES;
 _frame = self.bubblePhotoImageView.frame;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.frame = CGRectZero;
    if (self.messageModel.sended == MessageDeliveryState_Delivering) {
        
        
        self.dpMeterView.hidden = NO;
    }else if(self.messageModel.sended == MessageDeliveryState_Delivered)
    {
        self.dpMeterView.progressLabel.text = @"0%";
        
        self.dpMeterView.hidden = YES;
    }else
    {
   
          self.dpMeterView.progressLabel.text = @"0%";
        self.dpMeterView.hidden = YES;
    }

    CGSize bubbleSize = [PhotoChatBubbleView sizeForBubbleWithObject:self.messageModel];

    CGRect chiliFram = _frame;
        chiliFram.size.width = bubbleSize.width;
        chiliFram.size.height = bubbleSize.height;
        if (self.bubblePhotoImageView.bubbleMessageType == MessageTypeSending) {
            //         frame.size.height = bubbleSize.height -1;
            chiliFram.origin.x = _frame.origin.x+0.5 ;
            chiliFram.origin .y = _frame.origin.y+0.5;
        }else
        {
            chiliFram.origin.x = _frame.origin.x+0.5 ;
            chiliFram.origin.y = _frame.origin.y+0.5;
        }
//    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, chiliFram.size.width+1, chiliFram.size.height+1);
    self.dpMeterView.frame = chiliFram;
    self.bubblePhotoImageView.frame = chiliFram;
    [self.bubblePhotoImageView setNeedsDisplay];
 
}

-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    self.bubblePhotoImageView.messageModel = messageModel;
    //    self.bubblePhotoImageView.backgroundColor = [UIColor redColor];
    self.bubblePhotoImageView.bubbleMessageType = messageModel.messageDeliveryType;
    self.bubblePhotoImageView.messagePhoto = messageModel.photo;
    [self.bubblePhotoImageView updatePhoto];
}
#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventPhotoBubbleTapEventName userInfo:@{KMESSAGEKEY:self.bubblePhotoImageView}];
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)object
{
    CGSize  bubbleSize = CGSizeZero;
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    if ([imageCache diskImageExistsWithKey:object.UUID]) {
        
        UIImage *img2 =[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:object.UUID];
        bubbleSize = img2.size;
        if (bubbleSize.width == 0 || bubbleSize.height == 0) {
            bubbleSize.width = MAX_SIZE;
            bubbleSize.height = MAX_SIZE;
        }
        else if (bubbleSize.width > bubbleSize.height) {
            CGFloat height =  MAX_SIZE / bubbleSize.width  *  bubbleSize.height;
            bubbleSize.height = height;
            bubbleSize.width = MAX_SIZE;
        }
        else{
            CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
            bubbleSize.width = width;
            bubbleSize.height = MAX_SIZE;
        }
    }
    else{
        if (object.photo) {
            bubbleSize = object.photo.size;
            if (bubbleSize.width == 0 || bubbleSize.height == 0) {
                bubbleSize.width = MAX_SIZE;
                bubbleSize.height = MAX_SIZE;
            }
            else if (bubbleSize.width > bubbleSize.height) {
                
                CGFloat height =  MAX_SIZE / bubbleSize.width  *  bubbleSize.height;
                bubbleSize.height = height;
                bubbleSize.width = MAX_SIZE;
            }
            else{
                CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
                bubbleSize.width = width;
                bubbleSize.height = MAX_SIZE;
            }
        }else
        {
            bubbleSize.height = MAX_SIZE;
            bubbleSize.width = MAX_SIZE;
            //            bubbleSize = [XHMessageBubbleView neededSizeForPhoto:self.message.photo];
        }
    }

    return bubbleSize;
}



//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    rect.origin = CGPointZero;
//     CGRect imgRect;
//    NSString *imgString;
//if (self.bubblePhotoImageView.bubbleMessageType == MessageTypeReceiving) {
//         imgString = @"imPhotoBg";
//    }else
//    {
//        imgString = @"imPhotoGreen";
//    }
//    UIImage *img = [UIImage imageNamed:imgString ];
////   if (self.updateFrame) {
//    imgRect.size.width = rect.size.width + 3;
//    imgRect.size.height = rect.size.height + 3;
////   }
//    imgRect.origin.x = rect.origin.x ;
//    imgRect.origin.y = rect.origin.y ;
//    [img drawInRect:imgRect];
//    CGFloat width = imgRect.size.width;
//    CGFloat height = imgRect.size.height+1;//莫名其妙会出现绘制底部有残留 +1像素遮盖
//    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
//    CGFloat radius = 6;//6;
//    CGFloat margin = 8;//8;//留出上下左右的边距
//    
//    CGFloat triangleSize = 8;//8;//三角形的边长
//    CGFloat triangleMarginTop = 9;//8;//三角形距离圆角的距离
//    
//    CGFloat borderOffset = 3;//阴影偏移量
//    UIColor *borderColor = [UIColor clearColor];//阴影的颜色
//    
//    // 获取CGContext，注意UIKit里用的是一个专门的函数
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context,0,0,0,1);//画笔颜色
//    CGContextSetLineWidth(context, 1);//画笔宽度
//    // 移动到初始点
//    CGContextMoveToPoint(context, radius + margin, margin);
//    // 绘制第1条线和第1个1/4圆弧
//    CGContextAddLineToPoint(context, width - radius - margin, margin);
//    CGContextAddArc(context, width - radius - margin, radius + margin, radius, -0.5 * M_PI, 0.0, 0);
//    CGContextAddLineToPoint(context, width, margin + radius);
//    CGContextAddLineToPoint(context, width, 0);
//    CGContextAddLineToPoint(context, radius + margin,0);
//    // 闭合路径
//    CGContextClosePath(context);
//    // 绘制第2条线和第2个1/4圆弧
//    CGContextMoveToPoint(context, width - margin, margin + radius);
//    CGContextAddLineToPoint(context, width, margin + radius);
//    CGContextAddLineToPoint(context, width, height - margin - radius);
//    CGContextAddLineToPoint(context, width - margin, height - margin - radius);
//    
//    float arcSize = 3;//3;//角度的大小
//    
//        if (self.bubblePhotoImageView.bubbleMessageType == MessageTypeSending) {
//            int wiht = 10;
//            float arcStartY = margin + radius + triangleMarginTop + triangleSize - (triangleSize - arcSize / margin * triangleSize) / 2;//圆弧起始Y值
//            float arcStartX = width - arcSize ;//圆弧起始X值
//            float centerOfCycleX = width - arcSize - pow(arcSize / margin * triangleSize / 2, 2) / arcSize;//圆心的X值
//            float centerOfCycleY = margin + radius + triangleMarginTop + triangleSize / 2;//圆心的Y值
//            float radiusOfCycle = hypotf(arcSize / margin * triangleSize / 2, pow(arcSize / margin * triangleSize / 2, 2) / arcSize);//半径
//            float angelOfCycle = asinf(0.5 * (arcSize / margin * triangleSize) / radiusOfCycle) * 2;//角度
//            
//            NSLog(@"the arcStartY is %f, the arcStartX is %f, centerOfCycleX is %f, centerOfCycleY is %f, radiusOfCycle is %f, angelOfCycle is %f",arcStartY, arcStartX, centerOfCycleX, centerOfCycleY, radiusOfCycle, angelOfCycle);
//            //绘制右边三角形
//            CGContextAddLineToPoint(context, width - margin , margin + radius + triangleMarginTop + triangleSize);
//            CGContextAddLineToPoint(context, arcStartX , arcStartY);
//            CGContextAddArc(context, centerOfCycleX, centerOfCycleY, radiusOfCycle, angelOfCycle / 2, 0.0 - angelOfCycle / 2, 1);
//            CGContextAddLineToPoint(context, width - margin, margin + radius + triangleMarginTop);
//        }
//    
//    
//    CGContextMoveToPoint(context, width - margin, height - radius - margin);
//    CGContextAddArc(context, width - radius - margin, height - radius - margin, radius, 0.0, 0.5 * M_PI, 0);
//    CGContextAddLineToPoint(context, width - margin - radius, height);
//    CGContextAddLineToPoint(context, width, height);
//    CGContextAddLineToPoint(context, width, height - radius - margin);
//    
//    
//    // 绘制第3条线和第3个1/4圆弧
//    CGContextMoveToPoint(context, width - margin - radius, height - margin);
//    CGContextAddLineToPoint(context, width - margin - radius, height);
//    CGContextAddLineToPoint(context, margin, height);
//    CGContextAddLineToPoint(context, margin, height - margin);
//    
//    
//    CGContextMoveToPoint(context, margin, height-margin);
//    CGContextAddArc(context, radius + margin, height - radius - margin, radius, 0.5 * M_PI, M_PI, 0);
//    CGContextAddLineToPoint(context, 0, height - margin - radius);
//    CGContextAddLineToPoint(context, 0, height);
//    CGContextAddLineToPoint(context, margin, height);
//    
//    
//    // 绘制第4条线和第4个1/4圆弧
//    CGContextMoveToPoint(context, margin, height - margin - radius);
//    CGContextAddLineToPoint(context, 0, height - margin - radius);
//    CGContextAddLineToPoint(context, 0, radius + margin);
//    CGContextAddLineToPoint(context, margin, radius + margin);
//    
//         if (!self.bubblePhotoImageView.bubbleMessageType == MessageTypeSending) {
//    float arcStartY = margin + radius + triangleMarginTop + (triangleSize - arcSize / margin * triangleSize) / 2;//圆弧起始Y值
//    float arcStartX = arcSize;//圆弧起始X值
//    float centerOfCycleX = arcSize + pow(arcSize / margin * triangleSize / 2, 2) / arcSize;//圆心的X值
//    float centerOfCycleY = margin + radius + triangleMarginTop + triangleSize / 2;//圆心的Y值
//    float radiusOfCycle = hypotf(arcSize / margin * triangleSize / 2, pow(arcSize / margin * triangleSize / 2, 2) / arcSize);//半径
//    float angelOfCycle = asinf(0.5 * (arcSize / margin * triangleSize) / radiusOfCycle) * 2;//角度
//    //绘制左边三角形
//    CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop);
//    CGContextAddLineToPoint(context, arcStartX , arcStartY);
//    CGContextAddArc(context, centerOfCycleX, centerOfCycleY, radiusOfCycle, M_PI + angelOfCycle / 2, M_PI - angelOfCycle / 2, 1);
//    CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop + triangleSize);
//         }
//    CGContextMoveToPoint(context, margin, radius + margin);
//    CGContextAddArc(context, radius + margin, margin + radius, radius, M_PI, 1.5 * M_PI, 0);
//    CGContextAddLineToPoint(context, margin + radius, 0);
//    CGContextAddLineToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 0, radius + margin);
//    
//    
//    //
//    
////    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
//    CGContextSetBlendMode(context, kCGBlendModeClear);
//    
//    
//    CGContextDrawPath(context, kCGPathFill);
//}
@end

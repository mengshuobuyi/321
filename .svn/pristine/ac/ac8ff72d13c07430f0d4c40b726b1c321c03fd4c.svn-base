//
//  progressView.h
//  wenyao-store
//
//  Created by carret on 15/4/9.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClient.h"
#import "XHMessageBubbleFactory.h"
@interface progressView : UIView
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
- (XHBubbleMessageType)getBubbleMessageType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeShow;
@property (nonatomic, assign) XHBubbleMessageType bubbleMessageType;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
 
@property (nonatomic ,strong)UIImage *bgimg;
- (void)setProgress:(float)newProgress;
-(void)sendToSe:(NSString *)str imagData:(NSData *)imageData success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure uploadProgressBlock:(void (^)(NSString* str, float progress ))uploadProgressBlock;
@end

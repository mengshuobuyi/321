 

#import "QWCommon.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

@implementation QWCommon



//初始化
NSMutableDictionary * helpInfoDic;
NSMutableDictionary * gameIDDic;





//TODO: 获得设备标识
+(QWDevice)getDevice
{
    
    NSString * ret = [[UIDevice currentDevice] model];
    NSRange range = [ret rangeOfString:@"iPad"];
    if (range.length) {
        //ipad
        return QWDevice_iPad;
    }
    
    //iphone or ipod
    return QWDevice_iPhone;
}

//TODO: 获得对应的ipad坐标
+(CGPoint)getLargePoint:(CGPoint)point
{
    if ([QWCommon getDevice] == 1) {
        return point;
    }
    
    float x = point.x/480 * 1024;
    
    float y = point.y/320 * 768;
    
    return CGPointMake(x, y);
}





//TODO: 振动调用
+(void)invokeVibration
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

//TODO: 显示AppStore中某个应用的评论
//主要用于提醒用户书写评论
+(void)showAppStoreCommentWithAppID:(int)appID
{
    NSString *str = [NSString stringWithFormat:  
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",  
                     appID ];     
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//TODO: 获得系统版本
+(float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


//接近传感器
//播放声音的时候才能用
+(void)addProximityWithObserver:(id)observer sel:(SEL)sel
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel 
                                                 name:UIDeviceProximityStateDidChangeNotification 
                                               object:nil];
}

//UIButton设置高亮模式
+(void)exchangeButtonBackgroundImage:(UIButton *)btn
{
    UIImage * img =  [btn backgroundImageForState:UIControlStateNormal] ;
    UIImage * imgH =  [btn backgroundImageForState:UIControlStateHighlighted] ;
    [btn setBackgroundImage:imgH forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
 
}


//TODO: 强制旋转屏幕
+(void)forceRotateInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = [window.subviews objectAtIndex:0];
    [view removeFromSuperview];
    [window addSubview:view];
    
    //强制转换 app store 有可能不通过
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//    {
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//                                       withObject:(id)UIDeviceOrientationPortrait];
//    }
}

//获取APNS设备令牌
+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken
{
    NSMutableString * deviceTokenStr = [NSMutableString stringWithFormat:@"%@",deviceToken];
    
    NSRange allRang;
    allRang.location = 0;
    allRang.length = deviceTokenStr.length;
    
    [deviceTokenStr replaceOccurrencesOfString:@" " withString:@"" options:NULL range:allRang];
    
    NSRange begin = [deviceTokenStr rangeOfString:@"<"];
    
    NSRange end = [deviceTokenStr rangeOfString:@">"];
    
    NSRange deviceRange;
    deviceRange.location = begin.location + 1;
    deviceRange.length = end.location - begin.location -1;
    
    return [deviceTokenStr substringWithRange:deviceRange];
}

//TODO: 从字符串中获得英文其中包含的英文个数
+(int)getEnglishCharacterLength:(NSString *)str
{
    int engLength = 0;
    for (int i =0; i<[str length]; i++) {
        int character = [str characterAtIndex:i];
        if (character < 255) {
            engLength ++;
        }
    }
    
    return engLength;
}


+(NSArray *)sortChaFromSmallToLarge:(NSArray *)arry
{
    return [arry sortedArrayUsingSelector:@selector(compare:options:)];
}

//获得中文gbk编码
+(NSStringEncoding)getGBKEncoding
{
    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
}


//imageview的oldrect,要适配torect大小,等比例全部显示.
+(CGRect)rescale:(CGRect)oldRect toRect:(CGRect)toRect
{
    float imgWidth = oldRect.size.width;
    float imgHeight = oldRect.size.height;
    
    float imgRateWH = imgWidth/imgHeight;
    
    float viewRate = toRect.size.width/toRect.size.height;
    
    
    
    
    float newWidth , newHeight;
    float x,y;
    
    if (imgRateWH > 1) {
        
        
        if (imgRateWH < viewRate) {
            newHeight = toRect.size.height;
            //imgw/imgh = neww/newh
            newWidth = imgWidth/imgHeight*newHeight;
            
            x = -(newWidth - toRect.size.width)/2;
            y = 0;
            
        }
        else
        {
            newWidth = toRect.size.width;
            newHeight = imgHeight/imgWidth * newWidth;
            
            x = 0;
            y = -(newHeight - toRect.size.height)/2;
        }
    }
    else if (imgRateWH < 1)
    {
        
        
        if (imgRateWH < viewRate) {
            newHeight = toRect.size.height;
            //imgw/imgh = neww/newh
            newWidth = imgWidth/imgHeight*newHeight;
            
            x = -(newWidth - toRect.size.width)/2;
            y = 0;
            
        }
        else
        {
            newWidth = toRect.size.width;
            newHeight = imgHeight/imgWidth * newWidth;
            
            x = 0;
            y = -(newHeight - toRect.size.height)/2;
        }
    }
    else
    {
        if (toRect.size.width > toRect.size.height) {
            newHeight = toRect.size.height;
            //imgw/imgh = neww/newh
            newWidth = imgWidth/imgHeight*newHeight;
            
            x = -(newWidth - toRect.size.width)/2;
            y = 0;
        }
        else
        {
            newWidth = toRect.size.width;
            newHeight = imgHeight/imgWidth * newWidth;
            
            x = 0;
            y = -(newHeight - toRect.size.height)/2;
        }
    }
    
    
    
    CGRect newRect = CGRectMake(oldRect.origin.x + x, oldRect.origin.y + y, newWidth, newHeight);
    
    return newRect;
}

+(UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.layer.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end

/************************************************* 
 
 Description: 
 
 重力感应模拟方向盘

 *************************************************/ 
/*!
 @header QWSteeringWheel.h
 @abstract 此协议包括获取GPS定位信息,并将GPS定位信息解码成城市街道信息
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */
#import <Foundation/Foundation.h>
#import "QWCoreMotion.h"


@protocol QWSteeringWheelDelegate;


typedef enum 
{
    QWSteeringWheelMotionStateNone = 0,       //直行,不按任何按键 -7~7度
    QWSteeringWheelMotionStateSmallQuick,     //小角度转弯 7~15度 -7~-15度
    QWSteeringWheelMotionStateMiddleQuick,    //15~35度 -15~-35度
    QWSteeringWheelMotionStateQuick,          //每隔一段时间,快速点击某个按键
    QWSteeringWheelMotionStateLong            //保持按键处于按下状态
}QWSteeringWheelMotionState;


typedef enum 
{
    QWSteeringWheelDirectionNone = -1,   //直行
    QWSteeringWheelDirectionLeft = 0,    //箭头左
    QWSteeringWheelDirectionRight        //箭头右
}QWSteeringWheelDirection;

@interface QWSteeringWheel : NSObject
    <QWCoreMotionDelegate>
{
    //重力感应
    QWCoreMotion * coreMotion;
    
    QWSteeringWheelDirection lastDirection;
    QWSteeringWheelMotionState lastMotionState;

    
   __weak id<QWSteeringWheelDelegate> delegate;
    
    
    //周期循环的timer
    NSTimer * circleTimer;
    
    float circleInterval;
    
    //调用stopCircle的计数标识
    //-2代表在none区域,等待状态改变
    //-1代表状态切换,进行循环
    long circleCount;
    
    //标记当前circle的周期
    int circleTag;
    
}

@property (nonatomic , retain) QWCoreMotion * coreMotion;
@property (nonatomic , weak) id<QWSteeringWheelDelegate> delegate;

@property (nonatomic) QWSteeringWheelDirection lastDirection;
@property (nonatomic) QWSteeringWheelMotionState lastMotionState;


@property (nonatomic , retain) NSTimer * circleTimer;

-(id)initWithMotionMode:(QWCoreMotionMode)motionMode;

-(id)initWithMotionMode:(QWCoreMotionMode)motionMode interval:(float)interval;

-(void)startCoreMotion;
-(void)stopCoreMotion;


@end


@protocol QWSteeringWheelDelegate <NSObject>

//转向周期开始
-(void)QWSteeringWheelStartCircle:(QWSteeringWheel *)steeringWheel 
                       motionState:(QWSteeringWheelMotionState)state 
                         direction:(QWSteeringWheelDirection)direction;

//转向周期结束
-(void)QWSteeringWheelStopCircle:(QWSteeringWheel *)steeringWheel
                      motionState:(QWSteeringWheelMotionState)state 
                        direction:(QWSteeringWheelDirection)direction;

//获得时时的陀螺仪数据
-(void)QWSteeringWheelCoreMotion:(float)x y:(float)y z:(float)z;

//停止获取转向回调
-(void)QWSteeringWheelCoreMotionDidStop:(QWSteeringWheel *)steeringWheel;

@end

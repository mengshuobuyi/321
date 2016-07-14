 

#import "QWSteeringWheel.h"

@implementation QWSteeringWheel

//陀螺仪上数据
//0~1标识0度~180度
#define SMALLQUCIK_ANGLE    0.107
#define MIDDLEQUCIK_ANGLE   0.196
#define QUCIK_ANGLE         0.419
#define LONG_ANGLE          0.53

//从陀螺仪更新数据的周期
#define UPADATE_INTERVAL        0.001

//响应时间的周期
#define SMALLQUCIK_INTERVAL     10
#define MIDDLEQUCIK_INTERVAL    15
#define QUCIK_INTERVAL          30
#define LONG_INTERVAL           FLT_MAX

@synthesize coreMotion;
@synthesize lastDirection,lastMotionState;
@synthesize delegate;
@synthesize circleTimer;



-(id)initWithMotionMode:(QWCoreMotionMode)motionMode interval:(float)interval 
{
    self = [super init];
    if (self) {
        circleInterval = interval;
        coreMotion = [[QWCoreMotion alloc] init];
        coreMotion.motionMode = motionMode;
        coreMotion.delegate = self;
        [coreMotion setSecond:circleInterval]; 
        
        lastDirection = QWSteeringWheelDirectionNone;
        lastMotionState = QWSteeringWheelDirectionNone;
    }
    return self;
}


-(id)initWithMotionMode:(QWCoreMotionMode)motionMode
{
    self = [self initWithMotionMode:motionMode interval:UPADATE_INTERVAL];
    return self;
}

-(void)dealloc
{
    [coreMotion stopUpdate];
 
    
    [circleTimer invalidate];
 
 
}



-(void)startCoreMotion
{
    [coreMotion startUpdate];
    circleCount = -2;
    circleTimer =  [NSTimer scheduledTimerWithTimeInterval:UPADATE_INTERVAL target:self selector:@selector(circleMotion) userInfo:nil repeats:YES]  ;
    
}

-(void)stopCoreMotion
{
    circleCount = -2;
    [coreMotion stopUpdate];
    
    if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelCoreMotionDidStop:)])
      {
        [delegate QWSteeringWheelCoreMotionDidStop:self];
      }
}

-(void)circleMotion
{
    if (-2 == circleCount) {
//        //NSLog(@" -2 circleMotion");
        return;
    }
    
    if (-1 == circleCount) {//等待一个循环周期
//        //NSLog(@" -1 circleMotion");
    }
    else if (0 == circleCount)
      {
//        //NSLog(@" 0 circleMotion");
        if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelStartCircle:
                                                               motionState: 
                                                               direction:)])
          {
            [delegate QWSteeringWheelStartCircle:self 
                                     motionState:lastMotionState 
                                       direction:lastDirection];
        }
        
        if (lastMotionState == QWSteeringWheelMotionStateNone) {
            circleCount = -2;
            return;
        }
        
      }
    else if (circleTag == circleCount)
      {
//        //NSLog(@" %d ,%d , %d circleMotion",circleTag,lastMotionState,lastDirection);
        if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelStopCircle:
                                                               motionState: 
                                                               direction:)]) 
          {
            [delegate QWSteeringWheelStopCircle:self 
                                     motionState:lastMotionState 
                                       direction:lastDirection];
          }
        circleCount = -1;
        return;
      }
    
    circleCount ++;
}

-(void)QWCoreMotionWidthx:(float)x y:(float)y z:(float)z
{
    if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelCoreMotion:
                                                           y:z:)]) 
      {
        [delegate QWSteeringWheelCoreMotion:x y:y z:z];
      }
    
    
    float fabsY = fabsf(y);
    QWSteeringWheelMotionState nowMotionState = QWSteeringWheelMotionStateNone;
    QWSteeringWheelDirection nowDirection = QWSteeringWheelDirectionNone;
    
    //判断按键状态
    if (fabsY > LONG_ANGLE) {//50度
        nowMotionState = QWSteeringWheelMotionStateLong;
        circleTag = LONG_INTERVAL;
        //        //NSLog(@"@@@@@@  MotionStateLong");
    }
    else if (fabsY > QUCIK_ANGLE)//35度
      {
        nowMotionState = QWSteeringWheelMotionStateQuick;
        circleTag = QUCIK_INTERVAL / (circleInterval / UPADATE_INTERVAL);
      }
    else if (fabsY > MIDDLEQUCIK_ANGLE)//15度
      {
        nowMotionState = QWSteeringWheelMotionStateMiddleQuick;
        circleTag = MIDDLEQUCIK_INTERVAL / (circleInterval / UPADATE_INTERVAL);
      }
    else if (fabsY > SMALLQUCIK_ANGLE)//7度
      {
        nowMotionState = QWSteeringWheelMotionStateSmallQuick;
        circleTag = SMALLQUCIK_INTERVAL / (circleInterval / UPADATE_INTERVAL);
        //        //NSLog(@"$$$$$$$$  MotionStateQuick");
      }
    else 
      {
        nowMotionState = QWSteeringWheelMotionStateNone;
        
        circleCount = -2;
        if (lastDirection != QWSteeringWheelDirectionNone && 
            lastMotionState != QWSteeringWheelMotionStateNone)
          {
            if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelStopCircle:
                                                                   motionState: 
                                                                   direction:)]) 
              {
                [delegate QWSteeringWheelStopCircle:self 
                                         motionState:QWSteeringWheelMotionStateNone 
                                           direction:lastDirection];
              }
          }
        lastMotionState = nowMotionState;
        
        return;
      }
    
    
    
    //没有变化
    if (nowMotionState == lastMotionState) {
        return;
    }
//    //NSLog(@"~~~~~~~~start~~~~~~~");
//    //NSLog(@"state %d",nowMotionState);
    
    //motionstate变化跨度大
    //一次跨过1个以上的角度判断区
//    if (fabsf(nowMotionState - lastMotionState) > 1) {
//        //NSLog(@"\n\n\n\n\n\n\n\nwaring !!!! %f , now = %d , last = %d\n\n\n\n\n\n\n\n", fabsf(nowMotionState - lastMotionState),nowMotionState,lastMotionState);
////        abort();
//    }
    
    
    
    //判断按键类型
    if (x>0) {
        
        //左
        if (y < -SMALLQUCIK_ANGLE) 
          {
            nowDirection = QWSteeringWheelDirectionLeft;
          }
        else if(y >SMALLQUCIK_ANGLE)//右
          {
            nowDirection = QWSteeringWheelDirectionRight;
          }
        
    }
    else if(x < -0)
      {
        //右
        if (y < -SMALLQUCIK_ANGLE) 
          {
            nowDirection = QWSteeringWheelDirectionRight;
          }
        else if(y >SMALLQUCIK_ANGLE)//左
          {
            nowDirection = QWSteeringWheelDirectionLeft;
          }
        
      }
    else //忽略
      {
        //不被响应
        //NSLog(@"%f,%f,%f",x,y,z);
        //NSLog(@"### %f",x);
        return;
      }
    

    
    
    if (nowDirection != lastDirection) {
        
        //方向改变
        if (lastDirection != QWSteeringWheelDirectionNone) {
            if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelStopCircle:
                                                                   motionState: 
                                                                   direction:)]) 
              {
                [delegate QWSteeringWheelStopCircle:self 
                                         motionState:lastMotionState 
                                           direction:lastDirection];
              }
        }
        else
          {
            //NSLog(@"############## 方向为 none");
          }
        lastDirection = nowDirection;
    }
    
    //结束上一区域操作
  {
    if (delegate && [delegate respondsToSelector:@selector(QWSteeringWheelStopCircle:
                                                           motionState: 
                                                           direction:)]) 
      {
        [delegate QWSteeringWheelStopCircle:self 
                                 motionState:lastMotionState 
                                   direction:lastDirection];
      }
    
    circleCount = -2;
  }
    
    
    
    lastMotionState = nowMotionState;
    
    
    circleCount = -1;
//    //NSLog(@"~~~~~~~~end~~~~~~~");
    return;
    
}

#pragma mark -

@end

 

#import "QWRockerEvent_4.h"

@implementation QWRockerEvent_4

//判断角度是否小于M_PI_4
-(int)getLessangle:(float )x y:(float)y
{
    
    float length = sqrtf((x-m_centerX)*(x-m_centerX) + (y-m_centerY)*(y-m_centerY));
    
    float sinV = fabsf(x-m_centerX)/length;
    float du = fabsf(asinf(sinV));
    //    //NSLog(@"x = %f y = %f du =%f",x,y,du);
    if (du <= (M_PI_4)) {//贴近y轴
                           //        //NSLog(@"度数小于22.5");
        return -1;
    }
    else //贴近x轴
      {
        //        //NSLog(@"度数大于77.5");
        return 1;
      }
    
}

@end

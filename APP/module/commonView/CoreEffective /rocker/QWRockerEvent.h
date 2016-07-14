/*************************************************  
 
 Description: 
 
 摇杆控制事件.
 支持8方向,4方向
 
 *************************************************/ 

#import <UIKit/UIKit.h>

//这样排序是为减少if判断,根据特定公式直接读取
//quad为象限函数getQuadrant返回值,angle为角度函数getLessangle返回值.
//symbol在以(m_centetX,m_centerY)为原点的坐标系里时,当x*y>0为1;否则为-1
//也就是点在2,4象限时,symbol为-1;
//公式ret = Quad+(symbol)*angle;
typedef enum 
{
    QWRockerEventNone,
    QWRockerEventUp,//上 = 1
    QWRockerEventUpRight,//右上 = 2
    QWRockerEventRight,//右 = 3
    QWRockerEventDownRight,//右下 = 4
    QWRockerEventDown,//下 = 5
    QWRockerEventDownLeft,//左下 = 6
    QWRockerEventLeft,//左 = 7
    QWRockerEventUpLeft,//左上 = 8
}QWRockerEventDirection;


@protocol QWRockerEventDelegate <NSObject>

-(void)QWRockerEventClicked:(id)rocker direction:(QWRockerEventDirection)direction;

@end

@interface QWRockerEvent : UIView
{
    //背景图片
    UIImageView * bgImageView;
    
    //移动图片
    UIImageView * moveImageView;
    
    //移动方向
    QWRockerEventDirection direction;
    
  __weak  id<QWRockerEventDelegate> delegate;
    
    //圆心的x,y值
    float m_centerX;
    float m_centerY;
}

@property (nonatomic , retain) UIImageView * bgImageView;

@property (nonatomic , retain) UIImageView * moveImageView;

@property (nonatomic , weak) id<QWRockerEventDelegate> delegate;

- (id)initWithFrame:(CGRect)frame bgImage:(UIImage *)bgImage moveImage:(UIImage *)moveImage;



-(int)getLessangle:(float )x y:(float)y;
-(int)getQuadrant:(float)x y:(float)y;
@end

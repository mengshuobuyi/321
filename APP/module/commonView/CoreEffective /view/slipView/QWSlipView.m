 

#import "QWSlipView.h"


@interface QWSlipView()

-(CGSize)checkdistance:(NSSet * )touches;
-(void)checkSlip:(NSSet *)touches;
-(void)checkDirection:(NSSet *)touches;

@end

@implementation QWSlipView


@synthesize delegate;
@synthesize m_timer;
@synthesize state;

#define X_MIN_DISTANCE 100

#define Y_MIN_DISTANCE 100

#define SAFE_DISTANCE 5

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        state = QWSlipViewStateNone;
        direction = QWSlipViewFromNone;
        beginPoint = CGPointZero;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)dealloc
{
 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * touchArry = [touches allObjects];
    UITouch * touch = [touchArry objectAtIndex:0];
    beginPoint = [touch locationInView:self];
    
    state = QWSlipViewStateStart;
    
    
    [super touchesBegan:touches withEvent:event];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self checkDirection:touches];
    [self checkSlip:touches];
    
    [super touchesMoved:touches withEvent:event];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    

    
    [m_timer invalidate];
    m_timer = NULL;
    
    beginPoint = CGPointZero;
    [super touchesEnded:touches withEvent:event];

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [m_timer invalidate];
    m_timer = NULL;
    beginPoint = CGPointZero;
    [super touchesEnded:touches withEvent:event];

}


//检查移动距离是否到达最小呼出值
-(CGSize)checkdistance:(NSSet * )touches
{
    NSArray * touchArry = [touches allObjects];
    UITouch * touch = [touchArry objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    return CGSizeMake(point.x - beginPoint.x, point.y - beginPoint.y);
}

-(void)checkDirection:(NSSet *)touches
{

    
    NSArray * touchArry = [touches allObjects];
    UITouch * touch = [touchArry objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    CGPoint lastPoint = [touch previousLocationInView:self];
    
    float width = point.x - lastPoint.x;
    float height = point.y - lastPoint.y;
    
    
    //处于安全移动距离,不处理
    if (fabsf(width) < SAFE_DISTANCE && fabsf(height) < SAFE_DISTANCE) {
        
        return;
    }
    
    //当滑动角度接近45度时,会出现direction判断不准确.
    //如果让其判断准确,则灵敏度下降
    //原因是由于width和height的值相近.
    
    QWSlipViewFromDirection newDriction = direction;
    
    if (fabsf(width) > fabsf(height)) {//判断为横向移动
        if (fabsf(height) <= Y_MIN_DISTANCE) {
            if (width < 0) {//向左
                newDriction = QWSlipViewFromRight;
            }
            else    //向右
              {
                newDriction = QWSlipViewFromLeft;
              }
        }
    }
    else    //判断为纵向移动
      {
        if (fabsf(width) <= Y_MIN_DISTANCE) {
            if (height < 0) {//向上
                newDriction = QWSlipViewFromDown;
            }
            else    //向下
              {
                newDriction = QWSlipViewFromUp;
              }
        }
      }
    
    
    //方向改变重置
    if (newDriction != direction || direction == QWSlipViewFromNone) {
        beginPoint = lastPoint;
        direction = newDriction;
        [m_timer invalidate];
     
        m_timer = NULL;
    }
    
}

-(void)checkSlip:(NSSet *)touches
{
    CGSize distancePoint = [self checkdistance:touches];
    
    switch (direction) {
        case QWSlipViewFromLeft:
        case QWSlipViewFromRight:
        {
            if (fabsf(distancePoint.height) <= Y_MIN_DISTANCE) {
                
                if (fabsf(distancePoint.width) > X_MIN_DISTANCE) {
                    
                    if (!m_timer) {
                        m_timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delegateSelector) userInfo:nil repeats:YES]  ;
                    }
                }
            }
            break;
        } 
            
        case QWSlipViewFromUp:
        case QWSlipViewFromDown:
        {
            if (fabsf(distancePoint.width) <= X_MIN_DISTANCE) {
                
                if (fabsf(distancePoint.height) > Y_MIN_DISTANCE) {
                    
                    if (!m_timer) {
                        m_timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delegateSelector) userInfo:nil repeats:YES]  ;
                    }
                }
            }
            break;
        } 
        case QWSlipViewFromNone:   //不处理
            break;
            
            
    }
    


}

-(void)delegateSelector
{
    if (delegate && [delegate respondsToSelector:@selector(slipCompleted: FromDirection:)]) {
        
        [delegate slipCompleted:self FromDirection:direction];
        
    }
}



@end

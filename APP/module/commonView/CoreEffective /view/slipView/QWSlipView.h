/************************************************* 
 
 判断手势滑动.
 支持4个方向.
 
 *************************************************/ 

#import <UIKit/UIKit.h>




typedef enum {
    QWSlipViewFromNone,
    QWSlipViewFromLeft,
    QWSlipViewFromUp,
    QWSlipViewFromRight,
    QWSlipViewFromDown
}QWSlipViewFromDirection;


typedef enum {
    QWSlipViewStateNone,
    QWSlipViewStateStart,
    QWSlipViewStateFinished
    
}QWSlipViewState;



@protocol QWSlipViewDelegate <NSObject>

//TODO: direction: 用户触发的滑动方向
-(void)slipCompleted:(id)sender FromDirection:(QWSlipViewFromDirection)direction;

@end

@interface QWSlipView : UIView
{
    //判断开始坐标
    CGPoint beginPoint;
    
    //判断状态
    QWSlipViewState state;
    
    QWSlipViewFromDirection direction;
    
  __weak  id<QWSlipViewDelegate> delegate;
    
    NSTimer * m_timer;
}

@property (nonatomic , weak) id<QWSlipViewDelegate> delegate;
@property (assign) QWSlipViewState state;
@property (nonatomic , retain) NSTimer * m_timer;
@end

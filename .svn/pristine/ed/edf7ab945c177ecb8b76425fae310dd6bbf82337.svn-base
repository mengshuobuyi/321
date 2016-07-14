/************************************************* 
 
 Description: 
 
 弹出按钮

 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol QWPopupView_circleItemDelegate;

@interface QWPopupView_circleItem : UIButton

{
    CGMutablePathRef showPath;
    CGMutablePathRef hidePath;
    
    //动画结束的回调
    
    //动画状态标识
    bool isShowAnimation;
    
    float m_startangle;
    float m_endangle;
    
   __weak id<QWPopupView_circleItemDelegate> delegate;
    
    
}
@property (nonatomic , weak) id<QWPopupView_circleItemDelegate> delegate;

-(void)startShowAnimation;
-(void)startHideAnimation;
-(void)addMoveAnimationWithPathCenter:(CGPoint)pathCenter 
                            startangle:(float)starangle 
                             endangle:(float)endangle 
                              randius:(float)randius
                          isClockWise:(bool)isClockWise;
@end


//按钮动画结束的回调
@protocol QWPopupView_circleItemDelegate <NSObject>

-(void)circleItemShowAnimationFinished:(QWPopupView_circleItem *)item;
-(void)circleItemHideAnimationFinished:(QWPopupView_circleItem *)item;

@end
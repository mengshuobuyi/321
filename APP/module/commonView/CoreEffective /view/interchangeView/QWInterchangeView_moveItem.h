/************************************************* 
 
 Description: 
 
 可以拖拽的button

 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol QWInterchangeView_moveItemDelegate;


@interface QWInterchangeView_moveItem : UIButton
{
   __weak id<QWInterchangeView_moveItemDelegate> delegate;
    
    //在touch事件结束的时候,要设定的值
    //外部可以在本类回调函数中设置值
    CGPoint m_nowCenterPoint;
    
    float borderWidth;
    float borderHeight;
    
    //标识是否处于互换模式
    bool m_canItercanged;
    
    //交换的标识
    int m_interchangeTag;

}

@property (nonatomic , weak)id<QWInterchangeView_moveItemDelegate> delegate;
@property (nonatomic) CGPoint m_nowCenterPoint;
@property (nonatomic) bool m_canItercanged;
@property (nonatomic) int m_interchangeTag;
@end


@protocol QWInterchangeView_moveItemDelegate <NSObject>

-(void)moveItemMoveEnd:(QWInterchangeView_moveItem *)item;
-(void)moveItemMoveStart:(QWInterchangeView_moveItem *)item;

@end
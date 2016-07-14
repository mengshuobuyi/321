 

#import <UIKit/UIKit.h>

@protocol QWBarDelegate;

@interface QWBar : UIView
{
   __weak id<QWBarDelegate> delegate;
    
    //移动的背景
    UIImageView * m_moveImgView;
    
    //当前点击按钮
    UIButton * m_lastBtn;
}
@property (nonatomic , weak) id<QWBarDelegate> delegate;
@property (nonatomic , retain) UIImageView * m_moveImgView;
@property (nonatomic , retain) UIButton * m_lastBtn;;

-(void)setItemsWithImgs:(NSArray *)imgs;

- (id)initWithFrame:(CGRect)frame
              bgImg:(UIImage *)bgImg
            moveImg:(UIImage *)moveImg;
- (id)initWithFrame:(CGRect)frame
              bgImg:(UIImage *)bgImg
            moveImg:(UIImage *)moveImg
           itemImgs:(NSArray *)itemImgs;
@end


@protocol QWBarDelegate <NSObject>

-(void)QWBarItemsClicked:(QWBar *)sender index:(int)index;

@end
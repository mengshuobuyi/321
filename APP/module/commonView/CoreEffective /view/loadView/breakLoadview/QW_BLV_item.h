 

#import <UIKit/UIKit.h>

@protocol QW_BLV_itemDelegate;

@interface QW_BLV_item : UIView
{
    
  __weak  id<QW_BLV_itemDelegate> m_delegate;
    
    CGSize m_superSize;
    
    UIImageView * m_imgView;
}

@property (nonatomic , weak) id<QW_BLV_itemDelegate> m_delegate;
@property (nonatomic , retain) UIImageView * m_imgView;

- (id)initWithFrame:(CGRect)frame superSize:(CGSize)superSize showImg:(UIImage *)showImg;
- (id)initWithFrame:(CGRect)frame superSize:(CGSize)superSize;
-(void)startAnimation;
-(void)setImage:(UIImage *)image;
@end


@protocol QW_BLV_itemDelegate <NSObject>

-(void)QW_BLV_itemAnimationFinished:(QW_BLV_item *)item;

@end

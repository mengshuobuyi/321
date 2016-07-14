 

#import <UIKit/UIKit.h>
#import "QWLoadView.h"

@interface QWBreakLoadView : QWLoadView
{
    UIImage * m_superImage;
    
    NSMutableArray * m_itemsArry;
    
    UIView * m_bgView;
}


@property (nonatomic , retain) UIImage * m_superImage;

@property (nonatomic , retain) NSMutableArray * m_itemsArry;

@property (nonatomic , retain) UIView * m_bgView;


- (id)initWithFrame:(CGRect)frame
       loadingImage:(UIImage *)loadingImage
       superViewImg:(UIImage *)superViewImg;

-(void)startLoading:(double)duration superImage:(UIImage *)superImage;


@end

 

#import <UIKit/UIKit.h>


@interface QWPageControl : UIPageControl {

	UIImage* activeImage;
    UIImage* inactiveImage;
	CGSize dotsSize;
    float gap;
}

@property (nonatomic , retain) UIImage* activeImage;
@property (nonatomic , retain) UIImage* inactiveImage;


- (id)initWithFrame:(CGRect)frame
          activeImg:(UIImage *)activeImg
        inactiveImg:(UIImage *)inactiveImg
                gap:(float)aGap;

- (id)initWithFrame:(CGRect)frame
          activeImg:(UIImage *)activeImg
        inactiveImg:(UIImage *)inactiveImg;

@end

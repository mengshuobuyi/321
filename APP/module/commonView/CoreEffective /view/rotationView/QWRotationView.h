/************************************************* 
 
 Description: 
 
 以四边中一边的重点为圆心摇摆,摇摆角度为-X~X,X为随即角度.

 *************************************************/ 

#import <UIKit/UIKit.h>


typedef enum {
    QWRotationViewCenterStateLeft,
    QWRotationViewCenterStateUp,
    QWRotationViewCenterStateRight,
    QWRotationViewCenterStateDown
}QWRotationViewCenterState;

@interface QWRotationView : UIView
{
    
    

    
    //是否摇摆的标识
    bool isRocker;
    
    
    
    
    UIButton * imageButton;
    
}

@property (nonatomic , retain) UIButton * imageButton;

- (id)initWithFrame:(CGRect)frame 
        centerState:(QWRotationViewCenterState)centerState 
           imgsArry:(NSArray *)imgsArry;

-(void)startRocker;
-(void)stopRocker;

@end

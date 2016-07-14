 

#import <UIKit/UIKit.h>

typedef enum {
    QWLabel_Rock_Left,
    QWLabel_Rock_Right
}QWLabel_RockDirection;

@interface QWLabel_rocker : UIView
{
    
    UILabel * m_label;
    
    NSString * m_message;
    
    float m_fontSize;
    
    //second
    float m_duration;
    
    //anim direction
    //
    QWLabel_RockDirection m_currentTag;
    
    bool m_animStarted;
    
    bool m_animCanStart;
}
@property (nonatomic , retain) UILabel * m_label;
@property (nonatomic , retain) NSString * m_message;

- (id)initWithFrame:(CGRect)frame message:(NSString *)msg fontSize:(float)fontsize duration:(float)duration;
- (id)initWithFrame:(CGRect)frame message:(NSString *)msg fontSize:(float)fontsize;
-(void)startWithDuration:(float)duration;
-(void)stop;

@end

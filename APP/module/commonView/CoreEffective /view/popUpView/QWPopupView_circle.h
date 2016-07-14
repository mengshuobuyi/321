/************************************************* 
 
 Description: 
 
 放射状弹出对话框
 
 特殊说明:
 需求是最多3条.
 该弹出框加载放射状线条动画,是先加载一条后,后续的加载都是动态的.
 当加载条数>2时,依次先再第一条的右边加载一条,再在左边加载一条.
 
 背景图大小为480*320
 
 *****************使用方式**********************************
 float centerX = 450-240;
 float centerY = 290;
 NSArray * array = [NSArray arrayWithObjects:[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"],[UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"], [UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"], [UIImage imageNamed:@"setting"],[UIImage imageNamed:@"settingH"], nil];
 
 QWPopupView_circle * test = [[QWPopupView_circle alloc] initWithFrame:CGRectMake(240, 0, 240, 320) center:CGPointMake(centerX, centerY) itemsImgArray:array isClockwise:NO];
 [self.view addSubview:test];

 *************************************************/ 

#import <UIKit/UIKit.h>
#import "QWPopupView_circleItem.h"

@protocol QWPopupView_circleDelegate <NSObject>

//按钮点击
-(void)circleItemsClicked:(QWPopupView_circleItem *)item;

//动画开始
-(void)circleItemsAnimationStart:(bool)isShow;

//动画结束
-(void)circleItemsAnimationFinished:(bool)isShow;

@end

@interface QWPopupView_circle : UIView
    <QWPopupView_circleItemDelegate>

{
    //触发动画按钮的center
    CGPoint centerPoint;
    
    //数组中,奇数为normal图片,偶数为heightLight图片
    //子按钮的图片数组
    NSArray * itemsImgArray;
    
    //circleItem数组,用于显示和隐藏按钮
    //保存按钮
    NSMutableArray * itemsArray;
    
    //统计完成动画的itmes数量
    int finishedItemsCount;
    
    //是否为逆时针
    bool isClockWise;
    
    //设置按钮
    UIButton * settingBtn;
    
    //线条图片
    UIImageView * bgImageView;
    
   __weak id<QWPopupView_circleDelegate> delegate;
}

@property (nonatomic , retain) NSArray * itemsImgArray;
@property (nonatomic , retain) NSMutableArray * itemsArray;
@property (nonatomic , retain) UIButton * settingBtn;
@property (nonatomic , retain) UIImageView * bgImageView;
@property (nonatomic , weak) id<QWPopupView_circleDelegate> delegate;

- (id)initWithFrame:(CGRect)frame center:(CGPoint )point itemsImgArray:(NSArray *)items isClockwise:(bool)isClockwise;

@end

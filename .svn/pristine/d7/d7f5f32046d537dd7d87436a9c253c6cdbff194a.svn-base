/************************************************* 
 
 Description: 
 
 实现items的拖拽互换
 支持4个item的互换

 *************************************************/ 


//NSArray * rectArry = [NSArray arrayWithObjects:@"{{0,0},{50,50}}",@"{{60,0},{50,50}}",@"{{200,0},{50,50}}",
//                      @"{{0,100},{50,50}}",@"{{60,100},{50,50}}",@"{{200,100},{50,50}}",
//                      nil];
//NSArray * imgsArry = [NSArray arrayWithObjects:[UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"settingH"], nil];
//
//NSArray * highImgsArry = [NSArray arrayWithObjects:[UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"setting"], nil];
//
//QWInterchangeView * test = [[QWInterchangeView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) 
//                                                            rectsArry:rectArry 
//                                                             imgsArry:imgsArry
//                                                         highImgsArry:highImgsArry];
//[self.view addSubview:test];



#import <UIKit/UIKit.h>
#import "QWInterchangeView_moveItem.h"

@protocol QWInterchangeViewDelegate;

typedef enum {
    QWInterchangeViewStateNomal = 0,
    QWInterchangeViewStateInterchange
}QWInterchangeViewState;

@interface QWInterchangeView : UIView
    <QWInterchangeView_moveItemDelegate>
{
    //存放item的rect信息
    NSArray * itemsRectArry;
    
    NSMutableArray * itemsArry;
    
   __weak id<QWInterchangeViewDelegate> delegate;
    
    QWInterchangeViewState viewState;
}

@property (nonatomic , retain) NSArray * itemsRectArry;
@property (nonatomic , retain) NSMutableArray * itemsArry;

@property (nonatomic , weak) id<QWInterchangeViewDelegate> delegate;

@property (nonatomic) QWInterchangeViewState viewState;

-(void)changeState;

- (id)initWithFrame:(CGRect)frame 
          rectsArry:(NSArray *)rectsArry 
           imgsArry:(NSArray *)imgsArry 
       highImgsArry:(NSArray *)highImgsArry;

@end

@protocol QWInterchangeViewDelegate <NSObject>

-(void)itemsClickUp:(QWInterchangeView *)view item:(QWInterchangeView_moveItem *)item;
-(void)itemsClickDown:(QWInterchangeView *)view item:(QWInterchangeView_moveItem *)item;

@end



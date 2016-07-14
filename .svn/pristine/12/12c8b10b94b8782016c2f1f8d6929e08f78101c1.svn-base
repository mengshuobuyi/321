#import <Foundation/Foundation.h>

#define  QWH5LOADING [QWH5Loading instance]

@protocol QWH5LoadingDelegate;

@interface QWH5Loading : UIView
@property (assign) id delegate;
@property (assign) float minShowTime;

+ (instancetype)instance;
+ (instancetype)instanceWithDelegate:(id)delegate;

- (void)showLoading;
- (void)removeLoading;
- (void)stopLoading;
//立刻去掉loading，无延时
- (void)closeLoading;
@end

@protocol QWH5LoadingDelegate <NSObject>

@optional
- (void)hudStopByTouch:(id)hud;
@end
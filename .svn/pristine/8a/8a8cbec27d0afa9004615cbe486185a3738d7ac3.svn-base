//
//  WTScrollView.h
//  WTScorollView
//
//  Created by imac on 14-7-4.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock) (int clickIndex);

typedef void (^AutoScrollBlock) (UIImage *scrollIndexImg);


@interface WTScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray * pics;
@property (nonatomic,strong) NSMutableArray * imageViews;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer * scrollTimer;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int changeCurrentPage;
@property (nonatomic,assign) int scrollTopicFlag;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,copy) ClickBlock clickBlock;
@property (nonatomic,copy) AutoScrollBlock autoScrollBlock;

@property (nonatomic, strong) UIPageControl *pageControl;




/**
 * @brief  设置PageControl的frame, 页面指示器颜色. 确保下面方法在设置scrollView前调用。
 * @param  pageControlFrame    PageControl的frame.
 * @param  curColor  当前页面指示器圆点颜色.
 * @param  norColor 其余页面指示器圆点颜色.
 *
 * @return void.
 */
-(void)setPageControlFrame:(CGRect)pageControlFrame curPageColor:(UIColor *)curColor normalColor:(UIColor *)norColor;

/**
 * @brief  调用该方法将设置滚动的图片，滚动的时间间隔，以及点击图片的回掉block
 * @param  images    滚动的图片数组.
 * @param  duration  滚动的时间间隔.
 * @param  clickBlock 点击图片回调block 将点击的图片的下标传过去.
 *
 * @return void.
 */
-(void)setScrollImages:(NSArray *)images duration:(NSTimeInterval)duration clickBlock:(ClickBlock)clickBlock;


/**
 * @brief  调用改方法将设置滚动的图片，滚动的时间间隔，以及点击图片的回掉block
 * @param  images    滚动的图片数组.
 * @param  duration  滚动的时间间隔.
 * @param  clickBlock 点击图片回调block 将点击的图片的下标传过去.
 *
 * @return void.
 */
-(void)setScrollImageUrls:(NSArray *)urls duration:(NSTimeInterval)duration clickBlock:(ClickBlock)clickBlock;
/**
 * @brief  当页面不显示的时候清空定时器,减少内存的使用
 *
 * @return void.
 */
-(void)stopTimer;

/**
 * @brief  当页面从不显示到显示后调用，来创建定时器，启动自动滚动
 *
 * @return void.
 */
-(void)startTimer;

@end

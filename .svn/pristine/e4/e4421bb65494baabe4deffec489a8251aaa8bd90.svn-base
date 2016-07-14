//
//  WTScrollView.m
//  WTScorollView
//
//  Created by imac on 14-7-4.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "WTScrollView.h"
#import "UIImageView+WebCache.h"

@interface WTScrollView ()
{
    
    UIColor *_curColor;
    UIColor *_norColor;
}

@property (nonatomic , assign) CGRect pageControlFrame;
@end

@implementation WTScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化数据
       [self initScrollView];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self initScrollView];
}

-(void)layoutSubviews
{
    self.scrollView.frame  =  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.pageControl.frame = self.pageControlFrame;
    [super layoutSubviews];
}

// 初始化数据
-(void)initScrollView
{
    self.changeCurrentPage = -10;
    self.imageViews = [[NSMutableArray alloc ] init];
    self.scrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    [self.scrollView setScrollsToTop:NO];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView removeFromSuperview];
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc ] initWithFrame:CGRectMake(0, self.frame.size.height - 40, APP_W, 20)];
    [self.pageControl removeFromSuperview];
    [self addSubview:self.pageControl];
    
}

/**
 * @brief  调用改方法将设置滚动的图片，滚动的时间间隔，以及点击图片的回掉block
 * @param  images    滚动的图片数组.
 * @param  duration  滚动的时间间隔.
 * @param  clickBlock 点击图片回调block 将点击的图片的下标传过去.
 *
 * @return void.
 */
-(void)setScrollImageUrls:(NSArray *)urls duration:(NSTimeInterval)duration clickBlock:(ClickBlock)clickBlock
{
    // 持续时间
    self.duration = duration;
    
    // 回掉Block
    self.clickBlock = clickBlock;
    
    // 初始化数组
    self.pics = [[NSMutableArray alloc]init];
  
    [self.pics addObject:[urls lastObject]];
    for (id obj in urls) {
        [self.pics addObject:obj];
    }
    [self.pics addObject:[urls objectAtIndex:0]];
    
    [self.imageViews removeAllObjects];
    
    // 遍历数组，将图片放到scrollView上
    for (int i = 0 ; i < self.pics.count; i ++) {
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*APP_W,0, APP_W, self.bounds.size.height)];
        [tempImage setImageWithURL:[NSURL URLWithString:self.pics[i]] placeholderImage:nil];
        tempImage.userInteractionEnabled = YES;
        tempImage.tag = i + 10;
        // 为图片增加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(tapAction)];
        [tempImage addGestureRecognizer:tap];
        [self.imageViews addObject:tempImage];
        [self.scrollView addSubview:tempImage];
    }
    
    // 设置滚动的内容
    [self.scrollView setContentSize:CGSizeMake(APP_W*[self.pics count], self.bounds.size.height)];
    
    // 默认滚动到第二个位置
    [self.scrollView setContentOffset:CGPointMake(APP_W, 0) animated:NO];
    // 只有一条数据
    if (urls.count == 1) {
        self.scrollView.scrollEnabled = NO;
        self.pageControl.numberOfPages = 0;
    }else
    {
        self.scrollView.scrollEnabled = YES;
     
        self.pageControl.numberOfPages = self.pics.count-2;
        self.pageControl.currentPage = 0;
        
        if (_curColor) {
            self.pageControl.currentPageIndicatorTintColor = _curColor;
        }
        if (_norColor) {
            self.pageControl.pageIndicatorTintColor = _norColor;
        }
      
        
        [self stopTimer];
        [self startTimer];
    }
}

/**
 * @brief  调用改方法将设置滚动的图片，滚动的时间间隔，以及点击图片的回掉block
 * @param  images    滚动的图片数组.
 * @param  duration  滚动的时间间隔.
 * @param  clickBlock 点击图片回调block 将点击的图片的下标传过去.
 *
 * @return void.
 */
-(void)setScrollImages:(NSArray *)images duration:(NSTimeInterval)duration clickBlock:(ClickBlock)clickBlock
{
    
    // 持续时间
    self.duration = duration;
    
    // 回掉Block
    self.clickBlock = clickBlock;
    
    // 初始化数组
    self.pics = [[NSMutableArray alloc]init];
    [self.pics addObject:[images lastObject]];
    for (id obj in images) {
        [self.pics addObject:obj];
    }
    [self.pics addObject:[images objectAtIndex:0]];
    
    // 遍历数组，将图片放到scrollView上
    for (int i = 0 ; i < self.pics.count; i ++) {
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
        tempImage.image = self.pics[i];
        tempImage.userInteractionEnabled = YES;
        
        // 为图片增加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(tapAction)];
        [tempImage addGestureRecognizer:tap];
        [self.scrollView addSubview:tempImage];
    }
    
    // 设置滚动的内容
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width*[self.pics count], self.frame.size.height)];
    
    // 默认滚动到第二个位置
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
    // 只有一条数据
    if (images.count == 1) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
        self.pageControl.numberOfPages = self.pics.count-2;
        self.pageControl.currentPage = 0;
        if (_curColor) {
            self.pageControl.currentPageIndicatorTintColor = _curColor;
        }
        if (_norColor) {
            self.pageControl.pageIndicatorTintColor = _norColor;
        }
        [self stopTimer];
        [self startTimer];
    }
}

-(void)setPageControlFrame:(CGRect)pageControlFrame curPageColor:(UIColor *)curColor normalColor:(UIColor *)norColor
{
    self.pageControlFrame = pageControlFrame;
    if (curColor) {
        _curColor = curColor;
    } else {
        _curColor = nil;
    }
    if (norColor) {
        _norColor = norColor;
    } else {
        _norColor = nil;
    }
    self.pageControl.frame = self.pageControlFrame;
    [self layoutSubviews];
}


// 图片点击事件
-(void)tapAction
{
    // block回掉
    if (self.clickBlock) {
        self.clickBlock(_currentPage);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 滚动到最前面的一个的时候，让scrollView 跳到倒第二个  3 1 2 3 1
    if (scrollView.contentOffset.x <= 0) {
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width*([self.pics count]-2), 0) animated:NO];
        
    }
    // 滚动到最后一个的时候 跳到第二个  3 1 2 3 1
    else if (scrollView.contentOffset.x >= self.bounds.size.width*([self.pics count]-1)) {
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    }
    
    // 当前页
    _currentPage = scrollView.contentOffset.x/self.bounds.size.width-1;
    
    if (_currentPage !=  self.changeCurrentPage) {
        self.changeCurrentPage = _currentPage;
        if (self.autoScrollBlock) {
            
            UIImageView *imgV = self.imageViews[self.changeCurrentPage + 1];
            self.autoScrollBlock(imgV.image);
        }
    }

    // 定时器滚动的页数
    _scrollTopicFlag = _currentPage == 0 ? 2:_currentPage+2;
    self.pageControl.currentPage = _currentPage;
}


// 定时器调用
-(void)scrollTopic{
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width*self.scrollTopicFlag, 0) animated:YES];
    if (_scrollTopicFlag > [self.pics count]) {
        self.scrollTopicFlag = 1;
    }
}

// scrollView结束拖动的时候 初始化滚动控制器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}

// scrollView开始的时候清空定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

-(void)stopTimer{
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

-(void)startTimer
{
    [self stopTimer];
    if ([self.pics count] > 3) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
}

-(void)dealloc
{
  
    [self.scrollView setDelegate:nil];
    [self stopTimer];
}
@end

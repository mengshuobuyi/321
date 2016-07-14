//
//  AppGuide.m
//  quanzhi
//
//  Created by ZhongYun on 14-1-28.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AppGuide.h"
#import "PageControl.h"
#import "Constant.h"
#import "AppDelegate.h"

#import "QWGlobalManager.h"

#define TAG_BASE            100000

#define OFFSET_H    (APP_H==460?0:46)
#define COMMON_DOT  COLOR(216, 168, 254)
#define ACTIVE_DOT  COLOR(118, 52, 176)
#define TAG(v)              (v>=TAG_BASE?v-TAG_BASE:v+TAG_BASE)



UIColor* getColor(UIImage* image, int x, int y)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = image.CGImage;
    CGFloat width =  CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,        //每个颜色值8bit
                                                  width*4, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *imgdata = CGBitmapContextGetData(context);
    UIColor* resColor = [UIColor colorWithRed:imgdata[1]/255.0 green:imgdata[1]/255.0 blue:imgdata[1]/255.0 alpha:1.0];
    CGContextRelease(context);
    CGColorSpaceRelease( colorSpace );
    
    return resColor;
}


@interface AppGuide()<UIScrollViewDelegate>
{
    UIScrollView* m_scrollView;
    PageControl* m_pageControl;
}
@end

@implementation AppGuide

- (id)init
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        m_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        m_scrollView.pagingEnabled = YES; //自动滚动到subview的边界
        //m_scrollView.bounces = NO; //拖动超出范围
        m_scrollView.showsHorizontalScrollIndicator = NO;
        m_scrollView.userInteractionEnabled = YES;
        m_scrollView.delegate = self;
        [self addSubview:m_scrollView];
        
        m_pageControl = [[PageControl alloc] init];
        if (IS_IPHONE_4_OR_LESS)
        {
            m_pageControl.frame = CGRectMake((self.bounds.size.width-60)/2, 445, 60, 10);
        }else if (IS_IPHONE_5)
        {
            m_pageControl.frame = CGRectMake((self.bounds.size.width-60)/2, 530, 60, 10);
        }else if (IS_IPHONE_6)
        {
            m_pageControl.frame = CGRectMake((self.bounds.size.width-60)/2, 620, 60, 10);
        }else if (IS_IPHONE_6P)
        {
            m_pageControl.frame = CGRectMake((self.bounds.size.width-60)/2, 680, 60, 10);
        }
        m_pageControl.commonColor = RGBAHex(qwColor4, 0.5);
        m_pageControl.activeColor = [UIColor whiteColor];
        m_pageControl.commonImage = [UIImage imageNamed:@"dot01.png"];
        m_pageControl.activeImage = [UIImage imageNamed:@"dot11.png"];
        m_pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:m_pageControl];
    }
    return self;
}

- (void)dealloc
{
    [m_scrollView release];
    [super dealloc];
}

- (void)setImgNames:(NSArray *)imgNames
{
    [self clearImages];
    if (!imgNames || imgNames.count==0)
        return;
    _imgNames = [imgNames copy];
    [self buildScrollViewPics:imgNames];

    m_pageControl.numberOfPages = imgNames.count;
    m_pageControl.currentPage = 0;
    
    m_scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)buildScrollViewPics:(NSArray*)imgNames
{
    for (int i = 0; i < imgNames.count; i++)
    {
        CGRect rect = CGRectMake(i*APP_W, 0, APP_W, self.bounds.size.height);

        UIView* imgbg = [[UIView alloc] initWithFrame:rect];
        imgbg.backgroundColor = getColor([UIImage imageNamed:imgNames[i]], 0, 0);
        [m_scrollView addSubview:imgbg];
        [imgbg release];
        
        UIImageView* imgPage = IMG_VIEW([imgNames objectAtIndex:i]);
        imgPage.frame = rect;
        imgPage.contentMode = UIViewContentModeScaleAspectFit;
        imgPage.tag = TAG(i*2+0);
        imgPage.clipsToBounds = YES;
        [m_scrollView addSubview:imgPage];
        [imgPage release];
    }
    
    for (int i=0; i<3; i++) {
        UIButton* btnClose = [[UIButton alloc] init];
        [btnClose addTarget:self action:@selector(onBtnCloseTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        if (IS_IPHONE_4_OR_LESS)
        {
            btnClose.frame = CGRectMake(60 + self.frame.size.width * i, 390, APP_W-120, 40);
        }else if (IS_IPHONE_5)
        {
            btnClose.frame = CGRectMake(60 + self.frame.size.width * i, 463, APP_W-120, 40);
        }else if (IS_IPHONE_6)
        {
            btnClose.frame = CGRectMake(60 + self.frame.size.width * i, 547, APP_W-120, 40);
        }else if (IS_IPHONE_6P){
            btnClose.frame = CGRectMake(60 + self.frame.size.width * i, 605, APP_W-120, 40);
        }
        
        [btnClose setTitle:@"立即体验" forState:UIControlStateNormal];
        [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnClose.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        btnClose.alpha = 1.0;
        [m_scrollView addSubview:btnClose];
        [btnClose release];
    }
    
    m_scrollView.contentSize = CGSizeMake(imgNames.count*self.frame.size.width, self.frame.size.height);
    m_scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)onBtnCloseTouched:(UIButton*)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithBool:YES] forKey:@"showGuide"];
        [userDefault synchronize];
        
        [QWGLOBALMANAGER postNotif:NotifAppCheckVersion data:nil object:nil];
        
    }];
}

- (void)clearImages
{
    for (int i = 0; i < m_scrollView.subviews.count; i++) {
        UIView* subview = [m_scrollView.subviews objectAtIndex:i];
        if (subview.tag >= TAG_BASE) {
            [subview removeFromSuperview];
        }
    }
    m_pageControl.numberOfPages = 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int w = 0, i = 0;
    for (i = 0; i < m_pageControl.numberOfPages; i++)
    {
        if (scrollView.contentOffset.x <= w)
            break;
        w += self.bounds.size.width;
    }
    m_pageControl.currentPage = i;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if(scrollView.contentOffset.x >= ((_imgNames.count - 1) * APP_W + 50))
    {
        [self onBtnCloseTouched:nil];
    }
}

@end

void showAppGuide(NSArray* images)
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:[NSString stringWithFormat:@"showGuide_%@",APP_VERSION]] boolValue])
    {
        [QWGLOBALMANAGER postNotif:NotifAppCheckVersion data:nil object:nil];
        return;
    }

    AppGuide* guide = [[AppGuide alloc] init];
    guide.imgNames = images;
    [[UIApplication sharedApplication].keyWindow addSubview:guide];
    [guide release];
}


 

#import "QWBreakLoadView.h"
#import "QW_BLV_item.h"
#import "AFUIImageReflection.h"

@interface QWBreakLoadView()
    <QW_BLV_itemDelegate>

@end

@implementation QWBreakLoadView

@synthesize m_superImage;
@synthesize m_itemsArry;
@synthesize m_bgView;

//行数
#define ROW 3
//列数
#define COLUM 3

- (id)initWithFrame:(CGRect)frame
       loadingImage:(UIImage *)loadingImage
       superViewImg:(UIImage *)superViewImg
{
    self = [super initWithFrame:frame loadingImage:loadingImage];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        
        m_superImage =  superViewImg  ;
        
        [self initSubViews];
    }
    return self;
}


-(void)dealloc
{
 
}


-(void)startLoading:(double)duration superImage:(UIImage *)superImage
{
 
    m_superImage =  superImage  ;
    
    [self resetItemsImage];
    
    [self startLoading:duration];
}


-(void)startLoading:(double)duration
{
    m_bgView.hidden = NO;
    m_loadImgView.hidden = NO;
    [self bringSubviewToFront:m_bgView];
    [self bringSubviewToFront:m_loadImgView];
    
    
    [super startLoading:duration];
}

-(void)endLoading
{
    m_bgView.hidden = YES;
    m_loadImgView.hidden = YES;
//    [m_loadImgView.layer removeAllAnimations];
    [self loadFinished];
}

-(void)initSubViews
{
    [self resetItemsImage];
    
    if (!m_bgView) {
        m_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        m_bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        [self addSubview:m_bgView];
        m_bgView.hidden = YES;
    }
    
    
}

-(void)resetItemsImage
{
    
    if (m_itemsArry) {
        [m_itemsArry removeAllObjects];
    
    }
    
    m_itemsArry = [[NSMutableArray alloc] init];
    
    
    float itemWidth = self.frame.size.width/COLUM;
    float itemHeight = self.frame.size.height/ROW;
    
    for (int i =ROW-1; i >= 0; i --) {
        for (int j = COLUM-1; j >= 0; j --) {
            
            CGRect itemRect = CGRectMake(itemWidth * j, itemHeight * i, itemWidth, itemHeight);
            
            UIImage * itemImg = [m_superImage getImageInRect:itemRect];
            
            QW_BLV_item * item = [[QW_BLV_item alloc] initWithFrame:itemRect superSize:self.frame.size];
            //            item.backgroundColor = [UIColor colorWithPatternImage:itemImg];
            [item setImage:itemImg];
            item.m_delegate = self;
            
            item.tag = i*COLUM + j;
            
            [m_itemsArry insertObject:item atIndex:0];
            
            [self addSubview:item];
      
            
        }
    }
}

-(void)loadFinished
{

    QW_BLV_item * item = [m_itemsArry objectAtIndex:0];
    [item startAnimation];
}

-(void)QW_BLV_itemAnimationFinished:(QW_BLV_item *)item
{
    int tag = item.tag;
    
    if (tag + 1 == [m_itemsArry count]) {
        
        [super endLoading];
//        [self removeFromSuperview];
        return;
    }
    
    QW_BLV_item * itemSub = [m_itemsArry objectAtIndex:tag+1];
    [itemSub startAnimation];
    
}

@end

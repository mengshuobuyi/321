

#import "QWBar.h"
#import "QWAnimation.h"
#import "QWCommon.h"

@interface QWBar()
 
-(void)initWithMoveImg:(UIImage *)moveImg itemImgs:(NSArray *)itemImgs;
@end

@implementation QWBar

#define PADDING_X 5

@synthesize m_moveImgView;
@synthesize delegate;
@synthesize m_lastBtn;

- (id)initWithFrame:(CGRect)frame
              bgImg:(UIImage *)bgImg
            moveImg:(UIImage *)moveImg
              
{
    return [self initWithFrame:frame bgImg:bgImg moveImg:moveImg itemImgs:nil];
}
- (id)initWithFrame:(CGRect)frame
              bgImg:(UIImage *)bgImg
            moveImg:(UIImage *)moveImg
           itemImgs:(NSArray *)itemImgs
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView * bgimgView =[[UIImageView alloc] initWithImage:bgImg];
        bgimgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:bgimgView];
        
        
        [self initWithMoveImg:moveImg itemImgs:itemImgs];
    }
    return self;
}

-(void)initWithMoveImg:(UIImage *)moveImg itemImgs:(NSArray *)itemImgs
{
    m_moveImgView=[[UIImageView alloc] initWithImage:moveImg];
    m_moveImgView.frame = CGRectMake(0, 0, moveImg.size.width, moveImg.size.height);
    
    m_moveImgView.center = CGPointMake(moveImg.size.width/2, moveImg.size.height/2);
    
    [self addSubview:m_moveImgView];
    
    
    
    if (itemImgs) {
        [self setItemsWithImgs:itemImgs];
    }
}

-(void)dealloc
{
    if (m_lastBtn) {
       
        m_lastBtn = nil;
    }
  
  
}

-(void)setItemsWithImgs:(NSArray *)imgs
{
    int count = [imgs count]/2;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    float itemsWidth = ((UIImage *)[UIImage imageNamed:[imgs objectAtIndex:0]]).size.width;
    float itemsHeight = ((UIImage *)[UIImage imageNamed:[imgs objectAtIndex:0]]).size.height;
    
    float gapX = (width - 2 * PADDING_X - count * itemsWidth) / (count +1);
    float gapY = height - itemsHeight;
    
    if (gapY < 0) {
        gapY = 0;
        itemsHeight = height;
    }
    
    for (int i =0; i<count; i++) {
        float x = PADDING_X + gapX + i*(itemsWidth+gapX);
        
        CGRect btnFrm = CGRectMake(x, gapY, itemsWidth, itemsHeight);
        
        UIButton * btn = [[UIButton alloc] initWithFrame:btnFrm];
        btn.tag = i;
        
        [btn setBackgroundImage:[UIImage imageNamed:[imgs objectAtIndex:2*i]]
                       forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[imgs objectAtIndex:2*i+1]]
                       forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            m_moveImgView.center = CGPointMake(btn.center.x, m_moveImgView.center.y);
            [QWCommon exchangeButtonBackgroundImage:btn];
            m_lastBtn =  btn  ;
        }
        
        [self addSubview:btn];
     
    }
    
    
}

-(void)btnClicked:(UIButton *)btn
{
    if (m_lastBtn.tag == btn.tag) {
        return;
    }
    [QWCommon exchangeButtonBackgroundImage:btn];
    [QWCommon exchangeButtonBackgroundImage:m_lastBtn];
 
    m_lastBtn =  btn  ;
    

    [QWAnimation SetPointMoveBasicAnimation:m_moveImgView
                                    delegate:self
                                         key:@"moveAnimation"
                                    duration:0.3
                                  startPoint:m_moveImgView.center
                                    endPoint:CGPointMake(btn.center.x, m_moveImgView.center.y)];
    
    m_moveImgView.center = CGPointMake(btn.center.x, m_moveImgView.center.y);
}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if ([delegate respondsToSelector:@selector(QWBarItemsClicked:index:)]) {
            [delegate QWBarItemsClicked:self index:m_lastBtn.tag];
        }
    }
}





@end

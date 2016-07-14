 

#import "QWInterchangeView.h"

@interface QWInterchangeView()

-(void)initDataWithImgs:(NSArray *)imgsArry highImgsArry:(NSArray *)highImgsArry;
-(void)itemsClicked:(QWInterchangeView_moveItem *)item;


@end

@implementation QWInterchangeView


@synthesize itemsRectArry;
@synthesize delegate;
@synthesize viewState;
@synthesize itemsArry;

#define ITEMS

//TODO: rectsArry: 把rect数据以string类型存储,如{{0,0},{100,100}}
//TODO: imgsArry: 
//TODO: highImgsArry: 
- (id)initWithFrame:(CGRect)frame 
          rectsArry:(NSArray *)rectsArry 
           imgsArry:(NSArray *)imgsArry 
       highImgsArry:(NSArray *)highImgsArry
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        itemsRectArry =  rectsArry  ;
        viewState = QWInterchangeViewStateNomal;
        
        [self initDataWithImgs:imgsArry highImgsArry:highImgsArry];
    }
    return self;
}

-(void)dealloc
{
    [itemsArry removeAllObjects];
 
}

-(void)initDataWithImgs:(NSArray *)imgsArry highImgsArry:(NSArray *)highImgsArry
{
    int count = [itemsRectArry count];
    
    itemsArry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count ; i++) {
        QWInterchangeView_moveItem * item = [[QWInterchangeView_moveItem alloc] initWithFrame:
                                              CGRectFromString([itemsRectArry objectAtIndex:i])];
        item.tag = i;
        item.m_interchangeTag = i;
        item.delegate = self;
        
        [item addTarget:self action:@selector(itemsClickUp:) forControlEvents:UIControlEventTouchUpInside];
        [item addTarget:self action:@selector(itemsClickDown:) forControlEvents:UIControlEventTouchDown];
        
        [item setBackgroundImage:[imgsArry objectAtIndex:i] forState:UIControlStateNormal];
        [item setBackgroundImage:[highImgsArry objectAtIndex:i] forState:UIControlStateHighlighted];
        
        [itemsArry addObject:item];
        
        [self addSubview:item];
    
    }
}

//按钮点击
-(void)itemsClickUp:(QWInterchangeView_moveItem *)item
{
    
    if (viewState == QWInterchangeViewStateNomal) {
//        //NSLog(@"itemsClicked");
        if (delegate && [delegate respondsToSelector:@selector(itemsClickUp: item:)]) {
            [delegate itemsClickUp:self item:item];
        }
    }
}

//按钮点击
-(void)itemsClickDown:(QWInterchangeView_moveItem *)item
{
    
    if (viewState == QWInterchangeViewStateNomal) {
//        //NSLog(@"itemsClickDown");
        if (delegate && [delegate respondsToSelector:@selector(itemsClickDown: item:)]) {
            [delegate itemsClickDown:self item:item];
        }
    }
}


//改变状态
-(void)changeState
{
    NSArray * subviewsArry = [self subviews];
    
    //从普通模式变成互换模式
    if (viewState == QWInterchangeViewStateNomal) {
        viewState = QWInterchangeViewStateInterchange;
        
        for (UIView * item in subviewsArry) {
            
            if ([item isKindOfClass:[QWInterchangeView_moveItem class]]) {
                QWInterchangeView_moveItem * moveItem  =(QWInterchangeView_moveItem *)item;
                moveItem.m_canItercanged = YES;
            }
        }
        return;
    }
    
    //从互换模式变成普通模式
    viewState = QWInterchangeViewStateNomal;
    
    for (UIView * item in subviewsArry) {
        
        if ([item isKindOfClass:[QWInterchangeView_moveItem class]]) {
            QWInterchangeView_moveItem * moveItem  =(QWInterchangeView_moveItem *)item;
            moveItem.m_canItercanged = NO;
        }
    }
}



#pragma mark -
#pragma mark QWInterchangeView_moveItemDelegate

-(void)moveItemMoveStart:(QWInterchangeView_moveItem *)item
{
    [self bringSubviewToFront:item];
}



-(void)moveItemMoveEnd:(QWInterchangeView_moveItem *)item
{

    CGPoint point = item.center;
    for (int i = 0 ; i < [itemsRectArry count] ; i++) {
        CGRect rect = CGRectFromString([itemsRectArry objectAtIndex:i]);
        if (CGRectContainsPoint(rect, point)) {
            float newX = CGRectGetMidX(rect);
            float newY = CGRectGetMidY(rect);
            

            
            QWInterchangeView_moveItem * otherItem = (QWInterchangeView_moveItem *)[itemsArry objectAtIndex:i];
            otherItem.center = item.m_nowCenterPoint;
            
            item.m_nowCenterPoint = CGPointMake(newX, newY);
            
            [itemsArry exchangeObjectAtIndex:otherItem.m_interchangeTag withObjectAtIndex:item.m_interchangeTag];
            
            int t_tag = otherItem.m_interchangeTag;
            otherItem.m_interchangeTag = item.m_interchangeTag;
            item.m_interchangeTag = t_tag;
            
            

        }
    }
}

#pragma mark -
@end

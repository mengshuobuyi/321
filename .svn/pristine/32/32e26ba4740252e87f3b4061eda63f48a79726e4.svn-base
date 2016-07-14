//
//  QWFilter_rainbow.m
//  QWCore
//
//  Created by QW on 12-11-23.
//
//

#import "QWFilter_rainbow.h"
#import "QWARBG.h"

@implementation QWFilter_rainbow

@synthesize m_imageData;


//必须奇数
#define Matrix_Num 3

-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize
{
    self = [super init];
    if (self) {
        m_imageData =  imageData  ;
        m_imageSize = imageSize;
    }
    return self;
}

-(void)dealloc
{
 
}

-(QWImagePoint)getSmoothPoint:(int)index
{
    int bitmapBytesPerRow = m_imageSize.width;
    int bitmapRow = m_imageSize.height;
    
    int x = index%bitmapBytesPerRow;
    int y = index/bitmapBytesPerRow;
    int matrixHalf = Matrix_Num/2;
    
    
    //点在图片边上
    //行
    if ( x > bitmapBytesPerRow - matrixHalf ||
         y > bitmapRow - matrixHalf) {
        return [QWARBG getPointFromData:m_imageData index:index imageSize:m_imageSize];
    }
    
    
    QWImagePoint point = [QWARBG getPointFromData:m_imageData
                                         pointIndex:CGPointMake(x, y)
                                          imageSize:m_imageSize];
    
    QWImagePoint point1 = [QWARBG getPointFromData:m_imageData
                                         pointIndex:CGPointMake(x+1, y)
                                          imageSize:m_imageSize];
    
    QWImagePoint point2 = [QWARBG getPointFromData:m_imageData
                                         pointIndex:CGPointMake(x, y+1)
                                          imageSize:m_imageSize];
    
    
    
    int r = 2*(int)sqrt((point.red - point1.red)*(point.red - point1.red) + (point.red - point2.red)*(point.red - point2.red));
    int g = 2*(int)sqrt((point.green - point1.green)*(point.green - point1.green) + (point.green - point2.green)*(point.green - point2.green));
    int b = 2*(int)sqrt((point.blue - point1.blue)*(point.blue - point1.blue) + (point.blue - point2.blue)*(point.blue - point2.blue));
    Byte a = point.alpha;
    
    
    
    
    
    
    QWImagePoint newPoint;
    newPoint.alpha = a;
    newPoint.red = r;
    newPoint.green = g;
    newPoint.blue = b;

    return newPoint;
}

-(NSData *)getNewImageData
{
    
    NSMutableData * newData = [[NSMutableData alloc] init];
    
    for (int i = 0 ; i<m_imageSize.width * m_imageSize.height; i++) {
        
        
        QWImagePoint point = [self getSmoothPoint:i];
        
        [newData appendBytes:&point.alpha length:sizeof(char)];
        [newData appendBytes:&point.red length:sizeof(char)];
        [newData appendBytes:&point.green length:sizeof(char)];
        [newData appendBytes:&point.blue length:sizeof(char)];
        
    }
    
    
    return  newData  ;
}


@end

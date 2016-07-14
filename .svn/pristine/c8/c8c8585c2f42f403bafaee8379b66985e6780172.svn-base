/*************************************************

 
 Description:
 
 获取图片的arbg值

 *************************************************/

#import <Foundation/Foundation.h>

typedef struct {
    unsigned char alpha;
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    
    
}QWImagePoint;

@interface QWARBG : NSObject

//TODO: 取值按照argb取
+(QWImagePoint)getPointFromData:(NSData *)imageData
                      pointIndex:(CGPoint)pointIndex
                       imageSize:(CGSize)imageSize;

//TODO: 取值按照argb取
+(QWImagePoint)getPointFromData:(NSData *)imageData
                           index:(int)index
                       imageSize:(CGSize)imageSize;

//测试用
+(void)printPoint:(QWImagePoint)point;
@end



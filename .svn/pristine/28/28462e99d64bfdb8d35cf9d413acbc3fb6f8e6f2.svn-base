/*************************************************

 
 进行锐化处理

 
 *************************************************/

#import <Foundation/Foundation.h>

//锐化
@interface QWFilter_sharpen : NSObject
{
    NSData * m_imageData;
    
    CGSize m_imageSize;
    
    float m_sharpNum;
}

@property (nonatomic , retain) NSData * m_imageData;

-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize sharpNum:(float)sharpNum;
-(NSData *)getNewImageData;
@end

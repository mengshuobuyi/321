/*************************************************
 
 Description:
 
 霓虹效果

 *************************************************/
#import <Foundation/Foundation.h>

//霓虹
@interface QWFilter_rainbow : NSObject
{
    NSData * m_imageData;
    
    CGSize m_imageSize;
}

@property (nonatomic , retain) NSData * m_imageData;

-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize;
-(NSData *)getNewImageData;
@end

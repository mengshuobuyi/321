 

#import "QWTextField.h"

@implementation QWTextField

@synthesize padding_left;
@synthesize padding_right;
@synthesize padding_top;
@synthesize padding_bottom;

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+padding_left, 
                      bounds.origin.y+padding_top,
                      bounds.size.width - padding_left - padding_right, 
                      bounds.size.height - padding_top - padding_bottom);
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+padding_left, 
                      bounds.origin.y+padding_top,
                      bounds.size.width - padding_left - padding_right, 
                      bounds.size.height - padding_top - padding_bottom);
}

@end

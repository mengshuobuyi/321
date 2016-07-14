//
//  CustomMultiLineLabel.m
//  wenYao-store
//
//  Created by PerryChen on 3/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "CustomMultiLineLabel.h"

@implementation CustomMultiLineLabel
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}
@end

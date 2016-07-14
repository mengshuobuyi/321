//
//  DFNavMenuButton.h
//  DFace
//
//  Created by kabda on 8/27/14.
//
//

#import <UIKit/UIKit.h>

@interface DFNavMenuButton : UIControl
@property (nonatomic, assign, getter = isActive) BOOL active;
@property (nonatomic, strong) NSString *title;
@end

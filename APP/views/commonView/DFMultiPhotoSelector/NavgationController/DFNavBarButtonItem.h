//
//  DFNavBarButtonItem.h
//  DFace
//
//  Created by FanYuandong on 14-4-10.
//
//

#import <UIKit/UIKit.h>

@interface DFNavBarButtonItem : UIBarButtonItem
- (id)initLeftWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)aAction;
- (id)initLeftWithImage:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction;
- (id)initLeftWithImage:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction;
- (id)initLeftWithTitle:(NSString *)aTitle image:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction;
- (id)initLeftWithTitle:(NSString *)aTitle image:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction;

- (id)initRightWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)aAction;
- (id)initRightWithImage:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction;
- (id)initRightWithImage:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction;
- (id)initRightWithTitle:(NSString *)aTitle image:(UIImage *)aImage target:(id)aTarget action:(SEL)aAction;
- (id)initRightWithTitle:(NSString *)aTitle image:(UIImage *)aImage backgroundImage:(UIImage *)aBackgroundImage target:(id)aTarget action:(SEL)aAction;

@end

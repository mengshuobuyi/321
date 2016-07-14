//
//  DFNavMenu.h
//  DFace
//
//  Created by kabda on 8/27/14.
//
//

#import <Foundation/Foundation.h>


@interface DFNavMenuItem : NSObject

@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, assign) NSInteger count;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, assign, getter = isSelected) BOOL selected;

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action;

@end

@interface DFNavMenu : NSObject

+ (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems
                onShow:(void (^)(BOOL isShow))onShow
             orDismiss:(void (^)(BOOL isDismiss))onDismiss;

+ (void) dismissMenu;
@end

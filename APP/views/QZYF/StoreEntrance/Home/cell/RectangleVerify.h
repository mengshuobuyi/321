//
//  CustomVerify.h
//  wenYao-store
//
//  Created by chenzhipeng on 5/4/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RectangleTagNoneClick = 0x00000001 << 0,
    RectangleTagZeroClick = 0x00000001 << 1,
    RectangleTagOneClick = 0x00000001 << 2,
    RectangleTagTwoClick = 0x00000001 << 3,
    RectangleTagThreeClick = 0x00000001 << 4,
    RectangleTagFourClick = 0x00000001 << 5,
    RectangleTagFiveClick = 0x00000001 << 6,
    RectangleTagSixClick = 0x00000001 << 7,
    RectangleTagSevenClick = 0x00000001 << 8,
    RectangleTagEightClick = 0x00000001 << 9,
    RectangleTagNineClick = 0x00000001 << 10,
    RectangleTagConfirmClick = 0x00000001 << 11,
    RectangleTagCancleClick = 0x00000001 << 12
}RectangleTagClicked;

@protocol RectangleVerifyDelegate <NSObject>

@optional
- (void)clickBtnIndex:(RectangleTagClicked)clickIndex;

@end

@interface RectangleVerify: UIView
@property (nonatomic, weak) id<RectangleVerifyDelegate> curDelegate;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threebutton;
@property (weak, nonatomic) IBOutlet UIButton *fourbutton;
@property (weak, nonatomic) IBOutlet UIButton *fivebutton;
@property (weak, nonatomic) IBOutlet UIButton *sixbutton;
@property (weak, nonatomic) IBOutlet UIButton *eightbutton;
@property (weak, nonatomic) IBOutlet UIButton *ninebutton;
@property (weak, nonatomic) IBOutlet UIButton *sevenbutton;
@property (weak, nonatomic) IBOutlet UIButton *zerobutton;
@property (weak, nonatomic) IBOutlet UIButton *endbutton;


@property (weak, nonatomic) IBOutlet UIView *topleft;
@property (weak, nonatomic) IBOutlet UIView *topcenter;
@property (weak, nonatomic) IBOutlet UIView *topright;
@property (weak, nonatomic) IBOutlet UIView *sencondleft;
@property (weak, nonatomic) IBOutlet UIView *sencondcenter;
@property (weak, nonatomic) IBOutlet UIView *sencondright;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endWight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endHeight;


+ (RectangleVerify *)getInstanceWithDelegate:(id<RectangleVerifyDelegate>)delegate withCurView:(UIView*)curView;
@end

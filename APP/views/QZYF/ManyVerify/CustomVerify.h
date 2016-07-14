//
//  CustomVerify.h
//  wenYao-store
//
//  Created by chenzhipeng on 5/4/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TagNoneClick = 0x00000001 << 0,
    TagZeroClick = 0x00000001 << 1,
    TagOneClick = 0x00000001 << 2,
    TagTwoClick = 0x00000001 << 3,
    TagThreeClick = 0x00000001 << 4,
    TagFourClick = 0x00000001 << 5,
    TagFiveClick = 0x00000001 << 6,
    TagSixClick = 0x00000001 << 7,
    TagSevenClick = 0x00000001 << 8,
    TagEightClick = 0x00000001 << 9,
    TagNineClick = 0x00000001 << 10,
    TagConfirmClick = 0x00000001 << 11,
    TagCancleClick = 0x00000001 << 12
}TagClicked;

@protocol CustomVerifyDelegate <NSObject>

@optional
- (void)clickBtnIndex:(TagClicked)clickIndex;

@end

@interface CustomVerify: UIView
@property (nonatomic, weak) id<CustomVerifyDelegate> curDelegate;
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


+ (CustomVerify *)getInstanceWithDelegate:(id<CustomVerifyDelegate>)delegate withCurView:(UIView*)curView;
@end

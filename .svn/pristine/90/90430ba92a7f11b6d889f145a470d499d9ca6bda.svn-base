//
//  CustomVerifyPad.h
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
    TagConfirmClick = 0x00000001 << 11
}TagClicked;

@protocol CustomVerifyPadDelegate <NSObject>

@optional
- (void)clickBtnIndex:(TagClicked)clickIndex;

@end

@interface CustomVerifyPad : UIView
@property (nonatomic, weak) id<CustomVerifyPadDelegate> curDelegate;


+ (CustomVerifyPad *)getInstanceWithDelegate:(id<CustomVerifyPadDelegate>)delegate withCurView:(UIView*)curView;
@end

//
//  CustomVerifyPad.m
//  wenYao-store
//
//  Created by chenzhipeng on 5/4/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "CustomVerifyPad.h"
@implementation CustomVerifyPad
- (IBAction)btnActionClick:(UIButton *)sender {
    if (self.curDelegate && [self.curDelegate respondsToSelector:@selector(clickBtnIndex:)]) {
        TagClicked curClick = TagNoneClick;
        switch (sender.tag) {
            case 1:
                curClick = TagOneClick;
                break;
            case 2:
                curClick = TagTwoClick;
                break;
            case 3:
                curClick = TagThreeClick;
                break;
            case 4:
                curClick = TagFourClick;
                break;
            case 5:
                curClick = TagFiveClick;
                break;
            case 6:
                curClick = TagSixClick;
                break;
            case 7:
                curClick = TagSevenClick;
                break;
            case 8:
                curClick = TagEightClick;
                break;
            case 9:
                curClick = TagNineClick;
                break;
            case 10:
                curClick = TagZeroClick;
                break;
            case 11:
                curClick = TagConfirmClick;
                break;
            default:
                break;
        }
        [self.curDelegate clickBtnIndex:curClick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CustomVerifyPad *)getInstanceWithDelegate:(id<CustomVerifyPadDelegate>)delegate withCurView:(UIView*)curView
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomVerifyPad" owner:nil options:nil];
    CustomVerifyPad *padView = [nibViews objectAtIndex:0];
    padView.frame = curView.bounds;
    padView.curDelegate = delegate;
    return padView;
}

@end

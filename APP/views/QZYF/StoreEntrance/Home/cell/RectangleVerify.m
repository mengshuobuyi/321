//
//  CustomVerify.m
//  wenYao-store
//
//  Created by chenzhipeng on 5/4/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "RectangleVerify.h"
@implementation RectangleVerify
- (IBAction)btnActionClick:(UIButton *)sender {
    if (self.curDelegate && [self.curDelegate respondsToSelector:@selector(clickBtnIndex:)]) {
        RectangleTagClicked curClick = RectangleTagNoneClick;
        switch (sender.tag) {
            case 1:
                curClick = RectangleTagOneClick;
                break;
            case 2:
                curClick = RectangleTagTwoClick;
                break;
            case 3:
                curClick = RectangleTagThreeClick;
                break;
            case 4:
                curClick = RectangleTagFourClick;
                break;
            case 5:
                curClick = RectangleTagFiveClick;
                break;
            case 6:
                curClick = RectangleTagSixClick;
                break;
            case 7:
                curClick = RectangleTagSevenClick;
                break;
            case 8:
                curClick = RectangleTagEightClick;
                break;
            case 9:
                curClick = RectangleTagNineClick;
                break;
            case 10:
                curClick = RectangleTagZeroClick;
                break;
            case 11:
                curClick = RectangleTagConfirmClick;
                break;
            case 12:
                curClick = RectangleTagCancleClick;
                break;
            default:
                break;
        }
        [self.curDelegate clickBtnIndex:curClick];
    }
}



+ (RectangleVerify *)getInstanceWithDelegate:(id<RectangleVerifyDelegate>)delegate withCurView:(UIView*)curView
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"RectangleVerify" owner:nil options:nil];
    RectangleVerify *View = [nibViews objectAtIndex:0];
    View.frame = curView.bounds;
    View.curDelegate = delegate;
    //底部的约束
//    NSArray* constrains = @[View.oneButton.constraints,View.twoButton.constraints];
    NSMutableArray* constrainsAll=[NSMutableArray arrayWithObjects:View.oneButton.constraints,View.twoButton.constraints,View.threebutton.constraints,View.fourbutton.constraints,View.fivebutton.constraints,View.sixbutton.constraints,View.sevenbutton.constraints,View.eightbutton.constraints,View.ninebutton.constraints,View.zerobutton.constraints,View.endbutton.constraints,nil];
    for (int i=0; i<constrainsAll.count; i++) {
        NSArray* constrains=constrainsAll[i];
        for (NSLayoutConstraint* constraint in constrains) {
            if(constraint.firstAttribute==NSLayoutAttributeWidth||constraint.firstAttribute==NSLayoutAttributeHeight){
                if(IS_IPHONE_6){
                    constraint.constant = constraint.constant*1.2;
                    View.endbutton.font=fontSystemBold(kFontS12);
                    View.endHeight.constant=90.0f;
                    View.endWight.constant=200.0f;
                }else if(IS_IPHONE_6P){
                    constraint.constant = constraint.constant*1.4;
                    View.endbutton.font=fontSystemBold(kFontS12);
                    View.endHeight.constant=100.0f;
                    View.endWight.constant=230.0f;
                }else if(IS_IPHONE_4_OR_LESS){
                    constraint.constant = constraint.constant*0.8;
                    View.endbutton.font=fontSystemBold(kFontS10);
                    View.endHeight.constant=60.0f;
                    View.endWight.constant=158.0f;
                    
                }
            }
        }
    }
 
    
    
    return View;
}

@end

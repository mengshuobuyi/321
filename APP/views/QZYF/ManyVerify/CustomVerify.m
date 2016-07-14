//
//  CustomVerify.m
//  wenYao-store
//
//  Created by chenzhipeng on 5/4/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "CustomVerify.h"
@implementation CustomVerify
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
            case 12:
                curClick = TagCancleClick;
                break;
            default:
                break;
        }
        [self.curDelegate clickBtnIndex:curClick];
    }
}



+ (CustomVerify *)getInstanceWithDelegate:(id<CustomVerifyDelegate>)delegate withCurView:(UIView*)curView
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomVerify" owner:nil options:nil];
    CustomVerify *View = [nibViews objectAtIndex:0];
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
                }else if(IS_IPHONE_6P){
                    constraint.constant = constraint.constant*1.4;
                }else if(IS_IPHONE_4_OR_LESS){
                    constraint.constant = constraint.constant*0.8;
                }
            }
        }
    }
 
    
    
    return View;
}

@end

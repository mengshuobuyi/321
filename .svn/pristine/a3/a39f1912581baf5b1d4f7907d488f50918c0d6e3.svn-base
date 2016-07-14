//
//  StatisticHelpCell.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "StatisticHelpCell.h"

@implementation StatisticHelpCell

- (void)setUpStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    NSDictionary *attributes = @{NSFontAttributeName:fontSystem(kFontS4),NSParagraphStyleAttributeName:paragraphStyle};
    self.content.attributedText = [[NSAttributedString alloc] initWithString:self.content.text attributes:attributes];
    
    //改变content视图
    CGSize contentSize =[GLOBALMANAGER sizeText:self.content.text font:fontSystem(kFontS4) constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    
    float singleLabelHeight = 15.5;
    int line = contentSize.height/singleLabelHeight;
    
    self.content.frame = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, contentSize.width, contentSize.height+(line-1)*3);
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
}

@end

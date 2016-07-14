//
//  PhotoAlbumListCell.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbumListCell.h"

@implementation PhotoAlbumListCell

+ (CGFloat)getCellHeight:(id)obj{
    return 78;
}

-(void)UIGlobal{
    [super UIGlobal];
    [self setSeparatorMargin:12 edge:EdgeLeft];
    
    lblTTL.textColor=RGBHex(qwColor6);
    lblNum.textColor=RGBHex(qwColor8);
    
    lblTTL.font=fontSystem(kFontS1);
    lblNum.font=fontSystem(kFontS4);
    
//    CGSize sz=[GLOBALMANAGER sizeText:lblTTL.text font:lblTTL.font];
//    
//    CGRect frm=lblNum.frame;
//    frm.origin.x=CGRectGetMinX(lblTTL.frame)+sz.width+5;
//    lblNum.frame=frm;
//    DebugLog(@"%@ frm %@",NSStringFromCGSize(sz),NSStringFromCGRect(frm));
//    [self layoutIfNeeded];
//    [self setNeedsDisplay];
}



- (void)setCellImage:(UIImage*)image title:(NSString*)title numberOfAssets:(NSInteger)numberOfAssets{
    photo.image=image;
    lblTTL.text=title;
    lblNum.text=[NSString stringWithFormat:@"(%d)",numberOfAssets];
    
    
}
@end

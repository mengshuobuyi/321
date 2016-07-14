//
//  PossibleDiseaseCell.m
//  quanzhi
//
//  Created by Meng on 14-8-13.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "PossibleDiseaseCell.h"
#import "PossibleDiseaseViewController.h"

@implementation PossibleDiseaseCell
@synthesize name=name;
@synthesize desc=desc;



- (void)awakeFromNib
{
    self.leftImageView.layer.cornerRadius = 20;
    self.leftImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight:(PossibleDisease *)data withFont:(UIFont *)fontTitle descFont:(UIFont *)fontDesc
{
    
    CGSize nameSize = [QWGLOBALMANAGER sizeText:data.name font:fontTitle limitWidth:250];
    CGSize descSize = [QWGLOBALMANAGER sizeText:data.desc font:fontDesc limitWidth:250];
    
    CGFloat rowHeight = 10 + nameSize.height + 10 + descSize.height + 10;
    
    return rowHeight;
}

- (void)setPossibleCell:(id)data row:(NSInteger)number fontSize:(UIFont *)fontSize contentSize:(UIFont *)contentSize{
    [super setCell:data];
    
    
    PossibleDisease *disease = data;
    if (number == 0) {
        self.leftImageView.backgroundColor =[UIColor colorWithRed:238/255.0 green:88/255.0 blue:71/255.0 alpha:1.0];
    }else if (number == 1) {
        self.leftImageView.backgroundColor =[UIColor colorWithRed:244/255.0 green:121/255.0 blue:59/255.0 alpha:1.0];
    }else if (number == 2) {
        self.leftImageView.backgroundColor =[UIColor colorWithRed:249/255.0 green:196/255.0 blue:38/255.0 alpha:1.0];
    }else{
        self.leftImageView.backgroundColor =[UIColor colorWithRed:206/255.0 green:212/255.0 blue:216/255.0 alpha:1];
    }
    
    NSString *numberString=(number < 9?[NSString stringWithFormat:@"0%d",(int)number+1] : [NSString stringWithFormat:@"%d",(int)number+1]);
    self.numLabel.text = numberString;
   
    CGSize offset=[GLOBALMANAGER sizeText:disease.name font:fontSize limitWidth:250];
    CGSize offsetH=[GLOBALMANAGER sizeText:disease.desc font:contentSize limitWidth:250];
    
    CGFloat rowHeight = 10 + offset.height + 10 + offsetH.height + 10;
    CGFloat label_X = 10 + self.leftImageView.frame.size.width + 10;
    
    self.leftImageView.frame = CGRectMake(10, rowHeight/2-20, 40, 40);
    self.numLabel.frame = CGRectMake(20, rowHeight/2-20+12, 20, 15);
    self.name.frame = CGRectMake(label_X, 10, offset.width, offset.height);
    self.desc.frame = CGRectMake(label_X, 10 + offset.height + 10, offsetH.width, offsetH.height);
   
    self.desc.numberOfLines = 0;
    self.name.font = fontSize;
    self.desc.font = contentSize;

}

- (void)UIGlobal{
   [super UIGlobal];
    self.selectedBackgroundView = [[UIView alloc]init];
    self.selectedBackgroundView.backgroundColor = RGBHex(qwColor10);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}


@end

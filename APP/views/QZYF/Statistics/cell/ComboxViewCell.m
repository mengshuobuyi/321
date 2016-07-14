//
//  ComboxViewCell.m
//  APP
//
//  Created by Meng on 15/3/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ComboxViewCell.h"

@implementation ComboxViewCell

- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getCellHeight:(id)data{
    return 46.0f;
}

- (void)setCellWithContent:(NSString *)content showImage:(BOOL)show
{
    if(show) {
        self.textLabel.textColor = RGBHex(qwColor1);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        imageView.image = [UIImage imageNamed:@"icon_tick"];
        self.accessoryView = imageView;
    }else{
        self.textLabel.textColor = RGBHex(qwColor6);
        self.accessoryView = nil;
    }
    self.textLabel.text = content;
}
- (void)setCellWithContent:(NSString *)content showImage:(BOOL)show withimage:(NSInteger)index
{
    if(show) {
        self.textLabel.textColor = RGBHex(qwColor1);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        imageView.image = [UIImage imageNamed:@"icon_tick"];
        self.accessoryView = imageView;
    }else{
        self.textLabel.textColor = RGBHex(qwColor6);
        self.accessoryView = nil;
    }
    NSArray *array=@[@"",@"img_label_gift",@"img_label_fold",@"img_label_forNow",@"img_label_specialOffer"];
    self.imageView.image=[UIImage imageNamed:array[index]];
    self.textLabel.text = content;
}



@end

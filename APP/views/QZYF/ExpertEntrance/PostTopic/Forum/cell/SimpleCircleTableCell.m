//
//  SimpleCircleTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/6/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SimpleCircleTableCell.h"
#import "cssex.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
@interface SimpleCircleTableCell()

@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UILabel *circleNameLabel;

@end

@implementation SimpleCircleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleImageView.image = ForumCircleImage;
    self.circleImageView.layer.masksToBounds = YES;
    self.circleImageView.layer.cornerRadius = 2;
    self.circleImageView.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    self.circleImageView.layer.borderColor = RGBHex(qwColor9).CGColor;
    QWCSS(self.circleNameLabel, 1, 6);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWCircleModel class]]) {
        QWCircleModel* model = obj;
        [self.circleImageView setImageWithURL:[NSURL URLWithString:model.teamLogo] placeholderImage:ForumCircleImage];
        self.circleNameLabel.text = model.teamName;
    }
}

@end

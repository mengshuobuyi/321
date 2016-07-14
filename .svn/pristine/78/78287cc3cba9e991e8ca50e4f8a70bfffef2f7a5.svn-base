//
//  SymptomListCell.m
//  APP
//
//  Created by qwfy0006 on 15/3/11.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SymptomListCell.h"
#import "OrderModel.h"

@implementation SymptomListCell
@synthesize name = name;

+ (CGFloat)getCellHeight:(id)data{
    return 44.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:Style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.name == nil) {
            self.name = [[QWLabel alloc] initWithFrame:CGRectMake(13, 0, 320, 44)];
            self.name.font = [UIFont systemFontOfSize:16];
            self.name.textColor = RGBHex(qwColor6);
            [self.contentView addSubview:self.name];
        }

    }
    return self;
}

- (void)UIGlobal{
    [super UIGlobal];
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    [self setSelectedBGColor:RGBHex(qwColor10)];
    
}

- (void)setCell:(id)data{
  
    [super setCell:data];
}


@end

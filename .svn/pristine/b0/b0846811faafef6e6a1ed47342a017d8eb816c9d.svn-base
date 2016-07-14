//
//  StoreCreditTableCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreCreditTableCell.h"

@interface StoreCreditTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
//@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@end

@implementation StoreCreditTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(StoreCreditModel *)obj
{
    [self.myImageView setImage:[UIImage imageNamed:obj.imageUrl]];
    self.myTitleLabel.text = obj.title;
    self.subTitleLabel.text = obj.subTitle;
    self.creditLabel.text = obj.score;
}

@end

@implementation StoreCreditModel
- (instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        switch (array.count) {
            case 4:
                self.score = array[3];
            case 3:
                self.subTitle = array[2];
                self.title = array[1];
                self.imageUrl = array[0];
                break;
            default:
                break;
        }
    }
    return self;
}
@end
//
//  HealthQASearchCountCell.m
//  wenyao-store
//
//  Created by chenzhipeng on 4/8/15.
//  Copyright (c) 2015 xiezhenghong. All rights reserved.
//

#import "HealthQASearchCountCell.h"
#import "QALibraryModel.h"
@implementation HealthQASearchCountCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCell:(id)data
{
    [super setCell:data];
    QALibraryQuestionClassifyModel *modelCount = (QALibraryQuestionClassifyModel *)data;
    NSDictionary *fontAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f]};
    NSDictionary *greenAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor1)};
    NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *strCategory = [[NSAttributedString alloc] initWithString:modelCount.classifyName attributes:fontAttr];
    NSAttributedString *strCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",modelCount.totalNum] attributes:greenAttrs];
    [strContent appendAttributedString:strCategory];
    [strContent appendAttributedString:[[NSAttributedString alloc] initWithString:@"类别下共有搜索结果 "]];
    [strContent appendAttributedString:strCount];
    [strContent appendAttributedString:[[NSAttributedString alloc] initWithString:@" 条"]];
    self.lblCountContent.attributedText = strContent;
    if (modelCount.imageUrl.length > 0) {
        [self.imgViewIcon setImageURL:modelCount.imageUrl];
    } else {
        [self.imgViewIcon setImage:[UIImage imageNamed:@"image_QAdefault"]];
    }
}
- (void)UIGlobal{
    [super UIGlobal];
    [self setSelectedBGColor:RGBHex(qwColor11)];
}
@end

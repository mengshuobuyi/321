//
//  CircleTableCell.m
//  APP
//
//  Created by Martin.Liu on 15/12/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CircleTableCell.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
@interface CircleTableCell()

@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *circleSubTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstCirclerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondCirclerImageView;
@property (strong, nonatomic) IBOutlet UILabel *careCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCountLabel;

@property (nonatomic, strong) NSMutableArray* imageNameArray;
@end

@implementation CircleTableCell

- (NSMutableArray *)imageNameArray
{
    if (!_imageNameArray) {
        _imageNameArray = [NSMutableArray array];
    }
    return _imageNameArray;
}

- (void)awakeFromNib {
    self.circleImageView.layer.masksToBounds = YES;
    self.circleImageView.layer.cornerRadius = CGRectGetHeight(self.circleImageView.frame)/2;
    self.circleTitleLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.circleTitleLabel.textColor = RGBHex(qwColor6);
    self.circleSubTitleLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.circleSubTitleLabel.textColor = RGBHex(qwColor8);
    self.careCountLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.careCountLabel.textColor = RGBHex(qwColor8);
    self.postCountLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.postCountLabel.textColor = RGBHex(qwColor8);
    
    self.careBtn.layer.masksToBounds = YES;
    self.careBtn.layer.cornerRadius = 4;
    [self p_setType:CircleTableCellType_None];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.chooseBtn.userInteractionEnabled = NO;
    self.chooseBtn.hidden = YES;
}

- (void)setCircleType:(CircleCellType)circleType
{
    _circleType = circleType;
    switch (circleType) {
        case CircleCellType_None:
            self.careBtn.hidden = YES;
            self.chooseBtn.hidden = YES;
            break;
        case CircleCellType_Normal:
            self.careBtn.hidden = NO;
            self.chooseBtn.hidden = YES;
            break;
        case CircleCellType_SelectedRadio:
            self.careBtn.hidden = YES;
            self.chooseBtn.hidden = NO;
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWCircleModel class]]) {
        QWCircleModel* circleModel = obj;
        [self.circleImageView setImageWithURL:[NSURL URLWithString:circleModel.teamLogo] placeholderImage:ForumDefaultImage];
        self.circleTitleLabel.text = circleModel.teamName;
        self.circleSubTitleLabel.text = [NSString stringWithFormat:@"圈主(%ld)", (long)circleModel.master];
        
        if (self.circleType != CircleCellType_Normal) {
            [self p_setType:CircleTableCellType_None];
        }
        else if (circleModel.flagMaster) {
            [self p_setType:CircleTableCellType_IAMCircler];
        }
        else if (circleModel.flagAttn)
        {
            [self p_setType:CircleTableCellType_CancelCare];
        }
        else
        {
            [self p_setType:CircleTableCellType_Care];
        }
        self.careCountLabel.text = [NSString stringWithFormat:@"关注 %ld", (long)circleModel.attnCount];
        self.postCountLabel.text = [NSString stringWithFormat:@"帖子 %ld", (long)circleModel.postCount];
        // pharmacist  ic_expert
        
        [self.imageNameArray removeAllObjects];
        if (circleModel.flagPhar) {
            [self.imageNameArray addObject:@"pharmacist"];
        }
        if (circleModel.flagDietitian) {
            [self.imageNameArray addObject:@"ic_expert"];
        }
        switch (MIN(2, self.imageNameArray.count)) {
            case 2:
                self.firstCirclerImageView.image = [UIImage imageNamed:self.imageNameArray[0]];
                self.secondCirclerImageView.image = [UIImage imageNamed:self.imageNameArray[1]];
                break;
            case 1:
                self.firstCirclerImageView.image = [UIImage imageNamed:self.imageNameArray[0]];
                self.secondCirclerImageView.image = nil;
                break;
            default:
                self.firstCirclerImageView.image = nil;
                self.secondCirclerImageView.image = nil;
                break;
        }
       
    }
}

- (void)p_setType:(CircleTableCellType)cellType
{
    switch (cellType) {
        case CircleTableCellType_None:
            self.careBtn.hidden = YES;
            break;
        case CircleTableCellType_Care:
            self.careBtn.hidden = NO;
            self.careBtn.enabled = YES;
            [self.careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
            self.careBtn.backgroundColor = RGBHex(qwColor1);
            [self.careBtn setTitle:@"关注" forState:UIControlStateNormal];
            break;
        case CircleTableCellType_CancelCare:
            self.careBtn.hidden = NO;
            self.careBtn.enabled = YES;
            [self.careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
            self.careBtn.backgroundColor = RGBHex(qwColor9);
            [self.careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            break;
        case CircleTableCellType_IAMCircler:
            self.careBtn.hidden = NO;
            self.careBtn.enabled = NO;
            [self.careBtn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
            self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
            self.careBtn.backgroundColor = [UIColor clearColor];
            [self.careBtn setTitle:@"我是圈主" forState:UIControlStateNormal];
            break;
    }
}

@end

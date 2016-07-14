//
//  DFNavMenuCell.m
//  DFace
//
//  Created by kabda on 8/27/14.
//
//

#import "DFNavMenuCell.h"

@interface DFNavMenuCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *checkImageView;
@end

@implementation DFNavMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
        
        _checkImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _checkImageView.image = [UIImage imageNamed:@"check"];
        _checkImageView.hidden = YES;
        [self.contentView addSubview:_checkImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGFloat imageHeight = CGRectGetHeight(bounds) - 5.0 * 2;
    CGRect imageFrame = CGRectMake(CGRectGetMinX(bounds) + 10.0, 5.0, imageHeight, imageHeight);
    self.imageView.frame = imageFrame;
    
    CGRect checkFrame = CGRectMake(CGRectGetMaxX(bounds) - 20.0 - 10.0, (CGRectGetHeight(bounds) - 13.0) / 2, 13.0, 13.0);
    self.checkImageView.frame = checkFrame;
    
    CGRect textFrame = CGRectMake(CGRectGetMaxX(imageFrame) + 10.0, CGRectGetHeight(bounds) / 2 - 24.0, CGRectGetMinX(checkFrame) - CGRectGetMaxX(imageFrame) - 10.0 * 2, 20.0);
    self.textLabel.frame = textFrame;
    
    CGRect detailFrame = CGRectMake(CGRectGetMinX(textFrame), CGRectGetHeight(bounds) / 2 + 4.0, CGRectGetWidth(textFrame), CGRectGetHeight(textFrame));
    self.detailTextLabel.frame = detailFrame;
    
    CGRect lineFrame = CGRectMake(CGRectGetMinX(imageFrame), CGRectGetMaxY(bounds) - 0.5, CGRectGetMaxX(bounds) - CGRectGetMinX(imageFrame), 0.5);
    self.lineView.frame = lineFrame;
}

- (void)setChecked:(BOOL)checked
{
    self.checkImageView.hidden = !checked;
}

@end

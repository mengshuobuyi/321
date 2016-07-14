//
//  DFSelectableIOS5Cell.m
//  DFace
//
//  Created by kabda on 8/4/14.
//
//

#import "DFSelectableIOS5Cell.h"
#import "Constant.h"
#define CELL_SIZE 75.0

@interface DFSelectableIOS5Cell () <DFSelectableSubCellDelegate>
@property (nonatomic, strong) NSMutableArray *reuseableViews;
@end

@implementation DFSelectableIOS5Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _reuseableViews = [[NSMutableArray alloc]initWithCapacity:0];
        _visiableViews = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger index = 0;
    for (DFSelectableSubCell *cell in self.visiableViews) {
        CGFloat xOffset = index * CELL_SIZE + 4.0 * (index + 1);
        CGRect rect = CGRectMake(xOffset, 4.0, CELL_SIZE, CELL_SIZE);
        cell.frame = rect;
        index++;
    }
}

- (void)clearData
{
    for (DFSelectableSubCell *cell in self.visiableViews) {
        cell.delegate = nil;
        [cell removeFromSuperview];
        [self.reuseableViews addObject:cell];
    }
    [self.visiableViews removeAllObjects];
    self.tag = -1;
}

- (void)addImage:(UIImage *)image
{
    DFSelectableSubCell *cell = [self reuseableCell];
    cell.showImageView.image = image;
    cell.delegate = self;
    [self setNeedsLayout];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex atSubIndex:(NSInteger)subIndex animated:(BOOL)animated
{
    NSInteger total = self.visiableViews.count;
    if (total == 0 || subIndex < 0 || subIndex >= total) {
        return;
    }
    DFSelectableSubCell *cell = (DFSelectableSubCell *)self.visiableViews[subIndex];
    [cell setSelectedIndex:selectedIndex animated:animated];
}

- (DFSelectableSubCell *)reuseableCell
{
    DFSelectableSubCell *retCell = nil;
    if (self.reuseableViews.count) {
        retCell = (DFSelectableSubCell *)self.reuseableViews[0];
    } else {
        retCell = [[DFSelectableSubCell alloc]initWithFrame:CGRectZero];
    }
    [self.contentView addSubview:retCell];
    [self.visiableViews addObject:retCell];
    [self.reuseableViews removeObjectIdenticalTo:retCell];
    return retCell;
}

#pragma mark - DFSelectableSubCellDelegate
- (void)selectableSubCellDidMarked:(DFSelectableSubCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectablePhotoIOS5CellDidMarked:atSubIndex:)]) {
        NSInteger subIndex = [self.visiableViews indexOfObjectIdenticalTo:cell];
        [self.delegate selectablePhotoIOS5CellDidMarked:self atSubIndex:subIndex];
    }
}

- (void)selectableSubCellDidUnMarked:(DFSelectableSubCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectablePhotoIOS5CellDidUnMarked:atSubIndex:)]) {
        NSInteger subIndex = [self.visiableViews indexOfObjectIdenticalTo:cell];
        [self.delegate selectablePhotoIOS5CellDidUnMarked:self atSubIndex:subIndex];
    }
}

- (void)selectableSubCellTappedToShowAllPhotos:(DFSelectableSubCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectablePhotoIOS5CellTappedToShowAllPhotos:atSubIndex:)]) {
        NSInteger subIndex = [self.visiableViews indexOfObjectIdenticalTo:cell];
        [self.delegate selectablePhotoIOS5CellTappedToShowAllPhotos:self atSubIndex:subIndex];
    }
}
@end

@implementation DFSelectableSubCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _needsAnimated = NO;
        
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _showImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_showImageView];
        
        _foregroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _foregroundImageView.backgroundColor = [UIColor clearColor];
//        _foregroundImageView.layer.borderColor =UIColorFromRGB(0x4fb1ef) ;
        _foregroundImageView.layer.borderWidth = 3.0;
        _foregroundImageView.hidden = YES;
        [self addSubview:_foregroundImageView];
        
        _indexLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _indexLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        _indexLabel.clipsToBounds = YES;
        _indexLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_indexLabel];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.showImageView.frame = bounds;
    self.foregroundImageView.frame = bounds;
    
    CGPoint center = CGPointMake(CGRectGetWidth(bounds) * 3 / 4, CGRectGetHeight(bounds) / 4);
    CGSize size = CGSizeMake(CGRectGetWidth(bounds) / 3 - 4.0, CGRectGetHeight(bounds) / 3 - 4.0);
    self.indexLabel.bounds = CGRectMake(0.0, 0.0, size.width, size.height);
    self.indexLabel.center = center;
    self.indexLabel.layer.cornerRadius = size.width / 2;
    self.indexLabel.layer.borderWidth = 1.0;
    self.indexLabel.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    _selectedIndex = selectedIndex;
    self.needsAnimated = animated;
    if (selectedIndex == NSNotFound) {
        self.indexLabel.text = @"";
        self.selectedMode = NO;
    } else {
        self.indexLabel.text = [NSString stringWithFormat:@"%d", (selectedIndex + 1)];
        self.selectedMode = YES;
    }
}

- (void)setSelectedMode:(BOOL)selectedMode
{
    [self.indexLabel.layer removeAnimationForKey:@"bounce"]; // CAMediaTimingFunction.removedOnCompletion = YES 移除不及时, 路手动移除;
    _selectedMode = selectedMode;
    if (_selectedMode) {
        self.foregroundImageView.hidden = NO;
        self.indexLabel.textColor = [UIColor whiteColor];
//        self.indexLabel.backgroundColor = [UIColor colorWithHexString:@"4fb1ef"];
        if (self.needsAnimated) {
            [self setUpAnimation];
            self.needsAnimated = NO;
        }
    } else {
        self.foregroundImageView.hidden = YES;
        self.indexLabel.textColor = [UIColor clearColor];
        self.indexLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }
}

- (void)setUpAnimation
{
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.0;
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation1.fromValue = @0.0;
    scaleAnimation1.toValue = @1.2;
    scaleAnimation1.duration = 0.4;
    scaleAnimation1.beginTime = 0.0;
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation2.fromValue = @1.2;
    scaleAnimation2.toValue = @0.9;
    scaleAnimation2.duration = 0.2;
    scaleAnimation2.beginTime = 0.4;
    
    CABasicAnimation *scaleAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation3.fromValue = @0.9;
    scaleAnimation3.toValue = @1.1;
    scaleAnimation3.duration = 0.2;
    scaleAnimation3.beginTime = 0.6;
    
    CABasicAnimation *scaleAnimation4 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation4.fromValue = @1.1;
    scaleAnimation4.toValue = @1.0;
    scaleAnimation4.duration = 0.2;
    scaleAnimation4.beginTime = 0.8;
    
    NSArray *animations = @[scaleAnimation1, scaleAnimation2, scaleAnimation3, scaleAnimation4];
    animationGroup.animations = animations;
    [self.indexLabel.layer addAnimation:animationGroup forKey:@"bounce"];
}

#pragma mark - TapHandler
- (void)handleSingleTap:(UITapGestureRecognizer*)singleTapGestureRecognizer
{
    CGPoint point = [singleTapGestureRecognizer locationInView:self];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (point.x >= (width / 2) && point.y <= (height / 2)) {
        if (self.selectedMode) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectableSubCellDidUnMarked:)]) {
                [self.delegate selectableSubCellDidUnMarked:self];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectableSubCellDidMarked:)]) {
                [self.delegate selectableSubCellDidMarked:self];
            }
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectableSubCellTappedToShowAllPhotos:)]) {
            [self.delegate selectableSubCellTappedToShowAllPhotos:self];
        }
    }
}

@end


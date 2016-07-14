//
//  DFDisplayerCell.m
//  DFace
//
//  Created by kabda on 7/23/14.
//
//

#import "DFDisplayerCell.h"

@interface DFDisplayerCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, assign, getter = isDoubleTap) BOOL doubleTap;
@end

@implementation DFDisplayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;

        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.clipsToBounds = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        _photoView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _photoView.clipsToBounds = YES;
        _photoView.backgroundColor = [UIColor clearColor];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_photoView];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleTap];

        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.scrollView.frame = bounds;
}

- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    if (!_photo) {
        return;
    }
    self.photoView.image = _photo;
    [self adjustFrame];
}

#pragma mark 调整frame
- (void)adjustFrame
{
	if (!self.photo) {
        return;
    }
    // 基本尺寸参数
    CGSize boundsSize = self.scrollView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    if (boundsHeight == 0 || boundsWidth == 0) {
        return;
    }
    CGSize imageSize = self.photo.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    if (imageWidth == 0 || imageHeight == 0) {
        return;
    }
    CGFloat widthScale = imageWidth / boundsWidth;
    CGFloat heightScale = imageHeight / boundsHeight;
    
    if (widthScale > heightScale) {
        if (widthScale > 1.0) {
            imageWidth /= widthScale;
            imageHeight /= widthScale;
        } else {
            
        }
    } else {
        if (heightScale > 1.0) {
            imageWidth /= heightScale;
            imageHeight /= heightScale;
        } else {
            
        }
    }
    
	// 设置伸缩比例
    self.scrollView.maximumZoomScale = 2.0;
	self.scrollView.minimumZoomScale = 1.0;
	self.scrollView.zoomScale = 1.0;
    
    CGRect imageBounds = CGRectMake(0, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(imageBounds));
    CGPoint imageCenter = CGPointMake(boundsWidth / 2, boundsHeight / 2);
    self.photoView.center = imageCenter;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.photoView.bounds = imageBounds;
    } completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.photoView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat w = scrollView.bounds.size.width;
    CGFloat h = scrollView.bounds.size.height;
    CGFloat iw = self.photoView.frame.size.width;
    CGFloat ih = self.photoView.frame.size.height;
    self.photoView.center = CGPointMake(MAX(w, iw) / 2, MAX(h, ih) / 2);
}

#pragma mark - Tap Handler
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    self.doubleTap = YES;
    CGPoint touchPoint = [tap locationInView:self.scrollView];
	if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
		[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
	} else {
		[self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    self.doubleTap = NO;
    [self performSelector:@selector(callBack) withObject:nil afterDelay:0.2];
}

- (void)callBack
{
    if (self.doubleTap) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewTapped)]) {
        [self.delegate performSelector:@selector(photoViewTapped)];
    }
}
@end

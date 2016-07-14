//
//  DFMultiPhotoSelectorView.m
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "DFMultiPhotoSelectorView.h"
#import "DFSelectablePhotoCell.h"

@implementation DFMultiPhotoSelectorView

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DFSelectablePhotoCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
        
        _selectorBar = [[DFSelectorBar alloc]initWithFrame:CGRectZero];
        [self addSubview:_selectorBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.collectionView.frame = bounds;
    self.collectionView.contentInset = UIEdgeInsetsMake(4.0, 4.0, 54.0, 4.0);
    self.selectorBar.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - 50.0, CGRectGetWidth(bounds), 50.0);
    self.selectorBar.hidden = YES;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.collectionView.dataSource = _delegate;
    self.collectionView.delegate = _delegate;
    self.selectorBar.delegate = _delegate;
}

@end

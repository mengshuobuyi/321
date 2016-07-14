//
//  MyLevelFlowLayout.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyLevelFlowLayout.h"

@implementation MyLevelFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.itemSize = CGSizeMake(APP_W/3, 200);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    int offset = proposedContentOffset.x;
    int width = APP_W/3;
    int x = offset /width;
    float offsetX = APP_W/3 *x;
    return CGPointMake(offsetX,0);
}
@end

//
//  CarePharmacistCollectionLayout.m
//  APP
//
//  Created by Martin.Liu on 15/12/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CarePharmacistCollectionLayout.h"
#import "CarePharmacistBackView.h"
@implementation CarePharmacistCollectionLayout

- (void)prepareLayout
{
    [super prepareLayout];
    [self registerClass:[CarePharmacistBackView class] forDecorationViewOfKind:@"CarePharmacistBackView"];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    
    //把Decoration View的布局加入可见区域布局。
    
    for (int y=0; y<2; y++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:3 inSection:y];
        
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:@"CarePharmacistBackView"atIndexPath:indexPath]];
        
    }
    
    for (NSInteger i=0 ; i < 2; i++) {
        
        for (NSInteger t=0; t<5; t++) {
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:t inSection:i];
            
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            
        }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    
    att.frame=CGRectMake(0, (125*indexPath.section)/2.0, 320, 125);
    
    att.zIndex=-1;
    
    
    
    return att;
}

@end

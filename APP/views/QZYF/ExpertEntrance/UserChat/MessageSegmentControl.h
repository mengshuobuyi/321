//
//  MessageSegmentControl.h
//  wenYao-store
//  自定义UISegementControl控件
//  Created by 李坚 on 16/3/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageSegmentControlDelegate;
@protocol MessageSegmentControlDatasource;

@interface MessageSegmentControl : UIView

@property (assign ,nonatomic) NSInteger selectedSegmentIndex;

@property (strong ,nonatomic) UIFont *titleFont;

@property (nonatomic,assign,setter = setDataource:) id<MessageSegmentControlDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<MessageSegmentControlDelegate> delegate;

- (void)reloadData;

- (void)segementSelectAtIndex:(NSInteger)selectedSegmentIndex;

//显示对应tag上小红点
- (void)showBadgePoint:(BOOL)enabled itemTag:(NSInteger)itemTag;

@end

#pragma mark - delegate
@protocol MessageSegmentControlDelegate <NSObject>

@optional
- (void)didCilckItemAtIndex:(MessageSegmentControl *)segmentControl atIndex:(NSInteger)index;

@end

#pragma mark - datasource
@protocol MessageSegmentControlDatasource <NSObject>

@required
- (NSInteger)numberOfItems;
- (NSString *)titleForItem:(NSInteger)index;

@optional
/**
 *  未选中状态下字体颜色
 *  @return UIColor class
 */
- (UIColor *)itemTitleNormalColor;
/**
 *  选中状态下字体颜色
 *  @return UIColor class
 */
- (UIColor *)itemTitleSelectedColor;
/**
 *  未选中状态下背景颜色
 *  @return UIColor class
 */
- (UIColor *)itemBackgroundNormalColor;
/**
 *  选中状态下背景颜色
 *  @return UIColor class
 */
- (UIColor *)itemBackgroundSelectedColor;
@end
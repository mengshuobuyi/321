//
//  CustomPopListView.h
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/18.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomPopListView;

@protocol CustomPopListViewDelegate <NSObject>

- (void)customPopListView:(CustomPopListView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath;

@end

@interface CustomPopListView : UIView

@property (assign, nonatomic) id  delegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *titleArray;

+ (CustomPopListView *)sharedManagerWithtitleList:(NSArray *)titles;

- (void)show;

- (void)hide;

@end

//
//  CirclePostListViewController.h
//  APP
//
//  Created by Martin.Liu on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CirclePostType) {
    CirclePostType_Nomal = 1,   // 看帖
    CirclePostType_Hot,         // 热门
    CirclePostType_Expert,      // 专家
};

@interface CirclePostListViewController : UITableViewController
@property (nonatomic ,strong) UINavigationController *navigationController;

@property (nonatomic, strong) NSString* circleId;
@property (nonatomic, assign) CirclePostType sortType;  //1:看帖、2:热门、3:专家

- (void)currentViewSelected:(void (^)(CGFloat height))finishLoading;
- (void)footerRereshing:(void (^)(CGFloat height))finishRefresh :(void(^)(BOOL canLoadMore))canLoadMore :(void(^)())failure;
- (void)setUpTableFrame:(CGRect)rect;
@end

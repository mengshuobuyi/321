//
//  MarketDetailViewController.h
//  quanzhi
//
//  Created by xiezhenghong on 14-7-3.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
#import "Activity.h"
//   1.从“我“进去userType=1  预览是2   2.从聊天页面进去userType=3
typedef NS_ENUM(NSInteger, USETYPE){
    USETYPE_ME=1,
    USETYPE_PE=2,
    USETYPE_XM=3
};

@interface MarketDetailViewController : QWBaseVC


@property (nonatomic, strong) NSString                  *activityId;
//previewMode为1 是预览模式
@property (nonatomic, assign) NSUInteger                previewMode;

@property (nonatomic,assign)  NSInteger              userType;

//列表页面进入详情的时候赋值
@property (nonatomic, strong) QueryActivityInfo       *infoDict;

//从聊天页面进入的时候赋值
@property (nonatomic, strong) QueryActivityInfo       *infoNewDict;

//赋值供修改使用
@property (strong,nonatomic)  QueryActivityInfo         *activiDic;

//图片的使用
@property (strong,nonatomic)  NSMutableArray         *imageArrayUrl;

@property (nonatomic, strong) IBOutlet UIScrollView     *scrollView;
@property (nonatomic, strong) IBOutlet UILabel          *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel            *lblSource;
@property (nonatomic, strong) IBOutlet UILabel          *dateLabel;
@property (weak, nonatomic) IBOutlet UIView             *lineView;
@property (strong, nonatomic) IBOutlet UIView           *setimageViews;
@property (nonatomic, strong) IBOutlet UILabel          *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthcontraint;

@end

//
//  DrugDetailViewController.h
//  wenyao
//
//  Created by Meng on 14-9-28.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"

@interface DrugDetailViewController : QWBaseVC

@property (nonatomic ,copy) NSString * proId; //药品的id
@property (nonatomic ,copy) NSString * facComeFrom;

@property (nonatomic) NSInteger useType;

@property (nonatomic ,strong) UITableView *tableViews;               //主视图
@end




@interface TopView : UIView

@property (nonatomic ,strong) NSDictionary * dataDictionary;
@property (nonatomic ,strong) UIFont * titleFont;
@property (nonatomic ,strong) UIFont * contentFont;
@property (nonatomic ,strong) UIFont * topTitleFont;
@property (nonatomic ,strong) UITextView * titleTextView;

@property (nonatomic, strong) UIImageView *ephedrineImage;
@property (nonatomic, strong) UITextView     *ephedrineTextView;

@property (nonatomic, strong) UIImageView *recipeImage;
@property (nonatomic, strong) UITextView     *recipeTextView;

@property (nonatomic ,strong) UITextView * specTextView;
@property (nonatomic ,strong) UITextView * factoryTextView;

@property (nonatomic ,strong) UIImageView * firstImageView;
@property (nonatomic ,strong) UIImageView * secondImageView;
@property (nonatomic ,strong) UITextView * firstTextView;
@property (nonatomic ,strong) UITextView * secondTextView;
@property (nonatomic ,copy) NSString * facComeFrom;

- (void)setUpView;

@end
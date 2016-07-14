//
//  MyDefineCell.h
//  wenyao-store
//
//  Created by Meng on 14-10-14.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "QWButton.h"
#import "MemberMarketModel.h"

@protocol MyDefineCellDelegate <NSObject>

- (void)selectClientMemberDelegate:(id)sender;

@end

@interface MyDefineCell :MGSwipeTableCell

@property (assign, nonatomic) id <MyDefineCellDelegate> selectDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *img_user;
@property (strong, nonatomic) IBOutlet UILabel *lbl_username;
@property (strong, nonatomic) IBOutlet UIImageView *img_logo;
@property (strong, nonatomic) IBOutlet UILabel *lbl_one;
@property (strong, nonatomic) IBOutlet UILabel *lbl_two;
@property (strong, nonatomic) IBOutlet UILabel *lbl_three;
@property (strong, nonatomic) IBOutlet UIImageView *img_lblone;
@property (strong, nonatomic) IBOutlet UIImageView *img_lbltwo;
@property (strong, nonatomic) IBOutlet UIImageView *img_lblthree;
@property (weak, nonatomic) IBOutlet UILabel *lbl_four;
@property (weak, nonatomic) IBOutlet UIImageView *img_lblfour;
@property (weak, nonatomic) IBOutlet UILabel *lbl_gender;

@property (weak, nonatomic) IBOutlet UILabel *backline;
@property (weak, nonatomic) IBOutlet QWButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clientNameTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clientSexTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewOneWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewTwoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewThreeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewFourWidth;

@property (weak, nonatomic) IBOutlet UIView *tagViewOne;
@property (weak, nonatomic) IBOutlet UIView *tagViewTwo;
@property (weak, nonatomic) IBOutlet UIView *tagViewThree;
@property (weak, nonatomic) IBOutlet UIView *tagViewFour;

@property (strong, nonatomic) NSArray *labelArray;
@property (strong, nonatomic) UIImage *resizeImage;


- (IBAction)selectClientAction:(id)sender;

- (void)configureCell:(MemberNcdDetailVo *)model;

- (void)configureCellData:(NSDictionary *)dataDic;

@end

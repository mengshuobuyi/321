//
//  InstitutionInfoViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/3/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "InstitutionInfoViewController.h"
#import "InstitutionInfoCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "RatingView.h"
#import "SVProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "Store.h"
#import "StoreModel.h"

@interface InstitutionInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;

// 商家星级显示
@property (assign, nonatomic)             float               starValue;
@property (strong, nonatomic)             NSArray             *dataSource;

@property (weak, nonatomic)   IBOutlet    UITableView         *tableView;
@property (strong, nonatomic) IBOutlet    UIView              *headerView;

// 商家header详情
@property (weak, nonatomic)   IBOutlet    UILabel             *lbl_shopName;
@property (weak, nonatomic)   IBOutlet    RatingView          *star_view;
@property (weak, nonatomic)   IBOutlet    UIImageView         *img_logo;

// 商家标签
@property (weak, nonatomic)   IBOutlet    UIView              *tag_one;
@property (weak, nonatomic)   IBOutlet    UIView              *tag_two;
@property (weak, nonatomic)   IBOutlet    UIView              *tag_three;
@property (weak, nonatomic)   IBOutlet    UIImageView         *img_tag_one;
@property (weak, nonatomic)   IBOutlet    UIImageView         *img_tag_two;
@property (weak, nonatomic)   IBOutlet    UIImageView         *img_tag_three;

@end

@implementation InstitutionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    self.view.backgroundColor = RGBHex(qwColor11);
    
    self.dataSource = @[@"机构座机",@"使用人",@"使用人手机",@"机构地址"];
    
    // 设置tableView
    self.tableView.backgroundColor = RGBHex(qwColor11);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    // 商家星级显示
    self.star_view.userInteractionEnabled = NO;
    [self.star_view setImagesDeselected:@"2_15.png" partlySelected:@"2_19.png" fullSelected:@"2_17.png" andDelegate:nil];
    
    self.img_logo.layer.masksToBounds = YES;
    self.img_logo.layer.cornerRadius = 5.0f;
    self.img_logo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageLogoClick:)];
    [self.img_logo addGestureRecognizer:tap];
    
    [self setHeadViewInfo];
    [self.tableView reloadData];
}

#pragma mark ---- 点击看大图（药店头像）----

- (void)imageLogoClick:(UITapGestureRecognizer *)sender
{
    [SJAvatarBrowser showImage:(UIImageView *)sender.view];
}

#pragma mark ---- 设置列表的header ----

-(void)setHeadViewInfo
{
    NSString *tempStr = self.groupModel.name;
    
    if ([self.groupModel.isStar isEqualToString:@"N"])
    {
        //非明星药房
        CGSize size = [QWGLOBALMANAGER sizeText:tempStr font:fontSystem(kFontS3) limitWidth:self.lbl_shopName.frame.size.width];
        self.lbl_shopName.text = tempStr;
        
        if (size.height > 39) {
            self.titleHeightConstraint.constant = 39;
        }else
        {
            self.titleHeightConstraint.constant = size.height;
        }
        
    }else if ([self.groupModel.isStar isEqualToString:@"Y"])
    {
        //明星药房
        int num = self.lbl_shopName.frame.size.width/16;
        
        if (tempStr.length == num-1) {
            
            //第一行11个字
            
            self.lbl_shopName.text = tempStr;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.lbl_shopName.frame.origin.x+self.lbl_shopName.frame.size.width-18 , self.lbl_shopName.frame.origin.y, 16, 16)];
            image.image = [UIImage imageNamed:@"img_bg_v"];
            [self.headerView addSubview:image];
            
        }else if (tempStr.length == num)
        {
            //第一行12个字
            
            self.lbl_shopName.text = tempStr;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.lbl_shopName.frame.origin.x+self.lbl_shopName.frame.size.width-2, self.lbl_shopName.frame.origin.y, 16, 16)];
            image.image = [UIImage imageNamed:@"img_bg_v"];
            [self.headerView addSubview:image];
            
        }else if (tempStr.length == num*2-1)
        {
            //第二行11个字
            
            CGSize size = [QWGLOBALMANAGER sizeText:tempStr font:fontSystem(kFontS3) limitWidth:self.lbl_shopName.frame.size.width];
            self.titleHeightConstraint.constant = size.height;
            self.lbl_shopName.text = tempStr;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.lbl_shopName.frame.origin.x+self.lbl_shopName.frame.size.width-19, self.lbl_shopName.frame.origin.y+size.height-17, 16, 16)];
            image.image = [UIImage imageNamed:@"img_bg_v"];
            [self.headerView addSubview:image];
        }else if (tempStr.length == num*2 )
        {
            //第二行12个字
            
            CGSize size = [QWGLOBALMANAGER sizeText:tempStr font:fontSystem(kFontS3) limitWidth:self.lbl_shopName.frame.size.width];
            self.titleHeightConstraint.constant = size.height;
            self.lbl_shopName.text = tempStr;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.lbl_shopName.frame.origin.x+self.lbl_shopName.frame.size.width-5, self.lbl_shopName.frame.origin.y+size.height-17, 16, 16)];
            image.image = [UIImage imageNamed:@"img_bg_v"];
            [self.headerView addSubview:image];
            
        }else if (tempStr.length > num*2)
        {
            self.titleHeightConstraint.constant = 39;
            self.lbl_shopName.text = tempStr;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.lbl_shopName.frame.origin.x+self.lbl_shopName.frame.size.width-7, self.lbl_shopName.frame.origin.y+ self.lbl_shopName.frame.size.height +6, 16, 16)];
            image.image = [UIImage imageNamed:@"img_bg_v"];
            [self.headerView addSubview:image];
        }
        
        
        else
        {
            NSDictionary* style = @{@"thumb":[UIImage imageNamed:@"img_bg_v"]};
            self.lbl_shopName.attributedText = [[NSString stringWithFormat:@"%@ <thumb> </thumb>",tempStr ]attributedStringWithStyleBook:style];
            CGSize size = [QWGLOBALMANAGER sizeText:tempStr font:fontSystem(kFontS3) limitWidth:self.lbl_shopName.frame.size.width];
            if (size.height > 39) {
                self.titleHeightConstraint.constant = 39;
            }else
            {
                self.titleHeightConstraint.constant = size.height;
            }
        }
    }

    self.tableView.tableHeaderView = self.headerView;
    
    // 商家头像
    [self.img_logo setImageWithURL:[NSURL URLWithString:self.groupModel.url] placeholderImage:[UIImage imageNamed:@"img_pharmacy"]];
    
    // 商家星级显示
    NSUInteger starValue = [self.groupModel.mshopStar floatValue];
    if(starValue < [self.groupModel.star floatValue]){
        starValue = [self.groupModel.star floatValue];
    }
    self.starValue = starValue;
    [self.star_view displayRating:(self.starValue/2)];
    
    // 标签
    // 1:24H  2:医保定点  3:免费送药
    self.tag_one.hidden = YES;
    self.tag_two.hidden = YES;
    self.tag_three.hidden = YES;
    NSArray *arr  = self.groupModel.branchTagList;
    for (int i = 0; i< arr.count; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        StoreGroupTag *tagModel = [StoreGroupTag parse:dic];
        
        NSString *tagNameStr = @"";
        if ([tagModel.tag isEqualToString:@"医保定点"]) {
            tagNameStr = @"三小标2";
        }else if ([tagModel.tag isEqualToString:@"免费送药"]){
            tagNameStr = @"三小标3";
        }else if ([tagModel.tag isEqualToString:@"24小时"]||[tagModel.tag isEqualToString:@"24H"]){
            tagNameStr = @"三小标1";
        }
        if (i == 0) {
            self.img_tag_one.image = [UIImage imageNamed:tagNameStr];
            self.tag_one.hidden = NO;
        }else if( i == 1){
            self.img_tag_two.image = [UIImage imageNamed:tagNameStr];
            self.tag_two.hidden = NO;
        }else if( i == 2){
            self.img_tag_three.image = [UIImage imageNamed:tagNameStr];
            self.tag_three.hidden = NO;
        }
    }
}

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 60;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstitutionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstitutionInfoCell"];
    cell.title.text = self.dataSource[indexPath.row];
    
    if (indexPath.row == 3) {
        cell.separatorLine.hidden = YES;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.content.text = self.groupModel.tel;
        }
            break;
        case 1:
        {
            cell.content.text = self.groupModel.contactName;
        }
            break;
        case 2:
        {
            cell.content.text = self.groupModel.phone;
        }
            break;
        case 3:
        {
            cell.content.text = [NSString stringWithFormat:@"%@%@%@%@",self.groupModel.provinceName,self.groupModel.cityName,self.groupModel.countryName,self.groupModel.address];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

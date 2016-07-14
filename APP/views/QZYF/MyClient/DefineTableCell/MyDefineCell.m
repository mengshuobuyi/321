//
//  MyDefineCell.m
//  wenyao-store
//
//  Created by Meng on 14-10-14.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MyDefineCell.h"
#import "UIImageView+WebCache.h"

@implementation MyDefineCell

- (void)awakeFromNib
{
    self.img_user.layer.masksToBounds = YES;
    self.img_user.layer.cornerRadius = 4.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
}

- (IBAction)selectClientAction:(id)sender
{
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(selectClientMemberDelegate:)]) {
        [self.selectDelegate selectClientMemberDelegate:sender];
    }
}

- (void)configureCell:(MemberNcdDetailVo *)model
{
    self.resizeImage = nil;
    self.resizeImage = [UIImage imageNamed:@"标签背景"];
    self.resizeImage = [self.resizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    
    // 姓名
    
    self.lbl_username.text = model.indexName;
    
    // 头像
    
    [self.img_user setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"个人资料_头像"]];
    self.img_user.layer.cornerRadius = 22.0f;
    self.img_user.layer.masksToBounds = YES;
    // 性别
    
    if ([model.sex isEqualToString:@"M"]) {
        self.lbl_gender.text = @"男";
        self.lbl_gender.textColor = RGBHex(qwColor5);
    }else if([model.sex isEqualToString:@"F"]){
        self.lbl_gender.text = @"女";
        self.lbl_gender.textColor = RGBHex(qwColor3);
    }else{
        self.lbl_gender.text = @"";
    }
    
    // 标签
    
    self.labelArray = [NSArray array];
    
    if (![model.tags isKindOfClass:[NSNull class]]) {
        if ([model.tags length] > 0) {
            self.labelArray =[model.tags componentsSeparatedByString:SeparateStr];
        }
    }
    
    if (IS_IPHONE_6P) {
        if (self.labelArray.count == 1)
        {
            [self configureOneTag];
            
        }else if (self.labelArray.count == 2)
        {
            [self configureTwoTag];
            
        }else if(self.labelArray.count == 3)
        {
            [self configureThreeTag];
            
        }else if(self.labelArray.count >3)
        {
            [self configureFourTag];
        }
        else if (self.labelArray.count == 0)
        {
            [self configureZeroTag];
            
        }
        
    }else
    {
        if (self.labelArray.count == 1)
        {
            [self configureOneTag];
            
        }else if (self.labelArray.count == 2)
        {
            [self configureTwoTag];
            
        }else if(self.labelArray.count >2)
        {
            [self configureThreeTag];
            
        }else if (self.labelArray.count == 0)
        {
            [self configureZeroTag];
        }
        
    }
}

- (void)configureCellData:(NSDictionary *)dataDic
{
    self.resizeImage = nil;
    self.resizeImage = [UIImage imageNamed:@"标签背景"];
    self.resizeImage = [self.resizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    
    // 姓名
    
    NSString *strname = dataDic[@"indexName"];
    self.lbl_username.text = strname;
    
    // 头像
    
    [self.img_user setImageWithURL:[NSURL URLWithString:dataDic[@"headImgUrl"]] placeholderImage:[UIImage imageNamed:@"个人资料_头像.png"]];
    self.img_user.layer.cornerRadius = 22.0f;
    self.img_user.layer.masksToBounds = YES;
    // 性别
    
    if ([dataDic[@"sex"]intValue ] == 0) {
//        self.img_logo.image = [UIImage imageNamed:@"ic_man"];
        self.lbl_gender.text = @"男";
        self.lbl_gender.textColor = RGBHex(qwColor5);
    }else if([dataDic[@"sex"]intValue ] == 1){
        self.lbl_gender.text = @"女";
        self.lbl_gender.textColor = RGBHex(qwColor3);
//        self.img_logo.image = [UIImage imageNamed:@"ic_woman"];
    }else{
        self.lbl_gender.text = @"";
//        [self.img_logo setImage:nil];
    }
    
    // 标签
    
    self.labelArray = [NSArray array];
    
    if (![dataDic[@"tags"] isKindOfClass:[NSNull class]]) {
        if ([dataDic[@"tags"] length] > 0) {
            self.labelArray =[dataDic[@"tags"] componentsSeparatedByString:SeparateStr];
        }
    }
    
    if (IS_IPHONE_6P) {
        if (self.labelArray.count == 1)
        {
            [self configureOneTag];
            
        }else if (self.labelArray.count == 2)
        {
            [self configureTwoTag];
            
        }else if(self.labelArray.count == 3)
        {
            [self configureThreeTag];
            
        }else if(self.labelArray.count >3)
        {
            [self configureFourTag];
        }
        else if (self.labelArray.count == 0)
        {
            [self configureZeroTag];
            
        }
        
    }else
    {
        if (self.labelArray.count == 1)
        {
            [self configureOneTag];
            
        }else if (self.labelArray.count == 2)
        {
            [self configureTwoTag];
            
        }else if(self.labelArray.count >2)
        {
            [self configureThreeTag];
            
        }else if (self.labelArray.count == 0)
        {
            [self configureZeroTag];
        }
        
    }
}

- (void)configureZeroTag
{
    self.tagViewOne.hidden = YES;
    self.tagViewTwo.hidden = YES;
    self.tagViewThree.hidden = YES;
    self.tagViewFour.hidden = YES;
    self.clientNameTopConstraint.constant = 28;
    self.clientSexTopConstraint.constant = 29;
}

- (void)configureOneTag
{
    self.clientNameTopConstraint.constant = 15;
    self.clientSexTopConstraint.constant = 15;
    self.tagViewOne.hidden = NO;
    self.tagViewTwo.hidden = YES;
    self.tagViewThree.hidden = YES;
    self.tagViewFour.hidden = YES;
    self.lbl_one.hidden = NO;
    self.img_lblone.hidden = NO;
    self.img_lblone.image = self.resizeImage;
    self.lbl_one.text = [self.labelArray objectAtIndex:0];
    
    self.tagViewOneWidth.constant = [self getWidthWithtext:self.lbl_one.text];
}

- (void)configureTwoTag
{
    self.clientNameTopConstraint.constant = 15;
    self.clientSexTopConstraint.constant = 15;
    self.tagViewOne.hidden = NO;
    self.lbl_one.hidden = NO;
    self.img_lblone.hidden = NO;
    self.img_lblone.image = self.resizeImage;
    self.lbl_one.text = [self.labelArray objectAtIndex:0];
    self.tagViewTwo.hidden = NO;
    self.lbl_two.hidden = NO;
    self.img_lbltwo.hidden = NO;
    self.img_lbltwo.image = self.resizeImage;
    self.lbl_two.text = [self.labelArray objectAtIndex:1];
    self.tagViewThree.hidden = YES;
    self.tagViewFour.hidden = YES;
    
    self.tagViewOneWidth.constant = [self getWidthWithtext:self.lbl_one.text];
    self.tagViewTwoWidth.constant = [self getWidthWithtext:self.lbl_two.text];
}

- (void)configureThreeTag
{
    self.clientNameTopConstraint.constant = 15;
    self.clientSexTopConstraint.constant = 15;
    self.tagViewOne.hidden = NO;
    self.lbl_one.hidden = NO;
    self.img_lblone.hidden = NO;
    self.img_lblone.image = self.resizeImage;
    self.lbl_one.text = [self.labelArray objectAtIndex:0];
    self.tagViewTwo.hidden = NO;
    self.lbl_two.hidden = NO;
    self.img_lbltwo.hidden = NO;
    self.img_lbltwo.image = self.resizeImage;
    self.lbl_two.text = [self.labelArray objectAtIndex:1];
    self.tagViewThree.hidden = NO;
    self.lbl_three.hidden = NO;
    self.lbl_three.text = [self.labelArray objectAtIndex:2];
    self.img_lblthree.hidden = NO;
    self.img_lblthree.image = self.resizeImage;
    self.tagViewFour.hidden = YES;
    
    self.tagViewOneWidth.constant = [self getWidthWithtext:self.lbl_one.text];
    self.tagViewTwoWidth.constant = [self getWidthWithtext:self.lbl_two.text];
    self.tagViewThreeWidth.constant = [self getWidthWithtext:self.lbl_three.text];
}

- (void)configureFourTag
{
    self.clientNameTopConstraint.constant = 15;
    self.clientSexTopConstraint.constant = 15;
    
    self.tagViewOne.hidden = NO;
    self.lbl_one.hidden = NO;
    self.img_lblone.hidden = NO;
    self.img_lblone.image = self.resizeImage;
    self.lbl_one.text = [self.labelArray objectAtIndex:0];
    
    self.tagViewTwo.hidden = NO;
    self.lbl_two.hidden = NO;
    self.img_lbltwo.hidden = NO;
    self.img_lbltwo.image = self.resizeImage;
    self.lbl_two.text = [self.labelArray objectAtIndex:1];
    
    self.tagViewThree.hidden = NO;
    self.lbl_three.hidden = NO;
    self.lbl_three.text = [self.labelArray objectAtIndex:2];
    self.img_lblthree.hidden = NO;
    self.img_lblthree.image = self.resizeImage;
    
    self.tagViewFour.hidden = NO;
    self.lbl_four.hidden = NO;
    self.lbl_four.text = [self.labelArray objectAtIndex:3];
    self.img_lblfour.hidden = NO;
    self.img_lblfour.image = self.resizeImage;
    
    self.tagViewOneWidth.constant = [self getWidthWithtext:self.lbl_one.text];
    self.tagViewTwoWidth.constant = [self getWidthWithtext:self.lbl_two.text];
    self.tagViewThreeWidth.constant = [self getWidthWithtext:self.lbl_three.text];
    self.tagViewFourWidth.constant = [self getWidthWithtext:self.lbl_four.text];
}

- (CGFloat)getWidthWithtext:(NSString *)text
{
    CGSize size1 =[text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(100, CGFLOAT_MAX)];
    return size1.width+17;
}


@end

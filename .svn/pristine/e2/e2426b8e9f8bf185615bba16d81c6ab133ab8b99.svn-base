//
//  CoupnCollectTableViewCell.m
//  APP
//
//  Created by caojing on 15/6/15.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CoupnTableViewCell.h"
#import "Constant.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
@implementation CoupnTableViewCell
+ (CGFloat)getCellHeight:(id)data{
    return 170;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)UIGlobal{
    [super UIGlobal];
    self.separatorLine.hidden=YES;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCell:(id)data{
    
    [super setCell:data];
    BranchPromotionModel *detail = (BranchPromotionModel*)data;
    if([detail.imgUrl isEqualToString:@""] || !detail.imgUrl){
        self.imgUrl.image = [UIImage imageNamed:@"bg-default.png"];
    }
    self.overDueImage.hidden = YES;
    if([detail.pushStatus intValue]==2){
        self.overDueImage.image=[UIImage imageNamed:@"ic_img_deleted"];
        [self showGrayImage:detail];
    }else if ([detail.status integerValue] == 3) {
        self.overDueImage.image=[UIImage imageNamed:@"ic_img_expired-2"];
        [self showGrayImage:detail];
        
    }
    
}

-(void)showGrayImage:(BranchPromotionModel*)detail{
    self.overDueImage.hidden = NO;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:detail.imgUrl];
    
    [manager downloadWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        
        if (image) {
            UIImage *grayImage = [self grayImage:image];
            self.imgUrl.image = grayImage;
        }
    }];
}


-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}


@end

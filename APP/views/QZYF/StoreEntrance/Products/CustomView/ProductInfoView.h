//
//  ProductInfoView.h
//  wenYao-store
//
//  Created by qw_imac on 16/7/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *proImg;
@property (weak, nonatomic) IBOutlet UILabel *proTitle;
@property (weak, nonatomic) IBOutlet UILabel *proDes;
-(void)setView:(id)model;
@end

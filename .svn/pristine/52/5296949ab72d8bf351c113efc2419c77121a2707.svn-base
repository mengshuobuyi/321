//
//  StoreCreditTableCell.h
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreCreditModel;
@interface StoreCreditTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
- (void)setCell:(StoreCreditModel*)obj;
@end

@interface StoreCreditModel : BaseModel
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subTitle;
@property (nonatomic, strong) NSString* score;

// 如果增加属性需要需要修改次方法
- (instancetype)initWithArray:(NSArray*)array;

@end




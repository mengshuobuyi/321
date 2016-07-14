//
//  CustomProvinceView.h
//  wenYao-store
//
//  Created by YYX on 15/8/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomProvinceViewDelegaet <NSObject>

- (void)getSelectedProvinceOrCity:(NSString *)str code:(NSString *)code type:(int)type;

@end

@interface CustomProvinceView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id <CustomProvinceViewDelegaet> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bg;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;

@property (assign, nonatomic) int type;

+ (CustomProvinceView *)sharedManagerWithDataList:(NSArray *)array type:(int)type;

-(void)show;

-(void)hidden;

@end

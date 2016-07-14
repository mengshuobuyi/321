//
//  CustomProvinceView.m
//  wenYao-store
//
//  Created by YYX on 15/8/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CustomProvinceView.h"
#import "AppDelegate.h"
#import "BranchModel.h"

@implementation CustomProvinceView

{
    UIWindow *window;
}

+ (CustomProvinceView *)sharedManagerWithDataList:(NSArray *)array type:(int)type
{
    return [[self alloc] initWithList:array type:type];
}

- (id)initWithList:(NSArray *)arr type:(int)type
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"CustomProvinceView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        self.dataList = [NSMutableArray array];
        [self.dataList addObjectsFromArray:arr];
        self.type = type;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.bgView addGestureRecognizer:tap];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

    }
    return self;
}



#pragma mark ---- 列表代理 ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"aaaaaaaaaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    ProvinceAndCityModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProvinceAndCityModel *model = self.dataList[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectedProvinceOrCity:code:type:)]) {
        [self.delegate getSelectedProvinceOrCity:model.name code:model.code type:self.type];
    }
    [self hidden];
}


- (void)dismiss
{
    [self hidden];
}

-(void)show
{
    self.bgView.alpha = 0;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    self.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
    __weak CustomProvinceView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0.3;
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H - self.bg.frame.size.height, SCREEN_W, self.bg.frame.size.height);
    }];
}

-(void)hidden
{
    __weak CustomProvinceView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end

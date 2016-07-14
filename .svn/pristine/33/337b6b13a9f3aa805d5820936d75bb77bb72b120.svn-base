//
//  BaseInfromationViewController.m
//  quanzhi
//
//  Created by Meng on 14-8-7.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "BaseInfromationViewController.h"
#import "Constant.h"
#import "Order.h"
#import "OrderModel.h"
#import "OrderMedelR.h"
#import "ZhPMethod.h"
#import "Categorys.h"
#import "JGProgressHUD.h"
#import "QWGlobalManager.h"
#import "SVProgressHUD.h"

@interface BaseInfromationViewController ()<UINavigationControllerDelegate,JGProgressHUDDelegate>
{
    UIView * topView;
    UIFont *cellTitleFont;
    UIFont *cellContentFont;
    
    NSInteger m_descFont;
    NSInteger m_titleFont;
    BOOL m_collected;
    BOOL isUp;
    UITextView* topTextView;
}

@property (nonatomic ,strong) NSMutableArray * propertiesArray;
@end

@implementation BaseInfromationViewController
@synthesize myTableView;

- (id)init{
    if (self = [super init]) {
        isUp = YES;
        m_descFont = kFontS4;
        m_titleFont = kFontS3;
        cellTitleFont = fontSystemBold(kFontS3);
        cellContentFont =fontSystem(kFontS4);
        m_collected = NO;
        topView = [[UIView alloc] init];
        topTextView = [[UITextView alloc] init];
        topTextView.scrollEnabled = NO;
        topTextView.editable = NO;
        
    }
    return self;
}




- (void)zoomClick{
    if (m_descFont == 20) {
        isUp = NO;
    }else if(m_descFont == 14){
        isUp = YES;
    }
    
    if (isUp) {
        m_descFont+=3;
        m_titleFont+=3;
    }else{
        m_descFont = 14;
        m_titleFont = 16;
    }
    cellTitleFont = [UIFont boldSystemFontOfSize:m_titleFont];
    cellContentFont = [UIFont systemFontOfSize:m_descFont];
    [myTableView reloadData];
    [self setUpTopView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    spminfoDetailR  *detaileR=[spminfoDetailR new];
    detaileR.spmCode=self.spmCode;
    [Order queryspminfoDetailProductListWithParam:detaileR Success:^(id DFUserModel) {
        spminfoDetail *detail=DFUserModel;
        self.dataSource=detail;
        NSArray *propertiesArray = detail.properties;
        for(spminfoDetailPropertiesModel *dict in propertiesArray){
            [self.propertiesArray addObject:[dict dictionaryModel]];
        }
        for (int i = 0; i < [self.propertiesArray count]; i++) {
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic addEntriesFromDictionary:self.propertiesArray[i]];
            if (!dic[@"content"] || [dic[@"content"] isEqualToString:@""]) {//如果content内容不存在 那么就删除这一项
                [self.propertiesArray removeObjectAtIndex:i];
            }else{
                [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isExpand"];
                [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isShow"];
                [self.propertiesArray replaceObjectAtIndex:i withObject:dic];
            }
        }
        [self setUpTopView];
        [self.myTableView reloadData];

    } failure:^(HttpException *e) {
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"基本信息";
    self.navigationController.delegate = self;
    self.dataSource = [spminfoDetail new];
    self.propertiesArray = [[NSMutableArray alloc] init];
    [self makeTableView];
    [self setUpTopView];
    
    
    
}

- (void)dealloc
{
    
}

- (void)makeTableView{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H-35) style:UITableViewStylePlain];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = RGBHex(qwColor11);
    [self.myTableView setSeparatorColor:RGBHex(qwColor10)];
    [self.view addSubview:self.myTableView];
}
#pragma mark - 设置UITableView顶部的topView
- (void)setUpTopView{
    UIFont * topFont = cellContentFont;
    NSString * desc = [QWGLOBALMANAGER replaceSpecialStringWith:self.dataSource.desc];
    [topTextView setFrame:CGRectMake(5, 8, APP_W - 10, getTempTextSize(desc, topFont, APP_W-20).height + 16)];
    [topView setFrame:CGRectMake(0, 0, APP_W, (desc.length > 0 ? topTextView.FH + 16 : 0))];
    topView.layer.borderWidth = 0.8f;
    topView.layer.borderColor = RGBHex(qwColor11).CGColor;//227, 227, 227
    topView.backgroundColor =RGBHex(qwColor4);//255,255,255
    topTextView.backgroundColor = [UIColor clearColor];
//    topTextView.textColor = RGBHex(qwColor6);
    topTextView.text = desc;
    topTextView.font = cellContentFont;
    [topView addSubview:topTextView];
    self.myTableView.tableHeaderView = topView;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 10)];
    sectionView.backgroundColor = RGBHex(qwColor11);
    return sectionView;
}

//cell展开的高度
- (CGFloat)calculateHeigtOffsetWithFontSize:(UIFont *)fontSize withTextSting:(NSString *)text
{
    CGSize adjustSize = getTempTextSize(text, fontSize, APP_W-20);
    //CGSize adjustSize = [text sizeWithFont:fontSize constrainedToSize:CGSizeMake(APP_W-20, 999) lineBreakMode:NSLineBreakByWordWrapping];
    

    CGFloat offset = adjustSize.height - 21.0f;
    offset = ceilf(offset);
    if(offset > 0.0)
        return offset;
    return 0.0;
}


//cell的收缩高度
- (CGFloat)calculateCollapseHeigtOffsetWithFontSize:(UIFont *)fontSize withTextSting:(NSString *)text withRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat singelHeight = fontSize.lineHeight;
    CGSize adjustSize = getTempTextSize(text, fontSize, APP_W-20);
    NSUInteger linecount = ceil(adjustSize.height /singelHeight);
    CGFloat adjustHeight = 0.0;
    if(linecount > 3) {
        adjustHeight = 3 * singelHeight;
        self.propertiesArray[indexPath.section][@"isShow"] = [NSNumber numberWithBool:YES];
    }else{
        adjustHeight = adjustSize.height;
    }
    CGFloat offset = adjustHeight - 21.f;
    if(offset > 0.0)
        return offset + 5.5;
    return 0;
}

- (void)adjustCellHeightWithView:(UIView *)target offset:(CGFloat)offset
{
    CGRect rect = target.frame;
    rect.size.height += offset;
    target.frame = rect;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString *content = [QWGLOBALMANAGER replaceSpecialStringWith:self.propertiesArray[indexPath.section][@"content"]];
    CGFloat offset = 0.0;
    NSDictionary *dict = self.propertiesArray[indexPath.section];
    if([dict[@"isExpand"] boolValue]){
        offset = [self calculateHeigtOffsetWithFontSize:cellContentFont withTextSting:content];
    }else{
        offset = [self calculateCollapseHeigtOffsetWithFontSize:cellContentFont withTextSting:content withRowAtIndexPath:indexPath];
    }
    if ([dict[@"isShow"] boolValue]) {
        return 103.0f + offset;
    }
    return 80.0f + offset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.propertiesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    SymBaseInfroCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSBundle * bundle = [NSBundle mainBundle];
        NSArray * cellViews = [bundle loadNibNamed:@"SymBaseInfroCell" owner:self options:nil];
        cell = [cellViews objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 45, APP_W - 10, 0.5)];
        line.backgroundColor = RGBHex(qwColor10);
        [cell addSubview:line];
        cell.contentTextView.textContainer.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        cell.contentTextView.scrollEnabled=NO;
    }
    cell.delegate = self;
    CGFloat offset = 0;
    
    NSDictionary *dict = self.propertiesArray[indexPath.section];
    NSString *content = [QWGLOBALMANAGER replaceSpecialStringWith:dict[@"content"]];
    
    cell.ExtendButton.titleLabel.font = fontSystem(kFontS5);
    cell.ExtendButton.titleLabel.textColor = RGBHex(qwColor7);
    if([dict[@"isExpand"] boolValue]){
        offset = [self calculateHeigtOffsetWithFontSize:cellContentFont withTextSting:content];
        [cell.ExtendButton setTitle:@"收起" forState:UIControlStateNormal];
        cell.arrowImageView.image = [UIImage imageNamed:@"UpAccessory.png"];
    }else{
        [cell.ExtendButton setTitle:@"更多" forState:UIControlStateNormal];
        cell.arrowImageView.image = [UIImage imageNamed:@"DownAccessory.png"];
        offset = [self calculateCollapseHeigtOffsetWithFontSize:cellContentFont withTextSting:content withRowAtIndexPath:indexPath];
    }
    if ([dict[@"isShow"] boolValue]) {
        cell.ExtendButton.hidden = NO;
        cell.arrowImageView.hidden = NO;
    }
    [self adjustCellHeightWithView:cell.contentTextView offset:offset];
    cell.ExtendButton.frame = CGRectMake(250, cell.contentTextView.frame.origin.y+cell.contentTextView.frame.size.height - 8, 60, 20);
    cell.arrowImageView.frame = CGRectMake(290, cell.contentTextView.frame.origin.y+cell.contentTextView.frame.size.height - 2, 15, 8);
    cell.titleTextView.font = cellTitleFont;
    cell.titleTextView.textColor = RGBHex(qwColor6);
    cell.titleTextView.text = dict[@"title"];
    cell.contentTextView.font = cellContentFont;
    cell.contentTextView.text = content;
//    cell.contentTextView.frame = CGRectMake(5, 50 - 8, APP_W - 10, cell.contentTextView.frame.size.height);
    return cell;
}

#pragma mark - cell中button点击事件
- (void)clickExpandEventWithIndexPath:(SymBaseInfroCell *)cell
{
    NSIndexPath * indexP = [self.myTableView indexPathForCell:cell];
    if (self.propertiesArray[indexP.section][@"isExpand"] == [NSNumber numberWithBool:YES]) {
        self.propertiesArray[indexP.section][@"isExpand"] = [NSNumber numberWithBool:NO];
    }else{
        self.propertiesArray[indexP.section][@"isExpand"] = [NSNumber numberWithBool:YES];
    }
    [self.myTableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidCurrentView
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

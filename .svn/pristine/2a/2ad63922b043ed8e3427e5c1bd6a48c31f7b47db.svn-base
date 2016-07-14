//
//  InternalProductSearchAddViewController.m
//  wenYao-store
//
//  Created by qw_imac on 16/7/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InternalProductSearchAddViewController.h"
#import "InternalProductSelectCell.h"
typedef NS_ENUM(NSInteger,SearchStatus) {
    SearchStatusDefault,
    SearchStatusShowResult,
    SearchStatusNoResult,
};
@interface InternalProductSearchAddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)SearchStatus status;
@property (weak, nonatomic) IBOutlet UITextField *inputTx;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *sourceDataArray;
@end
@implementation InternalProductSearchAddViewController
static NSString *const cellIdentifier = @"InternalProductSelectCell";
#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"药品名称搜索";
    [self initializeData];
}

#pragma mark - Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InternalProductSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
#warning setcell
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - PrivateMethod
-(void)initializeData {
    self.status = SearchStatusDefault;
    self.sourceDataArray = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}
//添加商品
- (IBAction)addProductAction:(UIButton *)sender {
    
}
//搜索药品
- (IBAction)searchAction:(UIButton *)sender {
    NSString *searchword = [_inputTx.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (StrIsEmpty(searchword)) {
        [SVProgressHUD showErrorWithStatus:@"搜索词不能为空" duration:0.8];
        return;
    }
    
}
#pragma mark - Setter And Getter
-(void)setStatus:(SearchStatus)status {
    _status = status;
    [self removeInfoView];
    switch (status) {
        case SearchStatusDefault:
            _tableView.hidden = YES;
            break;
        case SearchStatusShowResult:
            _tableView.hidden = NO;
            break;
        case SearchStatusNoResult:
            _tableView.hidden = YES;
            [self showInfoView:@"很抱歉，未查到此药品" image:@""];
            break;
        default:
            DebugLog(@"--------error--------! status is %ld",(long)status);
            break;
    }
}

-(void)setSourceDataArray:(NSMutableArray *)sourceDataArray {
    _sourceDataArray = sourceDataArray;
    [_tableView reloadData];
}

@end

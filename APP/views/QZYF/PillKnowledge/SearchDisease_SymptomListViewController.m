//
//  SearchDisease+SymptomListViewController.m
//  wenyao
//
//  Created by Meng on 14/12/2.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SearchDisease_SymptomListViewController.h"
#import "DiseaseDetailViewController.h"
#import "SymptomDetailViewController.h"
#import "Drug.h"

@interface SearchDisease_SymptomListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_nodataView;
    UIView *line;
}
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation SearchDisease_SymptomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    //NW_queryDiseaseKeyword
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)setKwId:(NSString *)kwId
{
    _kwId = kwId;
    DiseasekwidR *kwid=[DiseasekwidR new];
    kwid.kwId=kwId;
    kwid.currPage=[NSString stringWithFormat:@"%i",1];
    kwid.pageSize=[NSString stringWithFormat:@"%i",1000];
    DiseaseSpmbykwidR *spmkwid=[DiseaseSpmbykwidR new];
    spmkwid.kwId=kwId;
    spmkwid.currPage=[NSString stringWithFormat:@"%i",1];
    spmkwid.pageSize=[NSString stringWithFormat:@"%i",1000];
    if (self.requsetType == RequsetTypeDisease) {
        [Drug queryDiseasekwidWithParam:kwid success:^(id resultObj) {
            DiseaseSpmProductbykwid *kwids=resultObj;
            [self.dataSource removeAllObjects];
            for (Diseaseclasskwid *kwidclass in kwids.list) {
                [self.dataSource addObject:kwidclass];
            }
                if (self.dataSource.count > 0) {
                    [self.tableView reloadData];
                }else{
                    [self showNoDataViewWithString:@"暂无数据!"];
                }
                    } failure:^(HttpException *error) {
                        NSLog(@"%@",error);
                    }];
                } else if (self.requsetType == RequsetTypeSymptom){
                    [Drug querySpmkwidWithParam:spmkwid success:^(id resultObj) {
                        DiseaseSpmProductbykwid *spmkwids=resultObj;
                        
                        [self.dataSource removeAllObjects];
               for (Spmclasskwid *spmclass in spmkwids.list) {
                    [self.dataSource addObject:spmclass];
                        }
                        
                        if (self.dataSource.count > 0) {
                            [self.tableView reloadData];
                        }else{
                        [self showNoDataViewWithString:@"暂无数据!"];
                                        }
                    } failure:^(HttpException *e) {
                        [self showNoDataViewWithString:e.Edescription];
                    }];
}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //searchdiseasespm
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, APP_W,0.5)];
        line.backgroundColor =RGBHex(qwColor10);
        [cell addSubview:line];
    }
 
    if ([self.dataSource[indexPath.row] isKindOfClass:[Diseaseclasskwid class]]) {
        Diseaseclasskwid *diseasek=self.dataSource[indexPath.row];
        cell.textLabel.text=diseasek.name;
    }else if ([self.dataSource[indexPath.row] isKindOfClass:[Spmclasskwid class]]){
        Spmclasskwid *spm=self.dataSource[indexPath.row];
        cell.textLabel.text= spm.name;
    }
    cell.textLabel.font =font(kFont4, kFontS1);
    cell.textLabel.textColor =RGBHex(qwColor6);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.requsetType == RequsetTypeDisease) {
        DiseaseDetailViewController* diseaseDetail = [[DiseaseDetailViewController alloc] initWithNibName:@"DiseaseDetailViewController" bundle:nil];
        Diseaseclasskwid *classkwd=self.dataSource[indexPath.row];
        diseaseDetail.diseaseId = classkwd.diseaseId;
        diseaseDetail.diseaseType = classkwd.type;
        diseaseDetail.title = classkwd.name;
        [self.navigationController pushViewController:diseaseDetail animated:YES];
    }else if (self.requsetType == RequsetTypeSymptom){
        SymptomDetailViewController * svc =[[SymptomDetailViewController alloc]init];
        Spmclasskwid *spmclass=self.dataSource[indexPath.row];
        svc.spmCode = spmclass.spmCode;
        svc.title = spmclass.name;
         svc.containerViewController = self.containerViewController;
        if (self.containerViewController) {
            [self.containerViewController.navigationController pushViewController:svc animated:YES];
        }else
        {
            [self.navigationController pushViewController:svc animated:YES];
        }
        

    }
}

//显示没有历史搜索记录view
-(void)showNoDataViewWithString:(NSString *)nodataPrompt
{
    if (_nodataView) {
        [_nodataView removeFromSuperview];
        _nodataView = nil;
    }
    _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    //_nodataView.backgroundColor = COLOR(242, 242, 242);
    _nodataView.backgroundColor =RGBHex(qwColor4);
    
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    //    [tap addTarget:self action:@selector(keyboardHidenClick)];
    //    [_nodataView addGestureRecognizer:tap];
    UIImage * searchImage = [UIImage imageNamed:@"icon_warning.png"];
    
    UIImageView *dataEmpty = [[UIImageView alloc]initWithFrame:RECT(0, 0, searchImage.size.width, searchImage.size.height)];
    dataEmpty.center = CGPointMake(APP_W/2, 110);
    dataEmpty.image = searchImage;
    [_nodataView addSubview:dataEmpty];
    
    UILabel* lable_ = [[UILabel alloc]initWithFrame:RECT(0,dataEmpty.frame.origin.y + dataEmpty.frame.size.height + 10, nodataPrompt.length*20,30)];
    lable_.font = font(kFont4, kFontS5);
    lable_.textColor =RGBHex(qwColor8);
    lable_.textAlignment = NSTextAlignmentCenter;
    lable_.center = CGPointMake(APP_W/2, lable_.center.y);
    lable_.text = nodataPrompt;
    
    [_nodataView addSubview:lable_];
    [self.view insertSubview:_nodataView atIndex:self.view.subviews.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

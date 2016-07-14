//
//  FinderRelatedViewController.m
//  APP
//
//  Created by 李坚 on 16/1/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "FinderRelatedViewController.h"
#import "FinderSearch.h"
#import "FinderQuestionDetailViewController.h"
#import "WebDirectViewController.h"
#import "KeyWordSearchTableViewCell.h"
#import "CommonDiseaseDetailViewController.h"

#define HeadViewHeight 39.0f
static NSString *ConsultPharmacyIdentifier = @"KeyWordSearchTableViewCell";


@interface FinderRelatedViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    
    NSInteger currentPage;
    BOOL userScrolled;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *checkAllList;
@end

@implementation FinderRelatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    currentPage = 1;
    userScrolled = YES;
    self.searchBarView.backgroundColor = RGBHex(qwColor1);
    self.searchBarView.delegate = self;
    _checkAllList = [NSMutableArray array];
    [_mainTableView addStaticImageHeader];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = RGBHex(qwColor11);
    _mainTableView.tableFooterView = [[UIView alloc]init];
    [_mainTableView registerNib:[UINib nibWithNibName:ConsultPharmacyIdentifier bundle:nil] forCellReuseIdentifier:ConsultPharmacyIdentifier];
    switch (_selectedSection) {
        case 0:{//疾病
            self.searchBarView.placeholder = @"搜索疾病";
        }break;
        case 1:{//症状
            self.searchBarView.placeholder = @"搜索症状";
        }break;
        case 2:{//药品
            self.searchBarView.placeholder = @"搜索药品";
        }break;
        case 3:{//问答
            self.searchBarView.placeholder = @"搜索问答";
        }break;
        default:
            break;
    }
    if(!StrIsEmpty(_keyWord)){
        self.searchBarView.text = _keyWord;
        [self loadAllList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(userScrolled){
        [self.searchBarView resignFirstResponder];
    }
}

#pragma mark - UISearchBarViewDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(!StrIsEmpty(self.searchBarView.text)){
        currentPage = 1;
        [_mainTableView.footer setCanLoadMore:YES];
        [self loadAllList];
    }else{
        [_mainTableView removeFooter];
    }
}

#pragma mark - 点击Section请求，checkAllList生成，可上拉加载更多
- (void)loadAllList{
    
    DiscoverSearchModelR *modelR = [DiscoverSearchModelR new];
    modelR.keyword = self.searchBarView.text;
    modelR.currPage = @(currentPage);
    modelR.pageSize = @(20);
    
    switch (_selectedSection) {
        case 0:{//疾病Section
            [self loadDiseaseListData:modelR];
        }break;
        case 1:{//症状Section
            [self loadsymptomListData:modelR];
        }break;
        case 2:{//药品Section
            [self loadProductListData:modelR];
        }break;
        case 3:{//问答Section
            [self loadProblemListData:modelR];
        }break;
        default:
            break;
    }
}

#pragma mark - 疾病列表
- (void)loadDiseaseListData:(DiscoverSearchModelR *)modelR{
    
    [FinderSearch DiscoverDiseaseList:modelR success:^(DiscoveryVo *model) {
        
        [self refreshTableView:model.list];
        
    } failure:^(HttpException *e) {
        
    }];
}
#pragma mark - 症状列表
- (void)loadsymptomListData:(DiscoverSearchModelR *)modelR{
    
    [FinderSearch DiscoverSymptomList:modelR success:^(DiscoveryVo *model) {
        
        [self refreshTableView:model.list];
        
    } failure:^(HttpException *e) {
        
    }];
}
#pragma mark - 药品列表
- (void)loadProductListData:(DiscoverSearchModelR *)modelR{
    
    [FinderSearch DiscoverProductList:modelR success:^(DiscoveryVo *model) {
        
        [self refreshTableView:model.list];
        
    } failure:^(HttpException *e) {
        
    }];
}
#pragma mark - 问答列表
- (void)loadProblemListData:(DiscoverSearchModelR *)modelR{
    
    [FinderSearch DiscoverProblemList:modelR success:^(DiscoveryVo *model) {
        
        [self refreshTableView:model.list];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark - 上拉加载更多
- (void)loadMoreData{
    
    currentPage += 1;
    [self loadAllList];
}

#pragma mark - 刷新TableView逻辑
- (void)refreshTableView:(NSArray *)dataArray{
    
    if(dataArray.count > 0){
        if(_mainTableView.footer == nil){
            [_mainTableView addFooterWithTarget:self action:@selector(loadMoreData)];
        }
        if(currentPage == 1){
            [_checkAllList removeAllObjects];
        }
        [_checkAllList addObjectsFromArray:dataArray];
        [_mainTableView.footer endRefreshing];
        userScrolled = NO;
        [self performSelector:@selector(changeUserScroll) withObject:nil afterDelay:0.5];
        [_mainTableView reloadData];
        if(currentPage == 1){
            [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    }else{
        if(currentPage == 1){
            [_checkAllList removeAllObjects];
        }
        [_mainTableView reloadData];
        [_mainTableView.footer endRefreshing];
        [_mainTableView.footer setCanLoadMore:NO];
    }
}

- (void)changeUserScroll{
    
    userScrolled = YES;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HeadViewHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self setupCheckAllViewWithSection:_selectedSection];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _checkAllList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KeyWordSearchTableViewCell *cell = (KeyWordSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConsultPharmacyIdentifier];
    cell.VoucherImage.hidden = YES;
    cell.mainLabel.font = fontSystem(kFontS1);
    UIView *seperator = [[UIView alloc]initWithFrame:CGRectMake(0, 45.5, APP_W, 0.5)];
    seperator.backgroundColor = RGBHex(qwColor10);
    [cell addSubview:seperator];
    
    switch (_selectedSection) {
        case 0:{//疾病
            DiscoveryDiseaseVo *VO = _checkAllList[indexPath.row];
            cell.mainLabel.text = VO.diseaseName;
        }break;
        case 1:{//症状
            DiscoverySpmVo *VO = _checkAllList[indexPath.row];
            cell.mainLabel.text = VO.spmName;
        }break;
        case 2:{//药品
            DiscoveryProductVo *VO = _checkAllList[indexPath.row];
            cell.mainLabel.text = VO.prodName;
        }break;
        case 3:{//问答
            DiscoveryProblemVo *VO = _checkAllList[indexPath.row];
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:15.0],RGBHex(qwColor2)] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:VO.question];
            cell.mainLabel.attributedText = AttributedStr;
            for(HighlightPosition *HL in VO.highlightPositionList){
                NSRange range;
                range.location = [HL.start intValue];
                range.length = [HL.length intValue];
                if([HL.start intValue] + [HL.length intValue] >= AttributedStr.length){
                    
                }else{
                    [AttributedStr setAttributes:attributeDict range:range];
                }
            }
            cell.mainLabel.attributedText = AttributedStr;
        }break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushActionBySelectedSectionAtIndex:indexPath];
}


#pragma mark - 查看全部headView
- (UIView *)setupCheckAllViewWithSection:(NSInteger)section{
    
    UIView *HV = [[UIView alloc]init];
    HV.frame = CGRectMake(0, 0, APP_W, HeadViewHeight);
    HV.backgroundColor = RGBHex(qwColor4);
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HeadViewHeight - 0.5, APP_W, 0.5f)];
    line.backgroundColor = RGBHex(qwColor10);
    [HV addSubview:line];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 39)];
    label.textColor = RGBHex(qwColor8);
    label.font = fontSystem(13.0f);
    [HV addSubview:label];
    switch (section) {
        case 0:
            label.text = @"相关疾病";
            break;
        case 1:
            label.text = @"相关症状";
            break;
        case 2:
            label.text = @"相关药品";
            break;
        case 3:
            label.text = @"相关问答";
            break;
        default:
            break;
    }
    return HV;
}

#pragma mark - TableViewDidSelectedAction
- (void)pushActionBySelectedSectionAtIndex:(NSIndexPath *)indexPath{
    
    switch (_selectedSection) {
        case 0:{//疾病
            [self PushDiseaseDetail:_checkAllList[indexPath.row]];
        }break;
        case 1:{//症状
            [self PushSymptomDetail:_checkAllList[indexPath.row]];
        }break;
        case 2:{//药品
            [self PushProductDetail:_checkAllList[indexPath.row]];
        }break;
        case 3:{//问答
            [self PushProblemDetail:_checkAllList[indexPath.row]];
        }break;
        default:
            break;
    }
}

#pragma mark - 疾病详情
- (void)PushDiseaseDetail:(DiscoveryDiseaseVo *)obj{
    //优化A类疾病
    NSString *type = obj.diseaseType;
    if ([type isEqualToString:@"A"]) {
        CommonDiseaseDetailViewController *commonDiseaseDetail = [[CommonDiseaseDetailViewController alloc] init];
        commonDiseaseDetail.diseaseId = obj.id;
        commonDiseaseDetail.title = obj.diseaseName;
        [self.navigationController pushViewController:commonDiseaseDetail animated:YES];
    }else{
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDiseaseDetailModel *modelDisease = [[WebDiseaseDetailModel alloc] init];
        modelDisease.diseaseId = obj.id;
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelDisease = modelDisease;
        NSString *title = [NSString stringWithFormat:@"%@详情",obj.diseaseName];
        modelLocal.title = title;
        modelLocal.typeLocalWeb = WebPageToWebTypeDisease;
        [vcWebDirect setWVWithLocalModel:modelLocal];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
        
    }
    
    
}
#pragma mark - 症状详情
- (void)PushSymptomDetail:(DiscoverySpmVo *)obj{
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebSymptomDetailModel *modelDisease = [[WebSymptomDetailModel alloc] init];
    modelDisease.symptomId = obj.spmId;
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelSymptom = modelDisease;
    modelLocal.title = obj.spmName;
    modelLocal.typeLocalWeb = WebPageToWebTypeSympton;
    [vcWebDirect setWVWithLocalModel:modelLocal];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}
#pragma mark - 药品详情
- (void)PushProductDetail:(DiscoveryProductVo *)obj{
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = obj.prodId;
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
}

#pragma mark - 问答详情
- (void)PushProblemDetail:(DiscoveryProblemVo *)obj{
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebAnswerModel *modelAnswer = [[WebAnswerModel alloc] init];
    modelAnswer.title = obj.question;
    modelAnswer.content = obj.answer;
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.title = @"问答详情";
    modelLocal.modelAnswer = modelAnswer;
    modelLocal.typeTitle = WebTitleTypeWithFontOnly;
    modelLocal.typeLocalWeb = WebLocalTypeAnswerDetail;
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}
@end
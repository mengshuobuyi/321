//
//  FinderSearchViewController.m
//  APP
//
//  Created by 李坚 on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "FinderSearchViewController.h"
#import "Drug.h"
#import "Search.h"
#import "Store.h"
#import "SVProgressHUD.h"
#import "SearchDisease_SymptomListViewController.h"
#import "SearchMedicineListViewController.h"
#import "KeyWordSearchTableViewCell.h"
#import "FinderSearch.h"
#import "FinderQuestionDetailViewController.h"
#import "SearchModel.h"
#import "WebDirectViewController.h"
#import "FinderRelatedViewController.h"
#import "CommonDiseaseDetailViewController.h"

#define HeadViewHeight 39.0f
#define SepatorHeight 8.0f

typedef enum  PageNumber {
    Enum_History    = 0,//展示历史搜索记录
    Enum_Dream      = 1,//展示联想词
    Enum_FourSection= 2,//药，病，症，问答集合
}Page_Number;

static NSString *ConsultPharmacyIdentifier = @"KeyWordSearchTableViewCell";

@interface FinderSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray *historyArray;
    DiseaseHeadView *diseaseHeadView;
    MedicineHeadView *medicineHeadView;
    int currentPage;                //分页加载
    DiscoverySearchVo *discoverModel;
    NSMutableArray *dreamWordList;
    NSInteger selectedSection;
    Page_Number pageIndex;
    UIView *headerView;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *emptyDataView;

@end

@implementation FinderSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cancelButton removeTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchBarView.backgroundColor = RGBHex(qwColor1);
    
    pageIndex = Enum_History;
    dreamWordList = [NSMutableArray array];
    historyArray = [NSMutableArray array];
    self.searchBarView.delegate = self;
    currentPage = 1;
    selectedSection = -1;
    self.searchBarView.placeholder = @"搜索药/病/症/问答";
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = RGBHex(qwColor11);
    [self.mainTableView addStaticImageHeader];
    [self.mainTableView registerNib:[UINib nibWithNibName:ConsultPharmacyIdentifier bundle:nil] forCellReuseIdentifier:ConsultPharmacyIdentifier];
    [self getHistoryWord];
    if(historyArray.count == 0){
        [self showInfoView:@"暂无搜索历史" image:@""];
    }
    diseaseHeadView = [DiseaseHeadView getView];
    [diseaseHeadView.detailBtn addTarget:self action:@selector(diseaseHeadViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    medicineHeadView = [MedicineHeadView getView];
    [medicineHeadView.medicintBtn addTarget:self action:@selector(diseaseHeadViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!StrIsEmpty(_searchWord)){
        self.searchBarView.text = _searchWord;
        [self loadDataWithKeyWord:self.searchBarView.text];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    if(StrIsEmpty(_searchWord) && StrIsEmpty(self.searchBarView.text)){
        [super viewDidAppear:animated];
    }else{
        
    }
}

#pragma mark - TableHeadView点击事件
- (void)diseaseHeadViewBtnClick:(id)sender{
    //全匹配命中的内容类型：0-全匹配未命中; 1-疾病; 2-症状; 3-药
    if([discoverModel.hitContentType intValue] == 0){//未命中
        return;
    }
    if([discoverModel.hitContentType intValue] == 1){//疾病
        [self PushDiseaseDetail:discoverModel.discoveryDiseaseVo];
    }
    if([discoverModel.hitContentType intValue] == 2){//症状
        [self PushSymptomDetail:discoverModel.discoverySpmVo];
    }
    if([discoverModel.hitContentType intValue] == 3){//药品{
        [self PushProductDetail:discoverModel.discoveryProductVo];
    }
}

#pragma mark - 用户点击键盘搜索，主要用于搜索默认词汇
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *word = [QWGLOBALMANAGER replaceSymbolStringWith:searchBar.text];
    if(StrIsEmpty(word)){
        return;
    }

    [self loadDataWithKeyWord:word];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _mainTableView.tableHeaderView = nil;
    [_mainTableView removeFooter];
    [self.emptyDataView removeFromSuperview];
    if(!StrIsEmpty(self.searchBarView.text)){
        NSString *word = [QWGLOBALMANAGER replaceSymbolStringWith:searchBar.text];
        if(word.length > 0){
            //联想词接口
            pageIndex = Enum_Dream;
            [self loadDreamWordListByKeyWord:word];
        }
    }else{
        //历史数据
        pageIndex = Enum_History;
        [self getHistoryWord];
        if(historyArray.count == 0){
            [self showInfoView:@"无搜索历史" image:nil];
        }else{
            [self removeInfoView];
        }
        [_mainTableView reloadData];
    }
}

#pragma mark - 联想词汇请求dreamArray生成
- (void)loadDreamWordListByKeyWord:(NSString *)keyWord{
    
    [self removeInfoView];
    DiscoverSearchModelR *modelR = [DiscoverSearchModelR new];
    modelR.keyword = keyWord;
    [dreamWordList removeAllObjects];
    
    [FinderSearch FindDreamWord:modelR success:^(KeywordModel *model) {
        
        [dreamWordList addObjectsFromArray:model.list];
        [_mainTableView reloadData];
        
    } failure:^(HttpException *e) {
        [_mainTableView reloadData];
    }];
}

#pragma mark - 关键字搜索请求，discoverModel生成
- (void)loadDataWithKeyWord:(NSString *)keyWord
{
    pageIndex = Enum_FourSection;
    [self historyWordSave:keyWord];
    DiscoverSearchModelR *modelR = [DiscoverSearchModelR new];
    modelR.keyword = [QWGLOBALMANAGER replaceSymbolStringWith:keyWord];
    modelR.currPage = @(1);
    modelR.pageSize = @(10);

    [FinderSearch DiscoverSearch:modelR success:^(DiscoverySearchVo *model) {
        
        discoverModel = model;
        [self.searchBarView resignFirstResponder];
        if([self checkDiscoverModelEmpty]){
            return;
        }
        switch ([model.hitContentType intValue]) {
            case 0:{//全匹配未命中
                _mainTableView.tableHeaderView = nil;
            }
                break;
            case 1:{//疾病
                diseaseHeadView.diseaseName.text = model.discoveryDiseaseVo.diseaseName;
                if(StrIsEmpty(model.discoveryDiseaseVo.diseaseDesc)){
                    diseaseHeadView.diseaseDesc.text = @"";
                    CGRect rect = diseaseHeadView.frame;
                    rect.size.height = 86.0f;
                    diseaseHeadView.frame = rect;
                }else{
                    diseaseHeadView.diseaseDesc.text = [NSString stringWithFormat:@"简介：%@",model.discoveryDiseaseVo.diseaseDesc];
                    CGRect rect = diseaseHeadView.frame;
                    rect.size.height = 169.0f;
                    diseaseHeadView.frame = rect;
                }
                _mainTableView.tableHeaderView = diseaseHeadView;
            }
                break;
            case 2:{//症状
                diseaseHeadView.diseaseName.text = model.discoverySpmVo.spmName;
                if(StrIsEmpty(model.discoverySpmVo.spmDesc)){
                    diseaseHeadView.diseaseDesc.text = @"";
                    CGRect rect = diseaseHeadView.frame;
                    rect.size.height = 86.0f;
                    diseaseHeadView.frame = rect;
                }else{
                    diseaseHeadView.diseaseDesc.text = [NSString stringWithFormat:@"病因：%@",model.discoverySpmVo.spmDesc];
                    CGRect rect = diseaseHeadView.frame;
                    rect.size.height = 169.0f;
                    diseaseHeadView.frame = rect;
                }
                _mainTableView.tableHeaderView = diseaseHeadView;
            }
                break;
            case 3:{//药
                medicineHeadView.proName.text = [NSString stringWithFormat:@"药品名称：%@",model.discoveryProductVo.prodName];
                [medicineHeadView.imgUrl setImageWithURL:[NSURL URLWithString:model.discoveryProductVo.prodImg] placeholderImage:[UIImage imageNamed:@"药品默认图片"]];
                medicineHeadView.porperty.text = [NSString stringWithFormat:@"药品属性：%@",[QWGLOBALMANAGER TypeOfDrugByCode:model.discoveryProductVo.prodSignCode]];
                medicineHeadView.spec.text = [NSString stringWithFormat:@"药品规格：%@",model.discoveryProductVo.prodSpec];
                
                if(StrIsEmpty(model.discoveryProductVo.prodContent)){
                     medicineHeadView.purpose.text = @"";
                    CGRect rect = medicineHeadView.frame;
                    rect.size.height = 82.0f;
                    medicineHeadView.frame = rect;
                }else{
                    CGRect rect = medicineHeadView.frame;
//                    rect.size.height = 166.0f;
                    NSString *content = [NSString stringWithFormat:@"%@：%@",[QWGLOBALMANAGER UseOfDrugByCode:model.discoveryProductVo.prodSignCode],model.discoveryProductVo.prodContent];
                    CGSize size =[GLOBALMANAGER sizeText:content font:fontSystem(kFontS1) limitWidth:APP_W-30];
                    rect.size.height=size.height+82.0f+38.0f;
                    medicineHeadView.frame = rect;
                    content = [QWGLOBALMANAGER replaceSpecialStringWith:content];
                    medicineHeadView.purpose.text = content;
                }
                _mainTableView.tableHeaderView = medicineHeadView;
            }
                break;
        }
        [_mainTableView reloadData];
        
    } failure:^(HttpException *e) {
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
            }else{
                [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
            }

        }
    }];
    
}

- (BOOL)checkDiscoverModelEmpty{
    
    if([discoverModel.hitContentType intValue] == 0 && discoverModel.diseaseList.count == 0 && discoverModel.problemList.count == 0 && discoverModel.spmList.count == 0 && discoverModel.productList.count == 0){
        self.emptyDataView.frame = CGRectMake(0, 0, APP_W, APP_H - NAV_H);
        [self.view addSubview:self.emptyDataView];
        return YES;
    }else{
        [self removeInfoView];
        return NO;
    }
}

- (void)sectionClick:(UIButton *)btn{
    
    //跳转新页面
    FinderRelatedViewController *VC = [[FinderRelatedViewController alloc]initWithNibName:@"FinderRelatedViewController" bundle:nil];
    VC.keyWord = self.searchBarView.text;
    VC.selectedSection = btn.tag;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - TableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   [self.searchBarView resignFirstResponder];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(pageIndex == Enum_History){//搜索历史
        return 1;
    }else
    if(pageIndex == Enum_Dream){//联想词汇
        return 1;
    }else
    if(pageIndex == Enum_FourSection){//四个Section
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(pageIndex == Enum_History){//搜索历史
        if(historyArray.count > 0){
            return HeadViewHeight;
        }else{
            return 0.1f;
        }
    }else
    if(pageIndex == Enum_Dream){//联想词汇
        return 0.1f;
    }else
    if(pageIndex == Enum_FourSection){//四个Section
        if(section == 0){
            if(discoverModel.diseaseList.count > 0){
                return HeadViewHeight;
            }else{
                return 0.0f;
            }
        }
        if(section == 1){
            if(discoverModel.spmList.count > 0){
                return HeadViewHeight + SepatorHeight;
            }else{
                return 0.0f;
            }
        }
        if(section == 2){
            if(discoverModel.productList.count > 0){
                return HeadViewHeight + SepatorHeight;
            }else{
                return 0.0f;
            }
        }
        if(section == 3){
            if(discoverModel.problemList.count > 0){
                return HeadViewHeight + SepatorHeight;
            }else{
                return 0.0f;
            }
        }
    }
 
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(pageIndex == Enum_History){//搜索历史
        if(historyArray.count > 0){
            return [self setupHistoryView];
        }else{
            return nil;
        }
    }else
    if(pageIndex == Enum_Dream){//联想词汇
        return nil;
    }else
    if(pageIndex == Enum_FourSection){//四个Section
        return [self setupFourViewWithSection:section];
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return 0.1f;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(pageIndex == Enum_History){//搜索历史
        return historyArray.count;
    }else if(pageIndex == Enum_Dream){//联想词汇
        if(dreamWordList.count > 0){
            return dreamWordList.count;
        }else{
            return 1;
        }
    }else if(pageIndex == Enum_FourSection){//四个Section
        if(section == 0){
            if(discoverModel.diseaseList.count > 3){
                return 3;
            }else{
                return discoverModel.diseaseList.count;
            }
        }
        if(section == 1){
            if(discoverModel.spmList.count > 3){
                return 3;
            }else{
                return discoverModel.spmList.count;
            }
        }
        if(section == 2){
            if(discoverModel.productList.count > 3){
                return 3;
            }else{
                return discoverModel.productList.count;
            }
        }
        if(section == 3){
            if(discoverModel.problemList.count > 3){
                return 3;
            }else{
                return discoverModel.problemList.count;
            }
        }

    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KeyWordSearchTableViewCell *cell = (KeyWordSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConsultPharmacyIdentifier];
    cell.VoucherImage.hidden = YES;
    cell.mainLabel.font = fontSystem(kFontS1);
    UIView *seperator = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, APP_W, 0.5)];
    seperator.backgroundColor = RGBHex(qwColor10);
    [cell addSubview:seperator];
    
    if(pageIndex == Enum_History){//搜索历史
        NSString *str = historyArray[historyArray.count - 1 - indexPath.row];
        if(str.length > 20){
            cell.mainLabel.text = [NSString stringWithFormat:@"%@...",[str substringToIndex:20]];
        }else{
            cell.mainLabel.text = historyArray[historyArray.count - 1 - indexPath.row];
        }
    }else if(pageIndex == Enum_Dream){//联想词汇
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:15.0],RGBHex(qwColor1)] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]];
        if(dreamWordList.count > 0){
            HighlightAssociateVO *dreamWord = dreamWordList[indexPath.row];
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:dreamWord.content];
            for(HighlightPosition *HL in dreamWord.highlightPositionList){
                if([HL.start intValue] + [HL.length intValue] > AttributedStr.length){
                    continue;
                }
                NSRange range;
                range.location = [HL.start intValue];
                range.length = [HL.length intValue];
                [AttributedStr setAttributes:attributeDict range:range];
            }
            if(AttributedStr.length > 20){
                [AttributedStr replaceCharactersInRange:NSMakeRange(20, AttributedStr.length - 20) withString:@"..."];
                cell.mainLabel.attributedText = AttributedStr;
            }else{
                cell.mainLabel.attributedText = AttributedStr;
            }
        }else{
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"搜：%@",self.searchBarView.text]];
            NSRange range;
            range.location = 2;
            range.length = self.searchBarView.text.length;
            [AttributedStr setAttributes:attributeDict range:range];
            if(AttributedStr.length > 22){
                [AttributedStr replaceCharactersInRange:NSMakeRange(22, AttributedStr.length - 22) withString:@"..."];
                cell.mainLabel.attributedText = AttributedStr;
            }else{
                cell.mainLabel.attributedText = AttributedStr;
            }
        }
    }else if(pageIndex == Enum_FourSection){//四个Section
        
        if(indexPath.section == 0){
            DiscoveryDiseaseVo *VO = discoverModel.diseaseList[indexPath.row];
            cell.mainLabel.text = VO.diseaseName;
        }
        if(indexPath.section == 1){
            DiscoverySpmVo *VO = discoverModel.spmList[indexPath.row];
            cell.mainLabel.text = VO.spmName;
        }
        if(indexPath.section == 2){
            DiscoveryProductVo *VO = discoverModel.productList[indexPath.row];
            cell.mainLabel.text = VO.prodName;
        }
        if(indexPath.section == 3){
            DiscoveryProblemVo *VO = discoverModel.problemList[indexPath.row];
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:15.0],RGBHex(qwColor2)] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:VO.question];
            cell.mainLabel.attributedText = AttributedStr;
            for(HighlightPosition *HL in VO.highlightPositionList){
                if([HL.start intValue] + [HL.length intValue] >= AttributedStr.length){
                    continue;
                }
                NSRange range;
                range.location = [HL.start intValue];
                range.length = [HL.length intValue];
                [AttributedStr setAttributes:attributeDict range:range];
            }
            cell.mainLabel.attributedText = AttributedStr;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBarView resignFirstResponder];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:kWaring12];
        return;
    }
    if(pageIndex == Enum_History){//搜索历史
              self.searchBarView.text = historyArray[historyArray.count - 1 - indexPath.row];
        [self loadDataWithKeyWord:historyArray[historyArray.count - 1 - indexPath.row]];
    }else if(pageIndex == Enum_Dream){//联想词汇
        if(dreamWordList.count > 0){
            HighlightAssociateVO *dreamWord = dreamWordList[indexPath.row];
                        self.searchBarView.text = dreamWord.content;
            [self loadDataWithKeyWord:dreamWord.content];
        }else{
            [self loadDataWithKeyWord:self.searchBarView.text];
        }
    }else if(pageIndex == Enum_FourSection){//四个Section
        
        [self FourSectionDisSelectedAtIndex:indexPath];
    }
}



- (void)FourSectionDisSelectedAtIndex:(NSIndexPath *)indexPath{
    
    NSString *str;
    switch (indexPath.section) {
        case 0:{//疾病
            str = @"相关疾病";
            [self PushDiseaseDetail:discoverModel.diseaseList[indexPath.row]];
        }break;
        case 1:{//症状
            str = @"相关症状";
            [self PushSymptomDetail:discoverModel.spmList[indexPath.row]];
        }break;
        case 2:{//药品
            str = @"相关药品";
            [self PushProductDetail:discoverModel.productList[indexPath.row]];
        }break;
        case 3:{//问答
            str = @"相关问答";
            [self PushProblemDetail:discoverModel.problemList[indexPath.row]];
        }break;
        default:
            break;
    }
   }

- (void)cancelAction:(id)sender{
    
    if(pageIndex == Enum_History){//搜索历史
        [self.navigationController popViewControllerAnimated:YES];
    }else if(pageIndex == Enum_Dream){//联想词汇
        [self.navigationController popViewControllerAnimated:YES];
    }else if(pageIndex == Enum_FourSection){//四个Section
        _mainTableView.tableHeaderView = nil;
        pageIndex = Enum_History;
        self.searchBarView.text = @"";
        [self getHistoryWord];
        [self.searchBarView becomeFirstResponder];
        [_mainTableView removeFooter];
        if(historyArray.count == 0){
            [self showInfoView:@"无搜索历史" image:nil];
        }else{
            [self removeInfoView];
        }
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
        modelLocal.typeTitle = WebTitleTypeWithFontOnly;
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
    modelLocal.title = @"详情";
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
    
    
    
//    FinderQuestionDetailViewController *VC = [[FinderQuestionDetailViewController alloc]initWithNibName:@"FinderQuestionDetailViewController" bundle:nil];
//    VC.model = obj;
//    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - 搜索历史headView
- (UIView *)setupHistoryView{
    if(headerView == nil){
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 39.0f)];
        headerView.backgroundColor = RGBHex(qwColor4);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 39.0f)];
        label.font = fontSystem(kFontS4);
        label.textColor = RGBHex(qwColor8);
        label.text = @"搜索历史";
        [headerView addSubview:label];
        
        UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_W - 64.5f, 0, 50, 39.0f)];
        [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [clearBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        clearBtn.titleLabel.font = fontSystem(kFontS4);
        clearBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [clearBtn addTarget:self action:@selector(cleanHistoryWord) forControlEvents:UIControlEventTouchDown];
        [headerView addSubview:clearBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 38.5, APP_W, 0.5)];
        line.backgroundColor = RGBHex(qwColor11);
        [headerView addSubview:line];
    }
    return headerView;
}

#pragma mark - 药病症问答headView
- (UIView *)setupFourViewWithSection:(NSInteger)section{
    
    UIView *HV = [[UIView alloc]init];
    if(section != 0){
        HV.frame = CGRectMake(0, 0, APP_W, HeadViewHeight + SepatorHeight);
    }else{
        HV.frame = CGRectMake(0, 0, APP_W, HeadViewHeight);
    }
    HV.backgroundColor = RGBHex(qwColor11);
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    if(section != 0){
        headView.frame = CGRectMake(0, SepatorHeight, APP_W, HeadViewHeight);
    }else{
        headView.frame = CGRectMake(0, 0, APP_W, HeadViewHeight);
    }
    
    UIImageView *Vimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9.5f, 20, 20)];
    [headView addSubview:Vimage];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 200, 39)];
    label.textColor = RGBHex(qwColor8);
    label.font = fontSystem(13.0f);
    
    UILabel *AllLabel = [[UILabel alloc]initWithFrame:CGRectMake(APP_W - 107, 0, 70, HeadViewHeight)];
    AllLabel.textColor = RGBHex(qwColor8);
    AllLabel.font = fontSystem(13.0f);
    AllLabel.text = @"查看全部";
    AllLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:AllLabel];
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(APP_W - 30, 12, 15, 15)];
    arrowImage.image = [UIImage imageNamed:@"ic_btn_arrow_right"];
    [headView addSubview:arrowImage];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5, APP_W, 0.5f)];
    line.backgroundColor = RGBHex(qwColor10);
    [headView addSubview:line];
    
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:label];
    [HV addSubview:headView];
    
    UIButton *sectionBtn = [[UIButton alloc]init];
    if(section != 0){
        sectionBtn.frame = CGRectMake(0, 0, APP_W, HeadViewHeight);
    }else{
        sectionBtn.frame = CGRectMake(0, SepatorHeight, APP_W, HeadViewHeight);
    }
    sectionBtn.tag = section;
    [sectionBtn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [HV addSubview:sectionBtn];
    
    if(section == 0){
        if(discoverModel.diseaseList.count > 0){
            Vimage.image = [UIImage imageNamed:@"ic_one"];
            label.text = [NSString stringWithFormat:@"相关疾病（%@）",discoverModel.diseaseCount];
            if([discoverModel.diseaseCount intValue] <= 3){
                AllLabel.hidden = YES;
                arrowImage.hidden = YES;
                sectionBtn.enabled = NO;
            }else{
                AllLabel.hidden = NO;
                arrowImage.hidden = NO;
                sectionBtn.enabled = YES;
            }
            return HV;
        }else{
            return nil;
        }
    }
    if(section == 1){
        if(discoverModel.spmList.count > 0){
            Vimage.image = [UIImage imageNamed:@"ic_two"];
            label.text = [NSString stringWithFormat:@"相关症状（%@）",discoverModel.spmCount];
            if([discoverModel.spmCount intValue] <= 3){
                AllLabel.hidden = YES;
                arrowImage.hidden = YES;
                sectionBtn.enabled = NO;
            }else{
                AllLabel.hidden = NO;
                arrowImage.hidden = NO;
                sectionBtn.enabled = YES;
            }
            return HV;
        }else{
            return nil;
        }
    }
    if(section == 2){
        if(discoverModel.productList.count > 0){
            Vimage.image = [UIImage imageNamed:@"ic_three"];
            label.text = [NSString stringWithFormat:@"相关药品（%@）",discoverModel.productCount];
            if([discoverModel.productCount intValue] <= 3){
                AllLabel.hidden = YES;
                arrowImage.hidden = YES;
                sectionBtn.enabled = NO;
            }else{
                AllLabel.hidden = NO;
                arrowImage.hidden = NO;
                sectionBtn.enabled = YES;
            }
            return HV;
        }else{
            return nil;
        }
    }
    if(section == 3){
        if(discoverModel.problemList.count > 0){
            Vimage.image = [UIImage imageNamed:@"ic_four"];
            label.text = [NSString stringWithFormat:@"相关问答（%@）",discoverModel.problemCount];
            if([discoverModel.problemCount intValue] <= 3){
                AllLabel.hidden = YES;
                arrowImage.hidden = YES;
                sectionBtn.enabled = NO;
            }else{
                AllLabel.hidden = NO;
                arrowImage.hidden = NO;
                sectionBtn.enabled = YES;
            }
            return HV;
        }else{
            return nil;
        }
    }
    
    return nil;
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
    switch (selectedSection) {
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

#pragma mark - 获取缓存
- (void)getHistoryWord{
    
    historyArray = [[NSMutableArray alloc] initWithArray:getHistoryConfig(@"FinderSearchHistory")];
    [_mainTableView reloadData];
}

#pragma mark - 清除缓存
- (void)cleanHistoryWord{
    
    [historyArray removeAllObjects];
    setHistoryConfig(@"FinderSearchHistory", nil);
    [SearchHistoryVo deleteAllObjFromDB];
    [_mainTableView reloadData];
    [self showInfoView:@"暂无搜索历史" image:@""];
}


#pragma mark - 存储历史搜索信息
- (void)historyWordSave:(NSString *)keyWord{
    
    BOOL existInHistory = NO;
    for(NSString *wo in historyArray){
        if([keyWord isEqualToString:wo]){
            existInHistory = YES;
            break;
        }
    }
    
    if(existInHistory == NO){
        [historyArray addObject:keyWord];
        if(historyArray.count > 10){
            [historyArray removeObjectAtIndex:0];
        }
        setHistoryConfig(@"FinderSearchHistory", historyArray);
    }
}






@end

@implementation DiseaseHeadView

+ (DiseaseHeadView *)getView{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *xibArray = [bundle loadNibNamed:@"FinderSearchViewController" owner:nil options:nil];
    for(UIView *view in xibArray){
        if([view isKindOfClass:[DiseaseHeadView class]]){
            return (DiseaseHeadView *)view;
        }
    }
    return nil;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.line1Layout.constant = 0.5f;
    self.line2Layout.constant = 0.5f;
}

@end

@implementation MedicineHeadView
+ (MedicineHeadView *)getView{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *xibArray = [bundle loadNibNamed:@"FinderSearchViewController" owner:nil options:nil];
    for(UIView *view in xibArray){
        if([view isKindOfClass:[MedicineHeadView class]]){
            view.clipsToBounds = YES;
            return (MedicineHeadView *)view;
        }
    }
    return nil;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    self.line1Layout.constant = 0.5f;
}
@end


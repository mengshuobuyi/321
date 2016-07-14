//
//  MedicineListViewController.m
//  quanzhi
//
//  Created by ZhongYun on 14-6-20.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "DiseaseMedicineListViewController.h"
#import "UIImageView+WebCache.h"
#import "DrugDetailViewController.h"
#import "Categorys.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"
#import "AFNetworking.h"
#import "ZhPMethod.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "WebDirectViewController.h"
@interface DiseaseMedicineListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    NSInteger m_currPage;
    
    BOOL bisSells;
    
}
@end

@implementation DiseaseMedicineListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        if (iOSv7 && self.view.frame.origin.y==0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        
        
        m_data = [[NSMutableArray alloc] init];
        m_currPage = 1;
        bisSells = NO;
        
        m_table = [[UITableView alloc] initWithFrame:RECT(0, 0, APP_W, APP_H-NAV_H)
                                               style:UITableViewStylePlain];
        m_table.backgroundColor = [UIColor clearColor];
        m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
        m_table.bounces = YES;
        m_table.rowHeight = 90;
        m_table.delegate = self;
        m_table.dataSource = self;
        [self.view addSubview:m_table];
        
        [m_table addFooterWithTarget:self action:@selector(footerRereshing)];
        m_table.footerPullToRefreshText = kWaring6;
        m_table.footerReleaseToRefreshText = kWaring7;
        m_table.footerRefreshingText = kWaring9;
        m_table.footerNoDataText = kWaring55;
        
        
    }
    return self;
}

- (void)footerRereshing
{
    HttpClientMgr.progressEnabled=NO;
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}


- (void)setParams:(NSDictionary *)params
{
    _params = params;
    [self loadData];
}

- (void)loadData
{
    bisSells = NO;

    if (self.params[@"formulaId"]) {

        DiseaseFormulaPruductR *formula=[DiseaseFormulaPruductR new];
        formula.diseaseId=self.params[@"diseaseId"];
        formula.formulaId=self.params[@"formulaId"];
        formula.currPage=StrFromInt((int)m_currPage);//@(m_currPage);
        formula.pageSize=StrFromInt(PAGE_ROW_NUM);//
        [Order queryDiseaseFormulaProductListWithParam:formula Success:^(id DFUserModel) {
            DiseaseFormulaPruduct *formup=DFUserModel;
            [m_data addObjectsFromArray:formup.list];
            [m_table reloadData];
             m_currPage ++;
            [m_table footerEndRefreshing];
        } failure:^(HttpException *e) {
        }];
    } else if (self.params[@"type"]) {
        DiseaseProductListR *productr=[DiseaseProductListR new];
        productr.diseaseId=self.params[@"diseaseId"];
        productr.type=myFormat(@"%@", self.params[@"type"]);
        productr.currPage=StrFromInt((int)m_currPage);
        productr.pageSize=StrFromInt(PAGE_ROW_NUM);
        [Order queryDiseaseProductListWithParam:productr Success:^(id DFUserModel) {
            DiseaseProductList *pro=DFUserModel;
            [m_data addObjectsFromArray:pro.list];
            [m_table reloadData];
            m_currPage ++;
            [m_table footerEndRefreshing];
        } failure:^(HttpException *e) {
        }];
    } else if (self.params[@"factoryCode"]) {
        FactoryProductListnameR *factoryR=[FactoryProductListnameR new];
        factoryR.factoryCode=self.params[@"factoryCode"];
        factoryR.currPage=StrFromInt((int)m_currPage);
        factoryR.pageSize=StrFromInt(PAGE_ROW_NUM);
        [Order queryFactoryProductListWithParam:factoryR Success:^(id DFUserModel) {
            FactoryProductListname *product=DFUserModel;
            [m_data addObjectsFromArray:product.list];
            [m_table reloadData];
            m_currPage ++;
            [m_table footerEndRefreshing];
        } failure:^(HttpException *e) {
        }];
    }  else if (self.params[@"drugStoreCode"]) {
        if (m_data.count >= 20) {
            showNotice(@"最多浏览20条。");
            return;
        }
        bisSells = YES;
        pharmacyProductR *pharR=[pharmacyProductR new];
        pharR.groupId   = self.params[@"drugStoreCode"];
        pharR.currPage  = StrFromInt((int)m_currPage);
        pharR.pageSize  = StrFromInt(PAGE_ROW_NUM);
        [Order querypharmacyProductListWithParam:pharR Success:^(id DFUserModel) {
            pharmacyProduct *product=DFUserModel;
            [m_data addObjectsFromArray:product.list];
            [m_table reloadData];
            m_currPage ++;
            [m_table footerEndRefreshing];
        } failure:^(HttpException *e) {
        }];
    }
}

#pragma mark - MJRefreshBaseViewDelegate


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = [m_data[indexPath.row]dictionaryModel][@"proId"];
    modelDrug.promotionID = @"";
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = [m_data[indexPath.row]dictionaryModel];
    NSString* proId = dataRow[@"id"];
    if (!proId) proId = dataRow[@"proId"];
    NSString* str = [NSString stringWithFormat:@"cell_%@", proId];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView* border = [[UIView alloc] initWithFrame: RECT(0, m_table.rowHeight-0.5, APP_W, 0.5)];
        border.backgroundColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0];
        [cell addSubview:border];
        [self addCellObjs:cell IndexPath:indexPath];
    }

    return cell;
}


- (void)addCellObjs:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* row = [[m_data objectAtIndex:indexPath.row]dictionaryModel];
    
    CGRect rect = RECT(10, 10, 68, 68);
    const int BAN_E = 10;
    
    NSString* imgurl = row[@"imgUrl"];
    UIImageView* webImage = [[UIImageView alloc] initWithFrame:rect];
    webImage.tag = 50;

    webImage.layer.borderColor = RGBHex(qwColor9).CGColor;

    webImage.layer.borderWidth = 0.5;
    webImage.backgroundColor = [UIColor clearColor];
    [webImage setImageWithURL:[NSURL URLWithString:imgurl]
              placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    webImage.clipsToBounds = YES;
    [cell addSubview:webImage];
    
    CGFloat x = webImage.frame.origin.x+webImage.frame.size.width+BAN_E;
    UILabel* lbtitle = [[UILabel alloc] init];
    lbtitle.tag = 51;
    lbtitle.frame = RECT(x, BAN_E+5, APP_W-25-x, 26);
    lbtitle.backgroundColor = [UIColor clearColor];
    lbtitle.textAlignment = NSTextAlignmentLeft;
    lbtitle.textColor = RGBHex(qwColor6);
    lbtitle.font = font(kFont3, kFontS5);
    lbtitle.text = [row objectForKey:@"proName"];
    lbtitle.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
    lbtitle.numberOfLines = 1;
    [cell addSubview:lbtitle];
    [lbtitle sizeToFit];
    
    UILabel* lbDesc = [[UILabel alloc] init];
    lbDesc.tag = 52;
    lbDesc.frame = RECT(x, lbtitle.frame.origin.y+lbtitle.frame.size.height+7, APP_W-25-x, 12);
    lbDesc.backgroundColor = [UIColor clearColor];
    lbDesc.textAlignment = NSTextAlignmentLeft;
    lbDesc.textColor =RGBHex(qwColor7);
    lbDesc.font = font(kFont4, kFontS5);
    lbDesc.text = [row objectForKey:@"spec"];
    lbDesc.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell addSubview:lbDesc];
    [lbDesc sizeToFit];
    
    NSString* factory = row[@"factory"];
    if (factory==nil) factory = row[@"makePlace"];
    if (factory==nil) factory = row[@"makeplace"];
    UILabel* lbcomp = [[UILabel alloc] init];
    lbcomp.tag = 53;
    lbcomp.frame = RECT(x, lbDesc.frame.origin.y+lbDesc.frame.size.height+7, APP_W-25-x, 36);
    lbcomp.backgroundColor = [UIColor clearColor];
    lbcomp.textAlignment = NSTextAlignmentLeft;
    lbcomp.textColor = RGBHex(qwColor7);
    lbcomp.font = font(kFont4, kFontS5);
    lbcomp.text = factory;
    lbcomp.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    lbcomp.numberOfLines = 0;
    [cell addSubview:lbcomp];
    [lbcomp sizeToFit];
    if (bisSells) {
        if (row[@"tag"] != nil) {
            UIView* flag_bg = [[UIView alloc] initWithFrame:RECT(0, webImage.FH-15, webImage.FW, 15)];
            flag_bg.backgroundColor = [UIColor blackColor];
            flag_bg.alpha = 0.6;
            [webImage addSubview:flag_bg];
            addLabelObjEx(webImage, @[@54, NSStringFromCGRect(flag_bg.frame), [UIColor whiteColor], font(kFont4, kFontS6),
                    myFormat(@"%@", row[@"tag"])]).textAlignment = NSTextAlignmentCenter;
        }
        UIImageView* flagIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sellFlag.png"]];
        flagIcon.frame = RECT(10, 10, flagIcon.FW, flagIcon.FH);
        [cell addSubview:flagIcon];
        addLabelObjEx(flagIcon, @[@55, NSStringFromCGRect(flagIcon.bounds),
                                  [UIColor whiteColor], font(kFont4, kFontS6),
                                  myFormat(@"%d",indexPath.row+1)]).textAlignment = NSTextAlignmentCenter;
    }
}


@end

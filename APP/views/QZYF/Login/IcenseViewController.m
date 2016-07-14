//
//  IcenseViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IcenseViewController.h"
#import "LcenseListCell.h"
#import "CorporationViewController.h"
#import "AddlenseViewController.h"
#import "ApothecaryViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "FinishViewController.h"
#import "Store.h"
#import "StoreModel.h"

@interface IcenseViewController ()<UITableViewDataSource,UITableViewDelegate,finishcorporationInfoDelegate,finishlenseInfoDelegate>

@property (assign, nonatomic) BOOL           iskindChose;
@property (assign, nonatomic) BOOL           shefenzheng;
@property (strong, nonatomic) NSMutableArray *kind_oneArr;
@property (strong, nonatomic) NSMutableArray *kind_twoArr;
@property (strong, nonatomic) NSMutableArray *finishCerfitiArr;
@property (strong, nonatomic) UIImageView    *imagekindone;
@property (strong, nonatomic) UIImageView    *imagekindtwo;
@property (strong, nonatomic) NSString       *imagechoseone;
@property (strong, nonatomic) NSString       *imagechosetwo;
@property (strong, nonatomic) NSString       *imagefaren;
@property (strong, nonatomic) NSString       *chosekinds;
@property (strong, nonatomic) UIButton       *btn_choseone;
@property (strong, nonatomic) UIButton       *btn_chosetwo;
@property (strong, nonatomic) NSString       *groupType;

@property (strong, nonatomic) IBOutlet UIView      *tableheadview;
@property (strong, nonatomic) IBOutlet UITableView *Lcensetable;
@property (strong, nonatomic) IBOutlet UIImageView *sliderleft;
@property (strong, nonatomic) IBOutlet UIImageView *sliderright;

@end

@implementation IcenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.tableheadview.frame = CGRectMake(0, 0, 320, 75);
    self.Lcensetable.tableHeaderView =self.tableheadview;

    self.imagechoseone = @"机构类型-未选中";
    self.imagechosetwo  = @"机构类型-未选中";
    self.imagefaren = @"向右箭头";
    self.sliderleft.backgroundColor = [UIColor colorWithRed:69/255.0f green:192/255.0f blue:26/255.0f alpha:1];
    self.sliderright.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
    self.sliderleft.layer.cornerRadius = 5.0f;
    self.sliderleft.layer.masksToBounds = YES;
    self.sliderright.layer.cornerRadius = 5.0f;
    self.sliderright.layer.masksToBounds = YES;
    self.btn_choseone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_chosetwo = [UIButton buttonWithType:UIButtonTypeCustom];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self searchCerfiti];
}

-(void)finishlenseInfoDelegate{
    
}

#pragma mark ====
#pragma mark ==== 获取执照列表

-(void)searchCerfiti{
    
    self.kind_oneArr = [NSMutableArray array];
    self.kind_oneArr = [NSMutableArray arrayWithObjects:@"药品经营许可证(必填)",@"营业执照(必填)",@"GSP认证执照", nil];
    self.kind_twoArr = [NSMutableArray array];
    self.kind_twoArr = [NSMutableArray arrayWithObjects:@"营业执照(必填)",@"医疗机构执业许可证(必填)", nil];
    self.finishCerfitiArr = [NSMutableArray array];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
   
    setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
    setting[@"queryAll"]= @"all";
    
    [Store QueryCertifiWithParams:setting success:^(id obj) {
        
        NSMutableArray *cerfitiarr = [NSMutableArray array];
        QueryCertifiPage *page = (QueryCertifiPage *)obj;
        cerfitiarr = (NSMutableArray *)page.certifiList;
        
        self.groupType = [NSString stringWithFormat:@"%@",page.groupType];
        if (cerfitiarr.count > 0) {
            for (int i=0 ;  i < cerfitiarr.count;i++) {
                QueryCertifiModel *model = cerfitiarr[i];
                if ([model.valueName isEqualToString:@"法人/企业负责人身份证"]) {
                    self.imagefaren = @"选中的勾号";
                    [self.Lcensetable reloadData];
                }
            }
        }
        if ( self.groupType.length == 0) {
            self.groupType= @"1";
        }
        
        if ( self.groupType.length > 0) {
            
            NSString *cerfitiName;
            if ([ self.groupType isEqualToString:@"1"]) {
                self.imagechoseone = @"机构类型-选中";
                self.chosekinds = @"medicine";
                for (int i=0 ;  i < cerfitiarr.count;i++) {
                    QueryCertifiModel *model = cerfitiarr[i];
                    if([model.typeId intValue] == 9){
                        cerfitiName = model.etpName;
                    }else{
                        cerfitiName = model.valueName;
                    }
                    
                    if ([cerfitiName isEqualToString:@"营业执照"]) {
                        [self.finishCerfitiArr addObject:@"营业执照(必填)"];
                        
                    }else if ([cerfitiName isEqualToString:@"药品经营许可证"]) {
                        [self.finishCerfitiArr addObject:@"药品经营许可证(必填)"];
                        
                    }else if ([cerfitiName isEqualToString:@"GSP证书"]) {
                        [self.finishCerfitiArr addObject:@"GSP认证执照"];
                        
                    }else  if ([cerfitiName isEqualToString:@"法人/企业负责人身份证"]){
                        
                        
                    } else{
                        [self.kind_oneArr addObject:cerfitiName];
                        
                    }
                }
            }else if ([ self.groupType isEqualToString:@"3"]) {
                self.chosekinds = @"else";
                self.imagechosetwo  = @"机构类型-选中";
                
                for (int i=0 ;  i < cerfitiarr.count;i++) {
                     QueryCertifiModel *model = cerfitiarr[i];
                    if([model.typeId intValue] == 9){
                        cerfitiName = model.etpName;
                        
                    }else{
                        cerfitiName = model.valueName;
                        
                    }
                    if ([cerfitiName isEqualToString:@"营业执照"]) {
                        
                        [self.finishCerfitiArr addObject:@"营业执照(必填)"];
                    }else if([cerfitiName isEqualToString:@"医疗机构许可证"]){
                        [self.finishCerfitiArr addObject:@"医疗机构执业许可证(必填)"];
                    }else  if ([model.valueName isEqualToString:@"法人/企业负责人身份证"]){
                        
                    }else{
                        [self.kind_twoArr addObject:cerfitiName];
                    }
                }
            }
            self.iskindChose = YES;
        }
        [self.Lcensetable reloadData];

    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ====
#pragma mark ==== 列表代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45.0f;
    }else{
        return 80.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if (self.iskindChose == YES) {
            return 170.0f;
        }else{
            return 105.0f;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 ) {
        UIView *firstHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        firstHV.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f];
        UIImageView *imagebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
        imagebg.backgroundColor = [UIColor whiteColor];
        UIButton *btn_user = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_user.frame = CGRectMake(0,0 ,270, 45);
        btn_user.backgroundColor = [UIColor clearColor];
        // 填写法人信息
        [btn_user addTarget:self action:@selector(writeInfoAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imagelast = [[UIImageView alloc] initWithFrame:CGRectMake(280, 18, 14, 14)];
        imagelast.image = [UIImage imageNamed:self.imagefaren];
        UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 40)];
        NSString *title = @"法人/企业负责人身份证(必填)";
        NSDictionary *grayAttrs = @{
                                    NSForegroundColorAttributeName: [UIColor colorWithRed:134/255.0f green:155/255.0f blue:178/255.0f alpha:1.0f]};
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title];
        [aString setAttributes:grayAttrs range:NSMakeRange(11,4)];
        lbl_title.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        lbl_title.attributedText = aString;
        [firstHV addSubview:imagebg];
        [firstHV addSubview:btn_user];
        [firstHV addSubview:lbl_title];
        [firstHV addSubview:imagelast];
        return firstHV;
    }else{
        UIView *SecondHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        SecondHV.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f];
        UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        lbl_title.text = @"机构执照";
        lbl_title.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        UILabel *lbl_line = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 300, 1)];
        lbl_line.backgroundColor = [UIColor colorWithRed:66/255.0f green:188/255.0f blue:51/255.0f alpha:1.0f];
        UIImageView *imagebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 40)];
        imagebg.backgroundColor = [UIColor whiteColor];
        UILabel *lbl_kindclass = [[UILabel alloc] initWithFrame:CGRectMake(10, 40,150 , 40)];
        lbl_kindclass.text = @"选择机构类型";
        lbl_kindclass.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        UILabel *lbl_kindone = [[UILabel alloc] initWithFrame:CGRectMake(180, 45,40, 30)];
        lbl_kindone.font = [UIFont systemFontOfSize:14];
        lbl_kindone.text = @"药店";
        lbl_kindone.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        UILabel *lbl_kindtwo = [[UILabel alloc] initWithFrame:CGRectMake(250, 45,60 ,30)];
        lbl_kindtwo.text = @"医疗机构";
        lbl_kindtwo.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        lbl_kindtwo.font = [UIFont systemFontOfSize:14];
        self.imagekindone = [[UIImageView alloc] initWithFrame:CGRectMake(155, 50, 20, 20)];
        self.imagekindone.backgroundColor = [UIColor clearColor];
        self.imagekindone.image = [UIImage imageNamed:self.imagechoseone];
        self.imagekindtwo = [[UIImageView alloc] initWithFrame:CGRectMake(225, 50, 20, 20)];
        self.imagekindtwo.backgroundColor = [UIColor clearColor];
        self.imagekindtwo.image = [UIImage imageNamed:self.imagechosetwo];
        self.btn_choseone.frame = CGRectMake(155,45 ,65, 45);
        self.btn_choseone.backgroundColor = [UIColor clearColor];
        //        选择药店
        self.btn_choseone.tag = 1001;
        [self.btn_choseone addTarget:self action:@selector(choseMedicineShopAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.btn_chosetwo.frame = CGRectMake(215,45 ,85, 45);
        self.btn_chosetwo.backgroundColor = [UIColor clearColor];
        //        选择医疗机构
        self.btn_chosetwo.tag = 1002;
        [self.btn_chosetwo addTarget:self action:@selector(choseMedicineShopAction:) forControlEvents:UIControlEventTouchUpInside];
        [SecondHV addSubview:imagebg];
        [SecondHV addSubview:lbl_kindclass];
        [SecondHV addSubview:lbl_kindone];
        [SecondHV addSubview:lbl_kindtwo];
        [SecondHV addSubview:lbl_line];
        [SecondHV addSubview:lbl_title];
        [SecondHV addSubview:self.imagekindone];
        [SecondHV addSubview:self.imagekindtwo];
        [SecondHV addSubview:self.btn_choseone];
        [SecondHV addSubview:self.btn_chosetwo];
        return SecondHV;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else {
        CGFloat currentOriginY;
        UIView *addLense ;
        if (self.iskindChose == YES) {
            addLense = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 320, 45)];
            addLense.backgroundColor = [UIColor whiteColor];
            UIImageView *imageadd = [[UIImageView alloc] initWithFrame:CGRectMake(90, 15, 15, 15)];
            imageadd.image = [UIImage imageNamed:@"新增"];
            UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(130 ,7,80 ,30)];
            lbl_title.text = @"添加执照";
            [addLense addSubview:lbl_title];
            UITapGestureRecognizer  *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addlenseAction)];
            [addLense addSubview:imageadd];
            [addLense addGestureRecognizer:recognizer];
            currentOriginY = addLense.frame.origin.y + 45;
        }
        UIButton *btn_doctor = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_doctor.frame = CGRectMake(160, currentOriginY+10, 150, 30);
        currentOriginY = btn_doctor.frame.origin.y+30;
        [btn_doctor setTitle:@"有执业药师?马上认证" forState:UIControlStateNormal];
        btn_doctor.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn_doctor setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn_doctor addTarget:self action:@selector(ApothecaryAction) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btn_finish = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_finish.frame = CGRectMake(30, currentOriginY+20, 260, 45);
        btn_finish.backgroundColor = [UIColor colorWithRed:68/255.0f green:192/255.0f blue:53/255.0f alpha:1.0f];
        
        currentOriginY = btn_finish.frame.origin.y+45;
        [btn_finish setTitle:@"完成" forState:UIControlStateNormal];
        [btn_finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_finish.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [btn_finish addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, currentOriginY+12)];
        footerV.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f];
        if (self.iskindChose == YES){
            [footerV addSubview:addLense];
        }
        [footerV addSubview:btn_doctor];
        [footerV addSubview:btn_finish];
        return footerV;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        if (self.iskindChose == YES) {
            
            if ([self.chosekinds isEqualToString:@"medicine"]) {
                return self.kind_oneArr.count;
            }else if([self.chosekinds isEqualToString:@"else"]){
                return self.kind_twoArr.count;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LcenseListCellIdentifier = @"LcenseListCell";
    LcenseListCell*cell = (LcenseListCell *)[tableView dequeueReusableCellWithIdentifier:LcenseListCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"LcenseListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:LcenseListCellIdentifier];
        cell = (LcenseListCell *)[tableView dequeueReusableCellWithIdentifier:LcenseListCellIdentifier];
    }
    
    if ([self.chosekinds isEqualToString:@"medicine"]) {
        if(indexPath.row == 0){
            NSString *title = [self.kind_oneArr objectAtIndex:indexPath.row];
            
            NSDictionary *grayAttrs = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:134/255.0f green:155/255.0f blue:178/255.0f alpha:1.0f]};
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title];
            [aString setAttributes:grayAttrs range:NSMakeRange(7,4)];
            cell.lbl_lcense.attributedText = aString;
            
        }else  if(indexPath.row == 1){
            NSString *title = [self.kind_oneArr objectAtIndex:indexPath.row];
            
            NSDictionary *grayAttrs = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:134/255.0f green:155/255.0f blue:178/255.0f alpha:1.0f]};
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title];
            [aString setAttributes:grayAttrs range:NSMakeRange(4,4)];
            cell.lbl_lcense.attributedText = aString;
            
        }else{
            cell.lbl_lcense.text = [self.kind_oneArr objectAtIndex:indexPath.row];
        }
        
        if(indexPath.row < 3){
            if (self.finishCerfitiArr.count > 0) {
                
                NSString *celltext =[self.kind_oneArr objectAtIndex:indexPath.row];
                for (int i =0; i < self.finishCerfitiArr.count; i++) {
                    NSString *compareStr = [self.finishCerfitiArr objectAtIndex:i];
                    if ([celltext isEqualToString:compareStr]) {
                        cell.img_isfinish.image = [UIImage imageNamed:@"选中的勾号"];
                        break;
                    }else{
                        cell.img_isfinish.image = [UIImage imageNamed:@"向右箭头"];
                    }
                }
            }else{
                cell.img_isfinish.image = [UIImage imageNamed:@"向右箭头"];
            }
        }else{
            cell.img_isfinish.image = [UIImage imageNamed:@"选中的勾号"];
        }
    }
    
    else{
        if(indexPath.row == 0){
            NSString *title = [self.kind_twoArr objectAtIndex:indexPath.row];
            
            NSDictionary *grayAttrs = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:134/255.0f green:155/255.0f blue:178/255.0f alpha:1.0f]};
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title];
            [aString setAttributes:grayAttrs range:NSMakeRange(4,4)];
            cell.lbl_lcense.attributedText = aString;
        }else  if(indexPath.row == 1){
            NSString *title = [self.kind_twoArr objectAtIndex:indexPath.row];
            
            NSDictionary *grayAttrs = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:134/255.0f green:155/255.0f blue:178/255.0f alpha:1.0f]};
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title];
            [aString setAttributes:grayAttrs range:NSMakeRange(9,4)];
            cell.lbl_lcense.attributedText = aString;
        }else{
            cell.lbl_lcense.text = [self.kind_twoArr objectAtIndex:indexPath.row];
        }
        if(indexPath.row < 2){
            if (self.finishCerfitiArr.count > 0) {
                NSString *celltext =[self.kind_twoArr objectAtIndex:indexPath.row];
                for (int i =0; i < self.finishCerfitiArr.count; i++) {
                    NSString *compareStr = [self.finishCerfitiArr objectAtIndex:i];
                    if ([celltext isEqualToString:compareStr]) {
                        cell.img_isfinish.image = [UIImage imageNamed:@"选中的勾号"];
                        break;
                    }else{
                        cell.img_isfinish.image = [UIImage imageNamed:@"向右箭头"];
                    }
                }
            }else{
                cell.img_isfinish.image = [UIImage imageNamed:@"向右箭头"];
            }
        }else{
            cell.img_isfinish.image = [UIImage imageNamed:@"选中的勾号"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddlenseViewController *addlenseVC = [[AddlenseViewController alloc] initWithNibName:@"AddlenseViewController" bundle:nil];
    if ([self.chosekinds isEqualToString:@"medicine"]) {
        if (indexPath.row == 0) {
            addlenseVC.lensename = @"药品经营许可证";
        }else if(indexPath.row == 1){
            addlenseVC.lensename = @"营业执照";
        }else if(indexPath.row == 2){
            addlenseVC.lensename = @"GSP认证执照";
        }
        if (indexPath.row < 3) {
            addlenseVC.lenseclass = indexPath.row;
        }else{
            addlenseVC.lenseclass = 4;
            addlenseVC.lensename =  [self.kind_oneArr objectAtIndex:indexPath.row];
        }
    }else{
        if (indexPath.row  ==0) {
            addlenseVC.lenseclass = 1;
            addlenseVC.lensename = @"营业执照";
        }else  if(indexPath.row == 1){
            addlenseVC.lenseclass = 3;
            addlenseVC.lensename = @"医疗机构执业许可证";
        }else{
            addlenseVC.lenseclass = 4;
            addlenseVC.lensename = [self.kind_twoArr objectAtIndex:indexPath.row];
        }
    }
    addlenseVC.finishlenseInfoDelegate = self;
    
    [self.navigationController pushViewController:addlenseVC animated:YES];
    
}

-(void)finishcorporationInfo:(BOOL)finish{
    if (finish == YES) {
        self.imagefaren = @"选中的勾号";
    }
    [self.Lcensetable reloadData];
}

#pragma mark ====
#pragma mark ==== 填写法人信息

-(void)writeInfoAction{
    CorporationViewController *corporVC = [[CorporationViewController  alloc] initWithNibName:@"CorporationViewController" bundle:nil];
    corporVC.finishcorporationInfoDelegate = self;
    [self.navigationController pushViewController:corporVC animated:YES];
}

-(void)addlenseAction{
    AddlenseViewController *addlenseVC = [[AddlenseViewController alloc] initWithNibName:@"AddlenseViewController" bundle:nil];
    addlenseVC.lenseclass = 4;
    [self.navigationController pushViewController:addlenseVC animated:YES];
}

#pragma mark ====
#pragma mark ==== 选择机构类型

-(void)choseMedicineShopAction:(id)sender{
    UIButton *btn= sender;
    if (btn.tag == 1001 ) {
        self.chosekinds = @"medicine";
        self.imagechoseone = @"机构类型-选中";
        self.imagechosetwo  = @"机构类型-未选中";
        self.iskindChose = YES;
    }else{
        self.imagechoseone = @"机构类型-未选中";
        self.imagechosetwo  = @"机构类型-选中";
        self.chosekinds = @"else";
        self.iskindChose = YES;
    }
    
    if ([self.chosekinds isEqualToString:@"medicine"]) {
        self.groupType = @"1";
    }else {
        self.groupType = @"3";
    }
    [self updategroupType];
}

#pragma mark ====
#pragma mark ==== 更新机构类型

-(void)updategroupType{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
    setting[@"groupType"] = StrFromObj(self.groupType);
    
    [Store UpdateBranchGroupTypeWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            [self searchCerfiti];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        
    }];
}

-(void)ApothecaryAction{
    
    if ( [QWUserDefault getObjectBy:REGISTER_JG_REGISTERID]) {
        
        ApothecaryViewController *apothVC = [[ApothecaryViewController alloc] initWithNibName:@"ApothecaryViewController" bundle:nil];
        [self.navigationController pushViewController:apothVC animated:NO];
    }
}

#pragma mark ====
#pragma mark ==== 注册完成的方法调用

-(void)finishAction{
    if ([self.chosekinds isEqualToString:@"medicine"]) {
        if (![self.imagefaren isEqualToString:@"选中的勾号"]) {
            [SVProgressHUD showErrorWithStatus:@"请完善法人/企业负责人身份证" duration:DURATION_SHORT];
            return;
        }else if (![self.finishCerfitiArr containsObject:@"营业执照(必填)"]){
            [SVProgressHUD showErrorWithStatus:@"请完善营业执照" duration:DURATION_SHORT];
            return;
            
        }else if (![self.finishCerfitiArr containsObject:@"药品经营许可证(必填)"]) {
            [SVProgressHUD showErrorWithStatus:@"请完善药品经营许可证" duration:DURATION_SHORT];
            return;
        }else{
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
            
            [Store UpdateBranchStatusWithParams:setting success:^(id obj) {
                
                if ([obj[@"apiStatus"] intValue] == 0) {
                    [self updategroupType];
                    FinishViewController *finish = [[FinishViewController alloc] initWithNibName:@"FinishViewController" bundle:nil];
                    [self.navigationController pushViewController:finish animated:NO];
                }else
                {
                   [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
                }
                
            } failure:^(HttpException *e) {
                
            }];
        }
        
    }else{
        if (![self.imagefaren isEqualToString:@"选中的勾号"]) {
            [SVProgressHUD showErrorWithStatus:@"请完善法人/企业负责人身份证" duration:DURATION_SHORT];
            return;
        }else if (![self.finishCerfitiArr containsObject:@"营业执照(必填)"]) {
            [SVProgressHUD showErrorWithStatus:@"请完善营业执照" duration:DURATION_SHORT];
            return;
        }
        else if (![self.finishCerfitiArr containsObject:@"医疗机构执业许可证(必填)"]){
            [SVProgressHUD showErrorWithStatus:@"请完善医疗机构执业许可证" duration:DURATION_SHORT];
            return;
            
        }else{
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
            
            [Store UpdateBranchStatusWithParams:setting success:^(id obj) {
                
                if ([obj[@"apiStatus"] intValue] == 0) {
                    [self updategroupType];
                    FinishViewController *finish = [[FinishViewController alloc] initWithNibName:@"FinishViewController" bundle:nil];
                    [self.navigationController pushViewController:finish animated:NO];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
                }
                
            } failure:^(HttpException *e) {
                
            }];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


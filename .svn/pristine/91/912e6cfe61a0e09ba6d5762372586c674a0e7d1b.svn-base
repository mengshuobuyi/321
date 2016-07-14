//
//  CarePharmacistViewController.m
//  APP
//
//  Created by Martin.Liu on 15/12/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CarePharmacistViewController.h"
#import "TitleCollectionReusableView.h"
#import "PharmacistCollectionCell.h"
#import "NoCarePharmacistCollectionCell.h"
#import "LoginToCarePharmacistCollectionCell.h"
#import "LoginViewController.h"
#import "Forum.h"
#import "SVProgressHUD.h"
//#import "CarePharmacistCollectionLayout.h"
@interface CarePharmacistViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

@end

@implementation CarePharmacistViewController
{
    NSArray* attnExpertArray;
    NSArray* expertArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.flowlayout.headerReferenceSize = CGSizeMake(APP_W, 44);
    self.collectionView.backgroundColor = RGBHex(qwColor11);
    [self.collectionView registerNib:[UINib nibWithNibName:@"TitleCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TitleCollectionReusableView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PharmacistCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PharmacistCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NoCarePharmacistCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"NoCarePharmacistCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoginToCarePharmacistCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"LoginToCarePharmacistCollectionCell"];
}

- (void)UIGlobal
{
    if (APP_W > 320) {
        CGFloat flowLayoutWidth = (APP_W - MAX(self.flowlayout.sectionInset.left, self.flowlayout.sectionInset.right) * 3) / 2;
        self.flowlayout.itemSize = CGSizeMake(flowLayoutWidth, flowLayoutWidth * self.flowlayout.itemSize.height / self.flowlayout.itemSize.width);
//        UIEdgeInsets sectionInset = self.flowlayout.sectionInset;
//        sectionInset.left = sectionInset.right = (APP_W - self.flowlayout.itemSize.width * 2) / 3 ;
//        self.flowlayout.sectionInset = sectionInset;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (expertArray.count == 0) {
        [self loadData];
    }
}

- (void)loadData
{
    GetExpertListInfoR* getExpertListInfoR = [GetExpertListInfoR new];
    getExpertListInfoR.token = QWGLOBALMANAGER.configure.expertToken;
    [Forum getAttenAndRecommendExpertListInfo:getExpertListInfoR success:^(QWAttnAndRecommendExpertList *expertList) {
        [self removeInfoView];
        attnExpertArray = expertList.attnExpertList;
        expertArray = expertList.expertList;
        
        if (attnExpertArray.count == 0 && expertArray.count == 0) {
            [self showInfoView:@"暂无关注的圈子" image:@"ic_img_fail"];
        }
        else
        {
            [self removeInfoView];
        }
        
        [self.collectionView reloadData];
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
         DebugLog(@"getAttenAndRecommendExpertListInfo : %@", e);;
    }];
//    [Forum getAllExpertInfoSuccess:^(NSArray *expertArray_) {
//        expertArray = expertArray_;
//        [self.collectionView reloadData];
//    } failure:^(HttpException *e) {
//        DebugLog(@"getAllExpertInfo : %@", e);
//    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (expertArray.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (QWGLOBALMANAGER.loginStatus) {
            return MAX(attnExpertArray.count, 1);
        }
        else
            return 1;
    }
    return expertArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TitleCollectionReusableView* header = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        header = (TitleCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TitleCollectionReusableView" forIndexPath:indexPath];
        header.backgroundColor = RGBHex(qwColor11);
        NSString* titleString = nil;
        switch (indexPath.section) {
            case 0:
                titleString = @"我关注的专家";
                break;
            case 1:
                titleString = @"推荐专家";
                break;
            default:
                break;
        }
        header.titleTextLabel.text = titleString;
    }
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if (QWGLOBALMANAGER.loginStatus) {
            if (attnExpertArray.count == 0) {
                NoCarePharmacistCollectionCell* noCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoCarePharmacistCollectionCell" forIndexPath:indexPath];
                return noCell;
            }
            else
            {
                PharmacistCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PharmacistCollectionCell" forIndexPath:indexPath];
                QWExpertInfoModel* expertInfoModel = attnExpertArray[row];
                cell.careBtn.touchUpInsideBlock = ^{
                    if (!QWGLOBALMANAGER.loginStatus) {
                        LoginViewController *vc = [[LoginViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
//                        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//                        UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//                        loginViewController.isPresentType = YES;
//                        [self presentViewController:navgationController animated:YES completion:NULL];
                        return;
                    }
                    AttentionMbrR* attentionMbrR = [AttentionMbrR new];
                    attentionMbrR.objId = expertInfoModel.id;
                    attentionMbrR.reqBizType = 1;
                    attentionMbrR.token = QWGLOBALMANAGER.configure.expertToken;
                    [Forum attentionMbr:attentionMbrR success:^(BaseAPIModel *baseAPIModel) {
                        if ([baseAPIModel.apiStatus integerValue] == 0) {
                            [self loadData];
                        }
                        else
                        {
                            [SVProgressHUD showErrorWithStatus:baseAPIModel.apiMessage];
                        }
                    } failure:^(HttpException *e) {
                        DebugLog(@"cancel attention expert error : %@", e);
                    }];
                };
                [cell setCell:expertInfoModel];
                cell.careBtn.enabled = YES;
                cell.careBtn.backgroundColor = RGBHex(qwColor9);
                [cell.careBtn setTitle:@"取消关注" forState:UIControlStateNormal];

                return cell;
            }
        }
        else
        {
            LoginToCarePharmacistCollectionCell* loginCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoginToCarePharmacistCollectionCell" forIndexPath:indexPath];
            loginCell.loginBtn.touchUpInsideBlock = ^{
                LoginViewController *vc = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
//                LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//                UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//                loginViewController.isPresentType = YES;
//                [self presentViewController:navgationController animated:YES completion:NULL];
                
            };
            return loginCell;
        }
        
    }
    PharmacistCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PharmacistCollectionCell" forIndexPath:indexPath];
    QWExpertInfoModel* expertInfoModel = expertArray[row];
    cell.careBtn.touchUpInsideBlock = ^{
        
        if (!QWGLOBALMANAGER.loginStatus) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
//            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//            loginViewController.isPresentType = YES;
//            [self presentViewController:navgationController animated:YES completion:NULL];
            return;
        }
        
        AttentionMbrR* attentionMbrR = [AttentionMbrR new];
        attentionMbrR.objId = expertInfoModel.id;
        attentionMbrR.reqBizType = 0;
        attentionMbrR.token = QWGLOBALMANAGER.configure.expertToken;
        [Forum attentionMbr:attentionMbrR success:^(BaseAPIModel *baseAPIModel) {
            if ([baseAPIModel.apiStatus integerValue] == 0) {
                [self loadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:baseAPIModel.apiMessage];
            }
        } failure:^(HttpException *e) {
            DebugLog(@"cancel attention expert error : %@", e);
        }];
    };

    [cell setCell:expertInfoModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && (!QWGLOBALMANAGER.loginStatus || attnExpertArray.count == 0)) {
        return CGSizeMake(APP_W - 30, 100);
    }
    else
    {
        return self.flowlayout.itemSize;
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifLoginSuccess || type == NotifQuitOut) {
        [self loadData];
    }
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

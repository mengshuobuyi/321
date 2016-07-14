//
//  TipDetailViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "TipDetailViewController.h"
#import "CustomImageCollectionViewCell.h"
#import "QYPhotoAlbum.h"
#import "PhotoAlbum.h"
#import "QYImage.h"
#import "PhotoModel.h"
#import "PhotoPreView.h"
#import "Tips.h"
#import "CommonDetailTableViewCell.h"
#import "SlowDetailTableViewCell.h"
#import "CommonTableFootViewCell.h"
#import "TipProdctViewController.h"
#import "UIImageView+WebCache.h"
#import "WebDirectViewController.h"

static NSInteger kMaxNum = 3;   // 图片一行最多显示的item数

@interface TipDetailViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;
//相册拍照的参数
@property (strong, nonatomic) NSMutableArray *arrPhotos;//总得
@property (strong, nonatomic) NSMutableArray *arrTemp;//和相册交互的
@property (strong, nonatomic) NSMutableArray *httpTemp;//和服务器交互的
@property (strong, nonatomic) OrderDetailVo *model;//小票的详细内容
//上传用的参数
@property (strong, nonatomic) NSData *selectedImageData;
@property (strong, nonatomic) NSMutableArray *dataTemp;
@property (assign) int numPhotos;
@property (strong, nonatomic) UpTipModelR *mUpTip;

@end

@implementation TipDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"优惠详情";
    
    self.arrPhotos = [NSMutableArray array];
    self.arrTemp = [NSMutableArray array];
    self.httpTemp = [NSMutableArray array];
    self.dataTemp = [NSMutableArray array];
    
    //设置保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveMyreciept:)];

    self.tableRoot.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.model = nil;
    [self branchMyorder];
}

#pragma mark ---- 获得小票的详细数据 ----

-(void)branchMyorder
{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    TipsDetailModelR *branchR = [TipsDetailModelR new];
    branchR.token = QWGLOBALMANAGER.configure.userToken;
    branchR.type = self.type;
    branchR.orderId = self.orderId;
    
    [Tips GetTipsDeatilWithParams:branchR success:^(id responseObj) {
        
        // 解析数据
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([OrderDetailDrugVo class])];
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"productList"];
        OrderDetailVo *model= [OrderDetailVo parse:responseObj ClassArr:keyArr Elements:valueArr];
        
        self.model = model;
        
        // 上传的小票数量
        NSArray *labelArr = [model.url componentsSeparatedByString:@"_#QZSP#_"];
        if([labelArr[0] isEqualToString:@""]){
            self.arrPhotos=[NSMutableArray array];
        }else{
            self.arrPhotos=[NSMutableArray arrayWithArray:labelArr];
        }
        
        [self.collectionViewImages reloadData];
        self.tableRoot.tableFooterView=self.collectionViewImages;
        [self.tableRoot reloadData];
        
    } failure:^(HttpException *e) {
    }];
}

#pragma mark ---- 保存 Action ----

-(void)saveMyreciept:(id)sender
{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    
    //防止数组重用内存地址
    self.dataTemp=nil;
    self.dataTemp=[[NSMutableArray alloc]initWithCapacity:self.arrPhotos.count];
    
    self.httpTemp=nil;
    self.httpTemp=[[NSMutableArray alloc]initWithCapacity:self.arrPhotos.count];
    
    self.navigationItem.rightBarButtonItem.enabled=NO;
    for(int i=0;i<self.arrPhotos.count;i++){

        if([self.arrPhotos[i] isKindOfClass:[PhotoModel class]]){
            //相册中的转化为图片流上传
            PhotoModel *mode =self.arrPhotos[i];
            UIImage *img=mode.fullImage;
            if (img) {
                self.selectedImageData=UIImageJPEGRepresentation(img, 1.0);
            }
            [self.dataTemp addObject:self.selectedImageData];
        }else{
            //服务器上的
            [self.httpTemp addObject:self.arrPhotos[i]];
        }
       
    }
    
    if(!self.dataTemp.count>0){//没有新的图片（删除功能）
        self.mUpTip=nil;
        self.mUpTip=[UpTipModelR new];
        self.mUpTip.orderId=self.orderId;
        //如果用户由上传小票变非上传是不允许的
        if(self.httpTemp.count==0){
            [SVProgressHUD showErrorWithStatus:Kwarning220N88 duration:0.8];
            self.navigationItem.rightBarButtonItem.enabled=YES;
            return;
        }
        //赋值
        self.mUpTip.url=self.httpTemp[0];
        for(int i=1;i<self.httpTemp.count;i++){
            self.mUpTip.url=[self.mUpTip.url stringByAppendingFormat:@"_#QZSP#_%@",self.httpTemp[i]];
        }
        //冗错处理
        if(!self.mUpTip.url.length>0){
            self.mUpTip.url=@"";
        }
        //新增的参数
        self.mUpTip.token=QWGLOBALMANAGER.configure.userToken;
        HttpClientMgr.progressEnabled = YES;
        [Tips UpTipsDeatilWithParams:self.mUpTip success:^(id resultOBJ) {
            [self showSuccess:kWarning215N31];
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                self.navigationItem.rightBarButtonItem.enabled=YES;
                UIViewController *viewController = (UIViewController *)obj;
                if ([viewController isKindOfClass:[AllTipsViewController class]]) {
                    *stop = YES;

                    [self.navigationController popToViewController:viewController animated:YES];
                    
                }else if(idx == (self.navigationController.viewControllers.count - 1)){
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
            }];
        } failure:^(HttpException *e) {
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                [self showInfoView:kWaring12 image:@"img_network"];
            }else
            {
                if(e.errorCode!=-999){
                    if(e.errorCode == -1001){
                        [self showInfoView:kWarning215N54 image:@"img_preferential"];
                    }else{
                        [self showInfoView:kWarning215N0 image:@"img_preferential"];
                    }
                }
            }
        }];
        
    }else{
    //有新的相册就先上传后保存
   
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    setting[@"type"] = @(6);
    
    self.numPhotos=0;
    self.mUpTip=nil;
    self.mUpTip=[UpTipModelR new];
    self.mUpTip.orderId=self.orderId;
    __weak __typeof(self) weakSelf = self;
    HttpClientMgr.progressEnabled = YES;
    [[HttpClient sharedInstance]uploaderImg:self.dataTemp  params:setting withUrl:NW_uploadFile success:^(id responseObj) {
    if (responseObj[@"body"][@"url"]){
        //若考虑到顺序的问题可以稍作优化
        
        //循环获取上传成功的Url
        NSString *url=responseObj[@"body"][@"url"];
        if (weakSelf.numPhotos==0) {
            self.mUpTip.url=url;
        }else{
            self.mUpTip.url=[self.mUpTip.url stringByAppendingFormat:@"_#QZSP#_%@",url];
        }
        weakSelf.numPhotos++;
        //上传的总数一定之后，再加上原来的,一起提交保存
        if (weakSelf.numPhotos==self.dataTemp.count) {
            for(int i=0;i<self.httpTemp.count;i++){
             self.mUpTip.url=[self.mUpTip.url stringByAppendingFormat:@"_#QZSP#_%@",self.httpTemp[i]];
            }
        //新增的参数
        self.mUpTip.token=QWGLOBALMANAGER.configure.userToken;
            
    [Tips UpTipsDeatilWithParams:self.mUpTip success:^(id resultOBJ) {
        [self showSuccess:kWarning215N31];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.navigationItem.rightBarButtonItem.enabled=YES;
            UIViewController *viewController = (UIViewController *)obj;
            if ([viewController isKindOfClass:[AllTipsViewController class]]) {
                *stop = YES;
                      [self.navigationController popToViewController:viewController animated:YES];

            }else if(idx == (self.navigationController.viewControllers.count - 1)){

                 [self.navigationController popToRootViewControllerAnimated:YES];

            }
        }];
    } failure:^(HttpException *e) {
    }];
        }
    }
    }failure:^(HttpException *e) {
    } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    }
}

#pragma mark ---- 返回按钮 ----

- (void)popVCAction:(id)sender
{
    
    if ([self.changedele respondsToSelector:@selector(changeToCurrent:)]) {
        [self.changedele changeToCurrent:self.typeCell];
    }else{
        NSLog(@"代理没有实现changeToCurrent:方法");
    }
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
        UIViewController *viewController = (UIViewController *)obj;
        if ([viewController isKindOfClass:[AllTipsViewController class]]) {
            *stop = YES;
            [self.navigationController popToViewController:viewController animated:YES];
        }else if(idx == (self.navigationController.viewControllers.count - 1)){
             [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([self.type intValue] == 1)
    {
        // 1 是优惠商品
        return 2;
    }else{
        // 2 优惠券
        if ([self.scope intValue] == 1 || [self.scope intValue] == 4) {
            return 2;
        }else{
            return 3;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.type intValue] == 1)
    {
        //1 是优惠商品
        if(indexPath.row == 0){
            return [CommonTableFootViewCell getCellHeight:nil];    // 优惠细则
        }else{
            return [CommonDetailTableViewCell getCellHeight:nil];  // 优惠商品 消费信息
        }
    }
    else
    {
        //2是优惠券  scope 1.通用2.慢病3.全部4.礼品券5.商品券
        if ([self.scope intValue] == 1 || [self.scope intValue] == 4) { // 普通券 和 礼品券
            if(indexPath.row == 1){
                return [SlowDetailTableViewCell getCellHeight:nil];  // 详细消费信息
            }else{
                return [CommonTableFootViewCell getCellHeight:nil];  // 优惠细则
            }
        }else{ // 慢病券 和 商品券 加所购商品
            if(indexPath.row == 2){
                return [SlowDetailTableViewCell getCellHeight:nil];  // 详细消费信息
            }else{
                return [CommonTableFootViewCell getCellHeight:nil];  // 优惠细则 所购商品
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 优惠细则 所购商品
    static NSString *commonTableCell = @"commonTableFootCell";
    CommonTableFootViewCell *commonCell = (CommonTableFootViewCell *)[atableView dequeueReusableCellWithIdentifier:commonTableCell];
    if(commonCell == nil){
        UINib *nib = [UINib nibWithNibName:@"CommonTableFootViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:commonTableCell];
        commonCell = (CommonTableFootViewCell *)[atableView dequeueReusableCellWithIdentifier:commonTableCell];
    }

    // 优惠券 详细信息
    static NSString *SlowDetailCell = @"SlowDetailTableViewCell";
    SlowDetailTableViewCell *couponDetailCell = (SlowDetailTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SlowDetailCell];
    if(couponDetailCell == nil){
        UINib *nib = [UINib nibWithNibName:@"SlowDetailTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:SlowDetailCell];
        couponDetailCell = (SlowDetailTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SlowDetailCell];
    }
    
    // 优惠商品 消费信息
    static NSString *commonDetailTableCell = @"commonDetailTableCell";
    CommonDetailTableViewCell *productDetailCell = (CommonDetailTableViewCell *)[atableView dequeueReusableCellWithIdentifier:commonDetailTableCell];
    if(productDetailCell == nil){
        UINib *nib = [UINib nibWithNibName:@"CommonDetailTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:commonDetailTableCell];
        productDetailCell = (CommonDetailTableViewCell *)[atableView dequeueReusableCellWithIdentifier:commonDetailTableCell];
        productDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if([self.type intValue] == 1)
    {
        if(indexPath.row == 0)
        {
            // 优惠商品 优惠细则
            commonCell.titleLable.text = @"优惠细则";
            return commonCell;
            
        }else{
            
            //  优惠商品 消费信息
            if(self.model){
                productDetailCell.username.text = self.model.username;
                productDetailCell.quantity.text = [NSString stringWithFormat:@"%@",self.model.quantity];
                productDetailCell.trateDate.text = self.model.tradeDate;
            }
            return productDetailCell;
        }
    }
    else
    {
        //  1.通用2.慢病3.全部4.礼品券5.商品券
        //  普通券和礼品券 所购商品去掉
        if ([self.scope intValue] == 1 || [self.scope intValue] == 4)
        {
            if (indexPath.row == 1)
            {
                // 优惠券 详细信息
                if(self.model) {
                    couponDetailCell.username.text = self.model.username;
                    couponDetailCell.trateDate.text = self.model.tradeDate;
                }
                return couponDetailCell;
            }else
            {
                // 优惠券 优惠细则
                commonCell.titleLable.text = @"优惠细则";
                return commonCell;
            }
        }else
        {
            if(indexPath.row == 2)
            {
                // 优惠券 详细信息
                if(self.model) {
                    couponDetailCell.username.text = self.model.username;
                    couponDetailCell.trateDate.text = self.model.tradeDate;
                }
                return couponDetailCell;
            }else
            {
                // 优惠券 优惠细则 所购商品
                if(indexPath.row == 0){
                    commonCell.titleLable.text = @"优惠细则";
                }else{
                    commonCell.titleLable.text = @"所购商品";
                }
                return commonCell;
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if([self.type intValue] == 1)
    {
        //优惠商品
        if(indexPath.row == 0)
        {
            //优惠细则
            [self pushWebConditionDetailWithType:@"2" orderId:self.model.pid];
        }
    }else
    {
        // 优惠券
        if ([self.scope intValue] == 1 || [self.scope intValue] == 4) {
            
            // 普通券 礼品券
            if(indexPath.row == 0)
            {
                //优惠细则
                [self pushWebConditionDetailWithType:@"1" orderId:self.model.couponId];
            }
        }else
        {
            if(indexPath.row == 0)
            {
                //优惠细则
                [self pushWebConditionDetailWithType:@"1" orderId:self.model.couponId];
                
            }else if(indexPath.row == 1)
            {
                // 所购商品
                TipProdctViewController *vc = [[TipProdctViewController alloc] initWithNibName:@"TipProdctViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                vc.productList = self.model.productList;
                vc.totalPricePro = self.model.totalPrice;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark ---- 跳转到优惠细则 ----

- (void)pushWebConditionDetailWithType:(NSString *)type orderId:(NSString *)orderId
{
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    
    WebCouponConditionModel *modelCondition = [[WebCouponConditionModel alloc] init];
    modelCondition.couponId = StrFromObj(orderId);
    modelCondition.type = StrFromObj(type);
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelCondition = modelCondition;
    modelLocal.typeLocalWeb = WebLocalTypeCouponCondition;
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

#pragma mark ---- UICollectionView 代理 ----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(self.arrPhotos.count+1, kMaxNum);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomImageCollectionViewCell" forIndexPath:indexPath];
    
    cell.btnDelPhoto.tag = indexPath.row;
    cell.btnShowPhoto.tag = indexPath.row;
    cell.btnDelPhoto.hidden = YES;
    cell.deleimage.hidden = YES;
    cell.imgContent.backgroundColor = RGBHex(qwColor11);
    
    if(self.arrPhotos.count > indexPath.row){
        cell.imgContent.contentMode = UIViewContentModeScaleAspectFit;
        if([self.arrPhotos[indexPath.row] isKindOfClass:[NSString class]]){
            [cell.imgContent setImageWithURL:[NSURL URLWithString:self.arrPhotos[indexPath.row]] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
        }else{
            PhotoModel *modelPhoto = self.arrPhotos[indexPath.row];
            cell.imgContent.image = modelPhoto.thumbnail;
        }
        cell.deleimage.hidden = NO;
        cell.btnDelPhoto.hidden = NO;
        [cell.btnShowPhoto removeTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelPhoto addTarget:self
                             action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShowPhoto addTarget:self
                              action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.imgContent.image = [UIImage imageNamed:@"img_addTicket"];
        cell.deleimage.hidden = YES;
        [cell.btnShowPhoto removeTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShowPhoto addTarget:self
                              action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeCell = CGSizeMake((collectionView.frame.size.width-kAutoScale*1) / kMaxNum, collectionView.frame.size.width / kMaxNum);
    return sizeCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(APP_W, 90.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return theView;
    }
    return [[UICollectionReusableView alloc] init];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark ---- 拍照 ----

- (void)addPhoto:(UIButton *)btnShowPhoto
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1) {
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3];
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Sorry,您的设备不支持该功能!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }else if (buttonIndex == 0){
            //相册
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
            PhotoAlbum* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
            //创建的临时数组和相册进行交互
            self.arrTemp=[NSMutableArray array];
            self.httpTemp=[NSMutableArray array];
            for (id mode in self.arrPhotos) {
                if([mode isKindOfClass:[NSString class]]){
                    //服务器上的不存在于相册中
                    [self.httpTemp addObject:mode];
                }else{
                    PhotoModel *model=(PhotoModel*)mode;
                    [self.arrTemp addObject:model];
                }
            }
            //临时数组存入相册中
            [vc selectPhotos:kMaxNum-self.arrPhotos.count+self.arrTemp.count selected:self.arrTemp block:^(NSMutableArray *list) {
                //从相册返回的操作
                [self.arrPhotos removeAllObjects];
                [self.arrPhotos addObjectsFromArray:self.httpTemp];//服务器上的
                [self.arrPhotos addObjectsFromArray:list];//相册的
                [self showAllPickedPhotos];
                
            } failure:^(NSError *error) {
                DebugLog(@"%@",error);
                [vc closeAction:nil];
            }];
            
            UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:^{
            }];
        }else{
            //取消
            return;
        }
}

#pragma mark ---- 相机拍照 ----

- (void)showCamera {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma mark ---- UIImagePicker 代理 ----

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /**
     *1.通过相册和相机获取的图片都在此代理中
     */
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    // 把照片保存到相册，并把照片model保存到数组photos
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *mm=[QYImage cropThumbnail:image];
    
    image = [image imageByScalingToMinSize];
    image = [UIImage scaleAndRotateImage:image];
    
    PhotoModel *mode=[PhotoModel new];
    mode.thumbnail=mm;
    mode.fullImage=image;
    if (self.arrPhotos==nil) {
        self.arrPhotos=[NSMutableArray array];
    }
    [self.arrPhotos addObject:mode];
    [self showAllPickedPhotos];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        
        [PhotosAlbum saveImageToSavePhoto:image resultBlock:^(NSString *url, ALAsset *asset) {
            mode.url=url;
            mode.asset=asset;
        } failure:^(NSError *error) {
        }];
        
    });
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark ---- 删除照片 ----

- (void)delPhoto:(UIButton *)btnDelPhoto
{
    NSInteger indexDel = btnDelPhoto.tag;
    [self.arrPhotos removeObjectAtIndex:indexDel];
    [self showAllPickedPhotos];
    
}

- (void)showPhoto:(UIButton *)btnShowPhoto
{
    NSInteger indexShow = btnShowPhoto.tag;
    self.arrTemp=[NSMutableArray array];
    int i = 1,j = 0;
    
    for (id mode in self.arrPhotos) {
        
         if([mode isKindOfClass:[NSString class]]){
             if(i==indexShow){
                 j=i;
             }
             [self.arrTemp addObject:mode];
             i++;
         }else{
             PhotoModel *model=(PhotoModel*)mode;
             if(i==indexShow){
                 j=i;
             }
             if (model.fullImage)
                 [self.arrTemp addObject:model.fullImage];
             i++;
         }
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoPreView* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoPreView"];
    vc.dontSave=YES;
    vc.arrPhotos = self.arrTemp;
    vc.indexSelected = j;
    
    [self presentViewController:vc animated:YES completion:^{
    }];
}

- (void)showAllPickedPhotos
{
    [self.collectionViewImages reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

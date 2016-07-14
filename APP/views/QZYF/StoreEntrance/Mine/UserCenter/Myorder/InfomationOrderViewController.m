//
//  InfomationOrderViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/20.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "InfomationOrderViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SBJson.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "InfonationTableViewCell.h"
#import "RecieptImageViewController.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"
#import "ManageMyorderViewController.h"
#import "OrderHistoryViewController.h"


@interface InfomationOrderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listArray;
    NSMutableArray *contentArray;
    int cellLickType;
}
- (IBAction)addreceipt:(id)sender;

- (IBAction)sureButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
- (IBAction)deleteImage:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addRecieptbutton;
@property (strong, nonatomic) IBOutlet UIView *sureButtonView;
@property (strong, nonatomic) NSMutableArray    *cacheHTTP;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong,nonatomic)UIImageView *imageViewNetwork;
@property (strong,nonatomic)UIButton *buttonNetwork;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) NSData *selectedImageData;

@end

@implementation InfomationOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection=NO;
    self.view.backgroundColor=RGBHex(qwColor11);
    self.tableView.backgroundColor=RGBHex(qwColor11);
    _cacheHTTP = [NSMutableArray array];
    if (![self.orderBranchclass.inviter isEqualToString:@""]) {
        listArray =[[NSMutableArray alloc]initWithObjects:@"活动标题",@"活动类型",@"活动说明",@"商品名称",@"购买用户",@"推荐人",@"商品单价",@"购买数量",@"订单时间", nil];
        cellLickType=1;
    }else{
        listArray =[[NSMutableArray alloc]initWithObjects:@"活动标题",@"活动类型",@"活动说明",@"商品名称",@"购买用户",@"商品单价",@"购买数量",@"订单时间", nil];
        cellLickType=2;
    }
    contentArray=[NSMutableArray array];
    
    if (self.modeType==1) {
        [self.headImage setImageWithURL:[NSURL URLWithString:self.orderBranchclass.banner] placeholderImage:[UIImage imageNamed:@""]];
        [self.receiptImageView setImageWithURL:[NSURL URLWithString:self.orderBranchclass.receipt] placeholderImage:[UIImage imageNamed:@""]];

        if ( [self.orderBranchclass.receipt isEqualToString:@""]) {
            self.addRecieptbutton.hidden=NO;
            self.receiptImageView.hidden=YES;
//            self.tips.hidden=NO;
        }else{
            self.addRecieptbutton.hidden=YES;
            self.receiptImageView.hidden=NO;
//            self.tips.hidden=YES;
        }
        self.tableView.tableFooterView=self.footView;
    }else{
        
        [self.headImage setImageWithURL:[NSURL URLWithString:self.orderBranchclass.banner] placeholderImage:[UIImage imageNamed:@""]];
        self.tableView.tableFooterView=self.sureButtonView;
    }
    self.tableView.tableHeaderView=self.headView;
    
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (NotiHiddenMyorder==type) {
        self.addRecieptbutton.hidden=NO;
        self.receiptImageView.hidden=YES;
//        self.tips.hidden=NO;
    }
}

- (void)backToPreviousController:(id)sender{
    
    if (self.modeType==2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *viewController = (UIViewController *)obj;
            if ([viewController isKindOfClass:[ManageMyorderViewController class]]) {
                *stop = YES;
                [self.navigationController popToViewController:viewController animated:YES];
            }else if(idx == (self.navigationController.viewControllers.count - 1)){
        [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.title=@"订单详情";
    
//    if(self.addRecieptbutton.hidden==YES){
//        self.tips.hidden=YES;
//    }else{
//        self.tips.hidden=NO;
//    }
    
    if (self.addRecieptbutton.hidden==NO&&self.modeType!=2) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveMyreciept:)];
    }
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getBannerImage:)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    self.receiptImageView.userInteractionEnabled=YES;
    [self.receiptImageView addGestureRecognizer:tapGesture];
    
}
-(void)getBannerImage:(UITapGestureRecognizer *)tapGesture{
    RecieptImageViewController *recieptView=[[RecieptImageViewController alloc]init];
    recieptView.image=self.receiptImageView.image;
    recieptView.idstr=self.orderBranchclass.id;
    [self.navigationController pushViewController:recieptView animated:YES];
}
//绑定小票
-(void)saveMyreciept:(id)sender{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    if (self.addRecieptbutton.hidden==YES) {
        UIImage * image = self.receiptImageView.image;
        if (image) {
            if (!QWGLOBALMANAGER.loginStatus) {
                return;
            }
            self.navigationItem.rightBarButtonItem.enabled=NO;
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
            setting[@"type"] = @(6);
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:self.selectedImageData];
            [[HttpClient sharedInstance]uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
                if (responseObj[@"body"][@"url"]){
                    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
                    dict[@"receiptImgUrl"]=responseObj[@"body"][@"url"];
                    dict[@"order"]=self.orderBranchclass.id;
                    [Order fixRecieptWithParam:dict Success:^(id resultOBJ) {
                        [self showSuccess:@"上传小票成功"];
//                         self.tips.hidden=YES;
                        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            self.navigationItem.rightBarButtonItem.enabled=YES;
                            UIViewController *viewController = (UIViewController *)obj;
                            if ([viewController isKindOfClass:[ManageMyorderViewController class]]) {
                                *stop = YES;
                                [QWGLOBALMANAGER postNotif:NotiMyorderList data:nil object:nil];
                                [self.navigationController popToViewController:viewController animated:YES];
                                
                            }else if ([viewController isKindOfClass:[OrderHistoryViewController class]]){
                                *stop = YES;
                                [QWGLOBALMANAGER postNotif:NotiMyorderList data:nil object:nil];
                                [self.navigationController popToViewController:viewController animated:YES];
                            }else if(idx == (self.navigationController.viewControllers.count - 1)){
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            }
                        }];
                    } failure:^(HttpException *e) {
                    }];
                }
         
            } failure:^(HttpException *e) {
            } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

            }];
        }
    }else{
        [self showError:@"请您先上传小票"];
//        self.tips.hidden=NO;
        return;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark --UItableViewdelegate   dataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierd=@"InfomationCell";
    InfonationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierd];
    if (cell==nil) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"InfonationTableViewCell" owner:self options:nil][0];
    }else{
        cell.productDetail.text = @"";
        cell.productName.text = @"";
        UILabel *lable=(UILabel *)[cell.contentView viewWithTag:1000];
        UILabel *lableTwo=(UILabel *)[cell.contentView viewWithTag:500];
        UILabel *lableThree=(UILabel *)[cell.contentView viewWithTag:100];
        if (lable!=nil||lableTwo!=nil||lableThree!=nil) {
            [lable removeFromSuperview];
            [lableTwo removeFromSuperview];
            [lableThree removeFromSuperview];
        }
    }
    if (self.modeType==1) {
        [cell setCells:self.orderBranchclass andindex:indexPath.row clickType:cellLickType];
    }else{
        [cell setCells:self.orderBranchclass andindex:indexPath.row clickType:cellLickType];
    }
    cell.productName.text=listArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CGSize sizes=[self.orderBranchclass.title boundingRectWithSize:CGSizeMake(200, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
        if (sizes.height+18>35) {
            return sizes.height+18;
        }
    }
    if (indexPath.row==2) {
        CGSize sizes=[self.orderBranchclass.desc boundingRectWithSize:CGSizeMake(200, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
        if (sizes.height+18>35) {
            return sizes.height+26;
        }else{
            return 43;
        }
    }
    if (indexPath.row==3) {
        CGSize sizes=[self.orderBranchclass.proName boundingRectWithSize:CGSizeMake(200, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
        if (sizes.height+18>35) {
            return sizes.height+18;
        }
    }
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addreceipt:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}
- (IBAction)sureButton:(id)sender
{
    PromoteCompleteR *completeR=[PromoteCompleteR new];
    
    completeR.token=QWGLOBALMANAGER.configure.userToken;
    completeR.code=self.orderBranchclass.code;
    
    [Order promotionCompleteWithParam:completeR Success:^(id resultObj) {
        
        PromoteComplete *complete=(PromoteComplete *)resultObj;
        
        if ([complete.apiStatus intValue] == 0){
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"生成订单成功" duration:0.8];
        }else{
            [SVProgressHUD showErrorWithStatus:complete.apiMessage duration:0.8];
        }
    } failure:^(HttpException *e) {
        //全局做了
//        if(e.errorCode!=-999){
//            if(e.errorCode == -1001){
//                [self showError:kWarning215N54];
//            }else{
//                [SVProgressHUD showErrorWithStatus:kWarning215N0 duration:0.8];
//            }
//        }

    }];
    //确定订单
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {//设置头像
        UIImagePickerControllerSourceType sourceType;
        if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 0){
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else if (buttonIndex == 2){
            //取消
            return;
        }
        if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Sorry,您的设备不支持该功能!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*
     *1.通过相册和相机获取的图片都在此代理中
     */
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect bounds = CGRectMake(0, 0, image.size.width / 2, image.size.height / 2);
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    if (self.selectedImageData) {
        self.selectedImageData = nil;
    }
    self.selectedImageData
    = UIImageJPEGRepresentation(image, 0.5);
    self.receiptImageView.hidden=NO;
    self.addRecieptbutton.hidden=YES;
    self.receiptImageView.image=image;
//    self.tips.hidden=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark deleteReciept action
- (IBAction)deleteImage:(id)sender{
    
}


@end

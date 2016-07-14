//
//  CompanyViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CompanyViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SBJson.h"
#import "LeveyPopListView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
#import "SVProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "ZhPMethod.h"
#import "UserInfoModel.h"
#import "StoreModel.h"
#import "Store.h"
#import "StoreModelR.h"
#import "Pharmacy.h"
#import "PharmacyModel.h"

@interface CompanyViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,LeveyPopListViewDelegate,MapViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView   *img_delete;
@property (strong, nonatomic) IBOutlet UIButton      *btn_delete;
@property (strong, nonatomic) IBOutlet UILabel       *lbl_ziNum;
@property (strong, nonatomic) IBOutlet UILabel       *lbl_mapnews;
@property (strong, nonatomic) IBOutlet UITextField   *text_institutionname;
@property (strong, nonatomic) IBOutlet UITextField   *text_institutionadress;
@property (strong, nonatomic) IBOutlet UILabel       *lbl_show;
@property (strong, nonatomic) IBOutlet UIScrollView  *scrollv;
@property (strong, nonatomic) IBOutlet UIButton      *btn_LabelOne;
@property (strong, nonatomic) IBOutlet UIButton      *btn_LabelTwo;
@property (strong, nonatomic) IBOutlet UITextField   *text_tlNum;
@property (strong, nonatomic) IBOutlet UIImageView   *img_logo;
@property (strong, nonatomic) IBOutlet UITextView    *text_des;
@property (strong, nonatomic) IBOutlet UIButton      *btn_province;
@property (strong, nonatomic) IBOutlet UIButton      *btn_city;
@property (strong, nonatomic) IBOutlet UIButton      *btn_area;
@property (strong, nonatomic) IBOutlet UIButton      *btn_map;
@property (strong, nonatomic) IBOutlet UIButton      *btn_LabelThree;

@property (assign, nonatomic) int            type;
@property (assign, nonatomic) BOOL           hasAreaLsit;
@property (assign, nonatomic) BOOL           hasCityLsit;
@property (assign, nonatomic) BOOL           labeloneChose;
@property (assign, nonatomic) BOOL           labeltwoChose;
@property (assign, nonatomic) BOOL           labelthreeChose;
@property (strong, nonatomic) NSString       *provinceNum;
@property (strong, nonatomic) NSString       *cityNum;
@property (strong, nonatomic) NSString       *countryNum;
@property (strong, nonatomic) NSMutableArray *areaList;
@property (strong, nonatomic) NSString       *img_url;
@property (strong, nonatomic) NSString       *longitude;
@property (strong, nonatomic) NSString       *latitude;
@property (assign, nonatomic) NSInteger      res;
@property (strong, nonatomic) UIView         *alertVAddress;
@property (strong, nonatomic) NSMutableArray *tagArr;

- (IBAction)deleteimageAction:(id)sender;
- (IBAction)choseMapAction:(id)sender;
- (IBAction)choseLabelOneAction:(id)sender;
- (IBAction)choseLabeltwoAction:(id)sender;
- (IBAction)getAreaListAction:(id)sender;
- (IBAction)choselabelThreeAction:(id)sender;


@end

@implementation CompanyViewController

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
    self.title = @"机构信息";
    if (self.Listchose == YES) {
        [self setAlertVaddress];
    }
    [self shoptagquery];
    self.tagArr = [NSMutableArray array];
    self.scrollv.scrollEnabled = YES;
    self.scrollv.contentSize = CGSizeMake(320, 750);
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfoAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    // 找ui要白的定位图标
    [self.btn_map setImage:[UIImage imageNamed:@"地图"] forState:UIControlStateNormal];
    
    self.areaList = [NSMutableArray array];
    self.hasAreaLsit = NO;
    self.hasCityLsit = NO;
    //    获取上端省市区的值
    if (self.choseaddress == YES) {
        
        if ([QWUserDefault getObjectBy:REGISTER_JG_AREAINFO]) {
            
            RegisterAreaInfoModel *model = [QWUserDefault getObjectBy:REGISTER_JG_AREAINFO];
            [self.btn_area setTitle:model.country forState:UIControlStateNormal];
            [self.btn_city setTitle:model.city forState:UIControlStateNormal];
            [self.btn_province setTitle:model.province forState:UIControlStateNormal];
        }
    }
    //针对选择logo添加手势
    UITapGestureRecognizer  *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chsoeLogoAction)];
    self.img_logo.userInteractionEnabled = YES;
    [self.img_logo addGestureRecognizer:recognizer];
    
    
    //    根据已经保存的信息,显示内容
    if([QWUserDefault getObjectBy:REGISTER_JG_INSTITUTIONINFO]){
        
        SaveBranchModelR *model = [QWUserDefault getObjectBy:REGISTER_JG_INSTITUTIONINFO];
        
        self.lbl_mapnews.text = model.maplbl;
        self.text_des.text = model.desc;
        if (self.text_des.text.length > 0) {
            self.lbl_show.hidden = YES;
        }
        self.latitude = model.latitude;
        self.longitude = model.longitude;
        
        [self.btn_map setImage:[UIImage imageNamed:@"地图"] forState:UIControlStateNormal];
        
        self.text_institutionadress.text = model.addr;
        self.img_url= model.logo;
        [self.img_logo setImageWithURL:[NSURL URLWithString:model.logo ]placeholderImage:nil];
        if (  self.img_url.length > 0) {
            
            self.btn_delete.hidden = NO;
            self.img_delete.hidden = NO;
        }
        
        self.text_tlNum.text = model.tel;
        self.text_institutionname.text = model.name;
        self.cityNum = model.city;
        self.provinceNum = model.province;
        self.countryNum = model.country;
        [self.btn_area setTitle:model.countryname forState:UIControlStateNormal];
        [self.btn_city setTitle:model.cityname forState:UIControlStateNormal];
        [self.btn_province setTitle:model.provincename forState:UIControlStateNormal];
    }
    
    //    根据选择列表加载数据
    else  if ([QWUserDefault getObjectBy:REGISTER_JG_COMPANYINFO]) {
        
        QueryStoreModel *model = [QWUserDefault getObjectBy:REGISTER_JG_COMPANYINFO];
       
        if (model.latitude && model.longitude) {
            self.longitude = model.latitude;
            self.latitude = model.longitude;
            self.lbl_mapnews.text = [NSString stringWithFormat:@"经度%.2f,纬度%.2f",[self.latitude floatValue],[self.longitude floatValue]];
            [self.btn_map setImage:[UIImage imageNamed:@"地图"] forState:UIControlStateNormal];
            self.provinceNum = model.province;
        }
        if (model.city) {
            self.cityNum = model.city;
        }
        if (model.province) {
            self.provinceNum = model.province;
        }
        if (model.county) {
            self.countryNum = model.county;
        }
        
        if (model.address) {
            self.text_institutionadress.text = model.address;
        }
        if (model.name) {
            self.text_institutionname.text = model.name;
        }
        
        if ([QWUserDefault getObjectBy:REGISTER_JG_AREAINFO]) {
            
            RegisterAreaInfoModel *model = [QWUserDefault getObjectBy:REGISTER_JG_AREAINFO];
            
            [self.btn_area setTitle:model.country forState:UIControlStateNormal];
            [self.btn_city setTitle:model.city forState:UIControlStateNormal];
            [self.btn_province setTitle:model.province forState:UIControlStateNormal];
        }
    }
    [self setUpForDismissKeyboard];
}

#pragma mark ====
#pragma mark ==== MapViewControllerDelegate

- (void)pickUserLocation:(NSDictionary *)location{
    self.longitude = [location objectForKey:@"longitude"];
    self.latitude = [location objectForKey:@"latitude"];
    self.lbl_mapnews.text = [NSString stringWithFormat:@"经度%.2f,纬度%.2f",[self.latitude floatValue],[self.longitude floatValue]];
    [self.btn_map setImage:[UIImage imageNamed:@"地图"] forState:UIControlStateNormal];
}

#pragma mark ====
#pragma mark ==== 设置遮盖层

-(void)setAlertVaddress{
    
    self.alertVAddress = [[UIView alloc] init];
    self.alertVAddress.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
    self.alertVAddress.userInteractionEnabled = YES;
    self.alertVAddress.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *missalert = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(missalert)];
    [self.alertVAddress addGestureRecognizer:missalert];
    
    UIImageView *imageviewone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, self.text_institutionadress.frame.origin.y+40)];
    imageviewone.backgroundColor = [UIColor blackColor];
    imageviewone.alpha = 0.5f;
    
    UIImageView *imageviewtwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.text_institutionadress.frame.origin.y+40,self.text_institutionadress.frame.origin.x,self.text_institutionadress.frame.size.height)];
    imageviewtwo.backgroundColor = [UIColor blackColor];
    imageviewtwo.alpha = 0.5f;
    
    
    UIImageView *imageviewthree = [[UIImageView alloc] initWithFrame:CGRectMake(self.text_institutionadress.frame.origin.x, self.text_institutionadress.frame.origin.y+40,[UIScreen mainScreen].applicationFrame.size.width-self.text_institutionadress.frame.origin.x,self.text_institutionadress.frame.size.height)];
    imageviewthree.image = [ UIImage imageNamed:@"遮罩-图形"];
    
    UIImageView *imageviewfour = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.text_institutionadress.frame.origin.y+self.text_institutionadress.frame.size.height+40,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height-self.text_institutionadress.frame.size.height-self.text_institutionadress.frame.origin.y)];
    imageviewfour.backgroundColor = [UIColor blackColor];
    imageviewfour.alpha = 0.5f;
    
    UIImageView *imageviewfive = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].applicationFrame.size.width,150)];
    imageviewfive.image = [ UIImage imageNamed:@"遮罩-文字"];
    [imageviewfour addSubview:imageviewfive];
    [self.alertVAddress addSubview:imageviewone];
    [self.alertVAddress addSubview:imageviewtwo];
    [self.alertVAddress addSubview:imageviewthree];
    [self.alertVAddress addSubview:imageviewfour];
    [self.view addSubview:self.alertVAddress];
}

//隐藏遮盖层
-(void)missalert{
    self.alertVAddress.hidden = YES;
}

#pragma mark ====
#pragma mark ==== 获取药店标签

-(void)shoptagquery{
   
    NSMutableDictionary *setting =[NSMutableDictionary dictionary];
    [Store SearchTagQueryWithParams:setting success:^(id obj) {
        
        self.tagArr = (NSMutableArray *)obj;
        StoreTagModel *model1 = self.tagArr[0];
        StoreTagModel *model2 = self.tagArr[1];
        StoreTagModel *model3 = self.tagArr[2];
        
        int lengthcount = 0;
        if (self.tagArr.count > 2) {
            lengthcount = 3;
        }
        if (self.tagArr.count > 2) {
            self.btn_LabelOne.hidden = NO;
            self.btn_LabelTwo.hidden = NO;
            self.btn_LabelThree.hidden = NO;
            
            [self.btn_LabelOne setTitle:model1.tag forState:UIControlStateNormal];
            [self.btn_LabelTwo setTitle:model2.tag forState:UIControlStateNormal];
            [self.btn_LabelThree setTitle:model3.tag forState:UIControlStateNormal];
            
        }else if(self.tagArr.count == 2){
            lengthcount= 2;
            self.btn_LabelOne.hidden = NO;
            self.btn_LabelTwo.hidden = NO;
            [self.btn_LabelOne setTitle:model1.tag forState:UIControlStateNormal];
            [self.btn_LabelTwo setTitle:model2.tag forState:UIControlStateNormal];
            self.btn_LabelThree.hidden = YES;
            
        }else if(self.tagArr.count == 1){
            lengthcount = 1;
            [self.btn_LabelOne setTitle:model1.tag forState:UIControlStateNormal];
            self.btn_LabelOne.hidden = NO;
            self.btn_LabelTwo.hidden = YES;
            self.btn_LabelThree.hidden = YES;
            
        }else{
            self.btn_LabelOne.hidden = YES;
            self.btn_LabelTwo.hidden = YES;
            self.btn_LabelThree.hidden = YES;
        }
        
        SaveBranchModelR *saveModel = [QWUserDefault getObjectBy:REGISTER_JG_INSTITUTIONINFO];
        NSString *str= saveModel.tags;
        if (str.length > 0) {
            NSArray *arr = [str componentsSeparatedByString:@"|"];
            for (int i =0 ; i<arr.count;i++) {
                
                for (int j = 0; j<lengthcount; j++) {
                    
                    StoreTagModel *model = self.tagArr[j];
                    if ([model.key isEqualToString:[arr objectAtIndex:i]]) {
                        if (j==0) {
                            self.labeloneChose = YES;
                            [self.btn_LabelOne setBackgroundImage:[UIImage imageNamed:@"药店标签-选中"] forState:UIControlStateNormal];
                            [self.btn_LabelOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];                             }
                        if (j==1) {
                            self.labeltwoChose = YES;
                            [self.btn_LabelTwo setBackgroundImage:[UIImage imageNamed:@"药店标签-选中"] forState:UIControlStateNormal];
                            [self.btn_LabelTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];                             }
                        if (j==2) {
                            self.labelthreeChose = YES;
                            [self.btn_LabelThree setBackgroundImage:[UIImage imageNamed:@"药店标签-选中"] forState:UIControlStateNormal];
                            [self.btn_LabelThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];                             }
                    }
                }
            }
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ====
#pragma mark ==== 点击空白 收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        self.scrollv.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    [self.view endEditing:YES];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:1 animations:^{
        self.lbl_show.hidden = YES;
        self.scrollv.contentOffset = CGPointMake(0, 200);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.text_tlNum) {
        [UIView animateWithDuration:1 animations:^{
            self.scrollv.contentOffset = CGPointMake(0, 100);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    CGFloat length = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
    int len = 50-length;
    self.lbl_ziNum.text = [NSString stringWithFormat:@"%d字",len];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if(self.text_des.text.length > 0){
        self.lbl_show.hidden = YES;
        
    }else{
        self.lbl_show.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text {
    
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 50) {
        textView.text = [temp substringToIndex:50];
        self.lbl_ziNum.text =@"0字";
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_institutionname) {
        [self.text_institutionadress resignFirstResponder];
    }else if (textField == self.text_institutionadress){
        [self.text_des resignFirstResponder];
    }
    return YES;
}

#pragma mark ====
#pragma mark ==== 选择logo方法

-(void)chsoeLogoAction{
    [self.text_des resignFirstResponder];
    [self.text_institutionadress resignFirstResponder];
    [self.text_institutionname resignFirstResponder];
    if (self.btn_delete.hidden == YES) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:(id)self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"我的相册",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }else{
        [SJAvatarBrowser showImage:self.img_logo];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
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
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /**
     *1.通过相册和相机获取的图片都在此代理中
     *
     *2.图片选择已完成,在此处选择传送至服务器
     */
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect bounds = CGRectMake(0, 0, APP_W, APP_W);
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (image) {
        //传到服务器
        NSLog(@"image===%@",image);
        [self.img_logo setImage: image];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @(3);
        setting[@"token"] = @"";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] intValue] == 0) {
                self.img_url = responseObj[@"body"][@"url"];
                self.btn_delete.hidden = NO;
                self.img_delete.hidden = NO;
            }else
            {
                 [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark ====
#pragma mark ==== 保存机构信息

-(void)saveInfoAction{
    
    SaveBranchModelR *saveModel = [SaveBranchModelR new];
    
    if ([QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]) {
        saveModel.account = [QWUserDefault getStringBy:QUICK_REGISTERACCOUNT];
    }
    
    if ([QWUserDefault getStringBy:QUICK_REGISTERACCOUNT].length > 0) {
        saveModel.mobile = [QWUserDefault getStringBy:QUICK_REGISTERACCOUNT];
    }
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_COMPANYINFO]) {
        QueryStoreModel *model = [QWUserDefault getObjectBy:REGISTER_JG_COMPANYINFO];
        saveModel.drugStoreId = model.code;
    }else
    {
        saveModel.drugStoreId = @"";
    }
    
    
    if (self.text_institutionname.text == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入机构名称" duration:DURATION_SHORT];
        return;
        
    }else if([self.text_institutionname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 25){
        [SVProgressHUD showErrorWithStatus:@"机构名称不能大于25个字" duration:DURATION_SHORT];
        return;
    }
    saveModel.name = [self.text_institutionname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.text_institutionadress.text == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入机构地址" duration:DURATION_SHORT];
        return;
    }else if ([self.text_institutionadress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 50){
        [SVProgressHUD showErrorWithStatus:@"机构地址不能大于50个字" duration:DURATION_SHORT];
        return;
    }
    saveModel.addr = [self.text_institutionadress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.provinceNum && self.cityNum ) {
        saveModel.province =self.provinceNum;
        saveModel.city = self.cityNum;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择省市区" duration:DURATION_SHORT];
        return;
    }
    if(self.countryNum){
        saveModel.country = self.countryNum;
    }else{
        saveModel.country = @"";
    }
    if (!self.longitude) {
        [SVProgressHUD showErrorWithStatus:@"请输入地理位置信息" duration:DURATION_SHORT];
        return;
    }
    if (!self.latitude) {
        [SVProgressHUD showErrorWithStatus:@"请输入地理位置信息" duration:DURATION_SHORT];
        return;
    }
//    self.longitude = @"120.567082";
//    self.latitude = @"31.301079";
    saveModel.longitude = self.longitude;
    saveModel.latitude = self.latitude;
    
    if ([QWGLOBALMANAGER isPhoneNumber:[self.text_tlNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
        saveModel.tel = [self.text_tlNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的座机号码" duration:DURATION_SHORT];
        return;
    }
//    saveModel.tel = [self.text_tlNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *tagstr ;
    if (self.labeloneChose == YES)
    {
        StoreTagModel *model0 = self.tagArr[0];
        tagstr = model0.key;
        if (self.labeltwoChose == YES) {
            StoreTagModel *model1 = self.tagArr[1];
            tagstr = [NSString stringWithFormat:@"%@|%@",tagstr,model1.key];
            if (self.labelthreeChose == YES) {
                StoreTagModel *model2 = self.tagArr[2];
                tagstr = [NSString stringWithFormat:@"%@|%@",tagstr,model2.key];
            }
        }else{
            if (self.labelthreeChose == YES) {
                StoreTagModel *model2 = self.tagArr[2];
                tagstr = [NSString stringWithFormat:@"%@|%@",tagstr,model2.key];
            }
        }
    }else{
        if (self.labeltwoChose == YES) {
            StoreTagModel *model1 = self.tagArr[1];
            tagstr = model1.key;
            if (self.labelthreeChose == YES) {
                StoreTagModel *modle2 = self.tagArr[2];
                tagstr = [NSString stringWithFormat:@"%@|%@",tagstr,modle2.key];
            }
        }else{
            if (self.labelthreeChose == YES) {
                StoreTagModel *modle2 = self.tagArr[2];
                tagstr = modle2.key;
            }
        }
    }
    if (!tagstr) {
        tagstr = @"";
    }
    saveModel.tags =tagstr ;
    if (!self.img_url) {
        self.img_url = @"";
    }
    saveModel.logo =  self.img_url;
    if (!self.text_des.text) {
        self.text_des.text = @"";
    }
    saveModel.desc = [self.text_des.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [Store SaveBranchWithParams:saveModel success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            saveModel.maplbl= [self.lbl_mapnews.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            saveModel.cityname = self.btn_city.titleLabel.text;
            saveModel.countryname = self.btn_area.titleLabel.text;
            saveModel.provincename = self.btn_province.titleLabel.text;
            
            [QWUserDefault setObject:saveModel key:REGISTER_JG_INSTITUTIONINFO];
            
            NSDictionary *dic = (NSDictionary *)obj;
            [QWUserDefault setObject:dic key:REGISTER_JG_REGISTERID];
            
            [QWUserDefault setBool:YES key:REGISTER_JG_FINISHCOMPANYINFO];
            
            [self.finishcompanyInfoDelegate finishcompanyInfoDelegate:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }

        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ====
#pragma mark ==== 获取地址列表

- (IBAction)getAreaListAction:(id)sender {
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    if (sender == self.btn_province) {
        self.hasAreaLsit = NO;
    }else if(sender == self.btn_city){
        if(self.provinceNum.length > 0){
            setting[@"code"] = StrFromObj(self.provinceNum);
        }else{
            [SVProgressHUD showErrorWithStatus:@"请选择药店所在省" duration:DURATION_SHORT];
            return;
        }
    }else{
        if(self.cityNum.length > 0){
            setting[@"code"] = StrFromObj(self.cityNum);
        }else{
            [SVProgressHUD showErrorWithStatus:@"请选择药店所在省市" duration:DURATION_SHORT];
            return;
        }
    }
    
    [Pharmacy QueryAreaWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            QueryAreaPage *page = (QueryAreaPage *)obj;
            NSMutableArray *arrname = [NSMutableArray array];
            self.areaList = (NSMutableArray *) page.list;
            for (int i = 0; i< self.areaList.count; i++) {
                
                QueryAreaModel *model = self.areaList[i];
                [arrname addObject:model.name];
            }
            if (sender == self.btn_province) {
                self.type = 1;
                self.hasAreaLsit = NO;
                self.hasCityLsit = NO;
            }else if(sender == self.btn_city){
                self.type = 2;
                
            }else if(sender == self.btn_area){
                self.type = 3;
            }
            LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"" options:arrname];
            popListView.delegate = self;
            [popListView showInView:self.view animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ====
#pragma mark ==== LeveyPopListView delegates

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    QueryAreaModel *model = self.areaList[anIndex];
    if (self.type == 1) {
        if (![self.btn_province.titleLabel.text isEqualToString:model.name]) {
            [self.btn_city setTitle:@"选择市" forState:UIControlStateNormal];
            [self.btn_area setTitle:@"选择区/县" forState:UIControlStateNormal];
            self.cityNum = @"";
            self.countryNum = @"";
        }
        [self.btn_province setTitle:model.name forState:UIControlStateNormal];
        self.provinceNum = model.code;
        self.btn_city.enabled = YES;
    }else if(self.type == 2){
        if (![self.btn_city.titleLabel.text isEqualToString:model.name]) {
            [self.btn_area setTitle:@"选择区/县" forState:UIControlStateNormal];
            self.countryNum = @"";
        }
        
        [self.btn_city setTitle:model.name forState:UIControlStateNormal];
        self.cityNum = model.code;
        self.btn_area.enabled = YES;
    }else{
        self.countryNum = model.code;
        [self.btn_area setTitle:model.name forState:UIControlStateNormal];
    }
}

- (void)leveyPopListViewDidCancel
{
    
}

#pragma mark ====
#pragma mark ==== 选择地图界面,选择经纬度

- (IBAction)choseMapAction:(id)sender {
    MapViewController *mapVC = [[MapViewController alloc] init];
    
    if (self.longitude && self.latitude && self.text_institutionname.text) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"longitude"] = self.longitude;
        dic[@"title"] = self.text_institutionname.text;
        dic[@"latitude"] = self.latitude;
        mapVC.userLocationDic = dic;
    }
    mapVC.delegate =self;
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark ====
#pragma mark ==== 选择标签

- (IBAction)choseLabelOneAction:(id)sender {
    if (self.labeloneChose == YES) {
        self.labeloneChose = NO;
        [self.btn_LabelOne setBackgroundImage:[UIImage imageNamed:@"药店标签"] forState:UIControlStateNormal];
        [self.btn_LabelOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.labeloneChose = YES;
        [self.btn_LabelOne setBackgroundImage:[UIImage imageNamed:@"药店标签-选中"] forState:UIControlStateNormal];
        [self.btn_LabelOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)choseLabeltwoAction:(id)sender {
    if (self.labeltwoChose == YES) {
        self.labeltwoChose = NO;
        [self.btn_LabelTwo setBackgroundImage:[UIImage imageNamed:@"药店标签"] forState:UIControlStateNormal];
        [self.btn_LabelTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.labeltwoChose = YES;
        [self.btn_LabelTwo setBackgroundImage:[UIImage imageNamed:@"药店标签-选中"] forState:UIControlStateNormal];
        [self.btn_LabelTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)deleteimageAction:(id)sender {
    if (self.btn_delete.hidden == NO) {
        self.img_logo.image = [UIImage imageNamed:@"添加图片"];
        self.btn_delete.hidden = YES;
        self.img_delete.hidden = YES;
        self.img_url =@"";
    }
}

- (IBAction)choselabelThreeAction:(id)sender {
    if (self.labelthreeChose == YES) {
        self.labelthreeChose = NO;
        [self.btn_LabelThree setBackgroundImage:[UIImage imageNamed:@"药店标签"] forState:UIControlStateNormal];
        [self.btn_LabelThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.labelthreeChose = YES;
        [self.btn_LabelThree setBackgroundImage:[UIImage imageNamed:@"药店标签-选中"] forState:UIControlStateNormal];
        [self.btn_LabelThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
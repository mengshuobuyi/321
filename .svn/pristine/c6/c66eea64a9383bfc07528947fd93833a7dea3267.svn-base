//
//  RecieptImageViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/21.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "RecieptImageViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"

@interface RecieptImageViewController ()<UIScrollViewDelegate>
{
    CGPoint imageCenter;
}
@property (nonatomic, strong) UIScrollView      *scrollView;


@property (weak, nonatomic) IBOutlet UIImageView *recieptImageView;


@end

@implementation RecieptImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGSize size=self.image.size;
    CGFloat imageH=APP_W*size.height/size.width;
    self.recieptImageView.frame = CGRectMake(0, (APP_H-NAV_H-imageH)/2, APP_W, imageH);
    self.recieptImageView.image=self.image;
    imageCenter=self.recieptImageView.center;
    UIPinchGestureRecognizer *pinchGestrue=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImage:)];
    self.recieptImageView.userInteractionEnabled=YES;
    [self.recieptImageView addGestureRecognizer:pinchGestrue];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"删除我的订单.png"] style:UIBarButtonItemStylePlain target:self action:@selector(delAceipt:)];
}

-(void)delAceipt:(id)sender{
    
//    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
//        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
//        return;
//    }
//    DelreceiptsR *receiptR=[DelreceiptsR new];
//    receiptR.order=self.idstr;
//    [Order DelreceiptWithParams:receiptR success:^(id resultObj) {
//        Delreceipts *receipts=resultObj;
//            [QWGLOBALMANAGER postNotif:NotiMyorderList data:nil object:nil];
//            [QWGLOBALMANAGER postNotif:NotiHiddenMyorder data:nil object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(HttpException *e) {
//    }];
}
-(void)panView:(UIPanGestureRecognizer*)pan
{
    CGPoint point1=[pan translationInView:pan.view];
    CGPoint temp=self.recieptImageView.center;
    temp.x+=point1.x;
    temp.y+=point1.y;
    self.recieptImageView.center=temp;
    if (temp.x<0||temp.x>APP_W||temp.y<0||temp.y>APP_H) {
        self.recieptImageView.center=imageCenter;
    }else{
    [pan setTranslation:CGPointZero inView:pan.view];
    }
}
-(void)scaleImage:(UIPinchGestureRecognizer *)pinchGestrue{
  
    pinchGestrue.view.transform = CGAffineTransformScale(pinchGestrue.view.transform, pinchGestrue.scale, pinchGestrue.scale);
    pinchGestrue.scale = 1;
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

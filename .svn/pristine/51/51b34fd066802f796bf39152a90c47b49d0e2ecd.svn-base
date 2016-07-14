//
//  MyQRCodeInfoViewController.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyQRCodeInfoViewController.h"
#import "QRCodeGenerator.h"
#import "UIImageView+WebCache.h"
#import "RecommendationListViewController.h"

//#import "MyRecommendationViewController.h"
//#import "MyRecommendMedicineViewController.h"

@interface MyQRCodeInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *containterView;

@property (weak, nonatomic) IBOutlet UIView *qrImageBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation MyQRCodeInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的二维码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBHex(qwColor11);
    self.qrImageBackgroundView.backgroundColor = RGBHex(qwColor10);
    self.qrImageView.backgroundColor = [UIColor whiteColor];
    self.containterView.layer.masksToBounds = YES;
    self.containterView.layer.cornerRadius = 4;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的推荐" style:UIBarButtonItemStyleDone target:self action:@selector(gotoMyRecommendationVC:)];
    
    self.qrImageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"quanwei_%@", self.phoneNumber] imageSize:self.qrImageView.frame.size.height Topimg:nil];
    
    self.nameLabel.text = self.nickName;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = CGRectGetHeight(self.headImageView.frame)/2;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:self.headImageURL] placeholderImage:[UIImage imageNamed:@"img_pharmacy"]];
}

- (void)UIGlobal
{
    self.nameLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.nameLabel.textColor = RGBHex(qwColor6);
    
    self.tipLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.tipLabel.textColor = RGBHex(qwColor7);
}

- (void)gotoMyRecommendationVC:(id)sender
{
    RecommendationListViewController* recommendtionListVC = [[RecommendationListViewController alloc] init];
    recommendtionListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendtionListVC animated:YES];
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

//
//  ForumHomeViewController.m
//  APP
//
//  Created by Martin.Liu on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ForumHomeViewController.h"
#import "ConstraintsUtility.h"
#import "HotPostViewController.h"           // 热议页面
#import "CarePharmacistViewController.h"    // 专家页面

@interface ForumHomeViewController ()
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_underLineCenterX;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *containerView1;
@property (strong, nonatomic) IBOutlet UIView *containerView2;

// 热议按钮行为
- (IBAction)hotPostBtnAction:(id)sender;
// 药师按钮行为
- (IBAction)pharmacistBtnAction:(id)sender;

@end

@implementation ForumHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView addObserver:self  forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
//    self.scrollView.scrollEnabled = NO;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        float p = point.x / self.scrollView.bounds.size.width;
        self.constraint_underLineCenterX.constant = p*CGRectGetWidth(self.navigationItem.titleView.frame)/2;
    }
}

- (void)UIGlobal
{
    self.navigationItem.titleView = self.titleView;
    
    HotPostViewController* hotPostVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"HotPostViewController"];
    [self addChildViewController:hotPostVC];
    [self.containerView1 addSubview:hotPostVC.view];
    
    CarePharmacistViewController* carePharmacisVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"CarePharmacistViewController"];
    [self addChildViewController:carePharmacisVC];
    [self.containerView2 addSubview:carePharmacisVC.view];
    
    PREPCONSTRAINTS(hotPostVC.view);
    ALIGN_TOPLEFT(hotPostVC.view, 0);
    ALIGN_BOTTOMRIGHT(hotPostVC.view, 0);
    
    PREPCONSTRAINTS(carePharmacisVC.view);
    ALIGN_TOPLEFT(carePharmacisVC.view, 0);
    ALIGN_BOTTOMRIGHT(carePharmacisVC.view, 0);
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

- (IBAction)hotPostBtnAction:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
}

- (IBAction)pharmacistBtnAction:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
}
@end

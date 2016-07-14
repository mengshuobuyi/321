//
//  CheckPostViewController.m
//  APP
//
//  Created by qw_imac on 16/1/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CheckPostViewController.h"
#import "WebDirectViewController.h"
@interface CheckPostViewController ()

@end

@implementation CheckPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    float scale = APP_W /320;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15 * scale, 30 * scale, APP_W, 20)];
    label1.textColor = RGBHex(qwColor7);
    label1.font = fontSystem(kFontS1);
    label1.text = [NSString stringWithFormat:@"快递名称: %@",_postName];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15 * scale, 55 * scale, APP_W, 20)];
    label2.textColor = RGBHex(qwColor7);
    label2.font = fontSystem(kFontS1);
    label2.text = [NSString stringWithFormat:@"运单编号: %@",_postNumber];
    
    UIButton *check = [[UIButton alloc]initWithFrame:CGRectMake(15 * scale, 100 * scale, APP_W - 30*scale, 30)];
    check.layer.cornerRadius = 5.0;
    check.layer.masksToBounds = YES;
    [check setTitle:@"查看物流" forState:UIControlStateNormal];
    [check setBackgroundColor:RGBHex(qwColor2)];
    [check setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [check addTarget:self action:@selector(checkPost) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:check];
}

-(void)checkPost {
    WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
    modelLocal.typeLocalWeb = WebLocalTypeCheckPost;
    modelLocal.typeTitle = WebTitleTypeNone;
//    @"http://m.kuaidi.com/all/%@/%@.html"
    NSString *str = [NSString stringWithFormat:@"http://m.kuaidi.com/all/%@/%@.html",_postName,_postNumber];
    modelLocal.url = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [vcWebMedicine setWVWithLocalModel:modelLocal];
    [self.navigationController pushViewController:vcWebMedicine animated:YES];
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

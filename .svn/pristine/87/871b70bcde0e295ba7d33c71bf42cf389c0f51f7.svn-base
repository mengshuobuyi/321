//
//  test2.m
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "test2.h"
#import "test3.h"
@interface test2 ()

@end

@implementation test2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self showLoading];
//    DebugLog(@"%@",HUD);
}

- (void)UIGlobal{
    [super UIGlobal];
    
    [btnPopVC setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    [btnPopVC setTitleColor:RGBAHex(qwColor4, 0.85) forState:UIControlStateHighlighted];
    btnPopVC.titleLabel.font=font(kFont4, kFontS6);
    
    btnPopVC.layer.borderWidth=1.f;
    btnPopVC.layer.borderColor=RGBHex(qwColor1).CGColor;
    btnPopVC.layer.cornerRadius=4;
    
    [btnTest3 setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    [btnTest3 setTitleColor:RGBAHex(qwColor4, 0.85) forState:UIControlStateHighlighted];
    btnTest3.titleLabel.font=font(kFont4, kFontS6);
    
    btnTest3.layer.borderWidth=.5f;
    btnTest3.layer.borderColor=RGBHex(qwColor1).CGColor;
    btnTest3.layer.cornerRadius=4;
    [btnTest3 addTarget:self action:@selector(test3Action:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)test3Action:(id)sender{
//    [self showLoading];
//    [self didLoad];
//    return;
    
    test3 *vc=[[test3 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegatePopVC=self.delegatePopVC;
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
     DebugLog(@"hudWasHidden:%@",HUD);
}
@end

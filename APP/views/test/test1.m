//
//  test1.m
//  APP
//
//  Created by Yan Qingyang on 15/2/14.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "test1.h"

#import "ZYQAssetPickerController.h"
//#import "mbr.h"

//#import "Drug.h"
//#import "HealthinfoModel.h"
//#import "MbrModel.h"
//#import "Login.h"
//#import "Problem.h"
//#import "ProblemModelR.h"


@interface test1 ()

@end

@implementation test1

- (void)viewDidLoad {
    [super viewDidLoad];
//    [DrugList queryDefaultProductWithParam:@{@"currPage":@1,@"pageSize":@10} success:^(id UFModel) {
//        DurgListModel *model = UFModel;
//        barCodeModel *bar = [model.data objectAtIndex:0];
//        DebugLog(@"finally ===== > %@",bar.sid);
//    } failure:^(HttpException *e) {
//        
//    }];
//    [Drug queryProductClassSuccess:^(id DFUserModel) {
//        
//    } failure:^(HttpException *e) {
//        
//    }];
    
//    mbrLogin *parm=[mbrLogin new];
//    parm.account=@"18550472916";
//    parm.password=@"123456";
////
//    parm.deviceCode=@"12345";
//    parm.device=@"2";
////    dd=[self check:dd];
////    [self showLog:@"123456",nil];
//  

//    DebugLog(@"%@",[parm dictionaryModel]);
    
//    ProblemListModelR *model = [ProblemListModelR new];
//    model.classId = @"0e12394b1045a948e050007f01003f33";
//    model.currPage = @"1";
//    model.pageSize = @"10";
//    
////    DebugLog(@"测试array: %@",[model dictionaryModel]);
//    [Problem listWithParams:model success:^(id obj) {
//        ProblemListPage *page = obj;
//        DebugLog(@"Problem : %@",[page description]);
//        
//    } failure:^(HttpException *e) {
//        
//    }];
    
//    [self showLoading];
//    DebugLog(@"%@",HUD);
}

/**
 *  在UIGlobal配置页面配色及字体样式
 */
- (void)UIGlobal{
    [super UIGlobal];
    
    [btnWelcome setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    [btnWelcome setTitleColor:RGBAHex(qwColor4, 0.85) forState:UIControlStateHighlighted];
    btnWelcome.titleLabel.font=font(kFont4, kFontS2);
    
    btnWelcome.layer.borderWidth=.5f;
    btnWelcome.layer.borderColor=RGBHex(qwColor1).CGColor;
    btnWelcome.layer.cornerRadius=4;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([[segue destinationViewController] isKindOfClass:[test2 class]]) {}
//    NSLog(@"%@",[segue destinationViewController] );
    if ([[segue destinationViewController] respondsToSelector:@selector(setDelegatePopVC:)]) {
        [[segue destinationViewController] setDelegatePopVC:self];
    }
}

#pragma mark 全局通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
//    [super getNotifType:type data:data target:obj];
//    if (type==NotifMessageNeedUpdate)
//    {
//        if ([QWGLOBALMANAGER object:data isClass:[HealthinfoAdvicel class]]) {
//            HealthinfoAdvicel *mod=(HealthinfoAdvicel*)data;
//            DebugLog(@"%@",[mod description]);
//        }
//    }
//    
//    if (type==NotifMessageOfficial)
//        DebugLog(@"NotifMessageOfficial:%i,%@,%@",type,data,obj);
}


@end

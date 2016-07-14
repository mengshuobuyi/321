//
//  QWPageRedirectExt.m
//  APP
//
//  Created by PerryChen on 8/20/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWPageRedirectExt.h"
#import "WebDirectViewController.h"
#import "WebDirectModel.h"


//#import "DiseaseDetailViewController.h"
//#import "CommonDiseaseDetailViewController.h"
//#import "QuestionListViewController.h"
//#import "DiseaseMedicineListViewController.h"

@implementation QWPageRedirectExt
-(void)startSkipApp:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    
    NSLog(@"teh str params is %@",options);
    
    WebDirectViewController *vcWeb = (WebDirectViewController *)(self.webView.delegate);
    
    WebDirectModel *modelDir = [WebDirectModel parse:options Elements:[WebDirectParamsModel class] forAttribute:@"params"];

    if ([modelDir.jumpType intValue] == WebDirTypeH5toH5)
    {
        [vcWeb jumpToH5Page:modelDir];
    } else if ([modelDir.jumpType intValue] == WebDirTypeH5toLocal)
    {
        [vcWeb jumpToLocalVC:modelDir];
    }
}

@end

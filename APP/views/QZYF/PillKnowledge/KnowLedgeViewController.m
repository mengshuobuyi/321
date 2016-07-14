//
//  KnowLedgeViewController.m
//  wenyao
//
//  Created by Meng on 14-9-29.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "KnowLedgeViewController.h"
#import "ZhPMethod.h"

@interface KnowLedgeViewController ()

@end

@implementation KnowLedgeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
       self.title = @"用药小知识";
    [self initView];
}

- (void)initView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H)];
    scrollView.backgroundColor = [UIColor whiteColor];

    NSString * title = [QWGLOBALMANAGER replaceSpecialStringWith:self.knowledgeTitle];
//    CGSize titleSize = getTempTextSize(title, fontSystem(kFontS1), APP_W-20);
    
    UITextView * titleLabel = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, APP_W, [self height:fontSystem(kFontS1) withtext:title])];
    titleLabel.editable = NO;
    titleLabel.font = fontSystem(kFontS2);
    titleLabel.textColor =RGBHex(qwColor6);
    titleLabel.text = title;
    [scrollView addSubview:titleLabel];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 8, APP_W-20, 0.5)];
    line1.backgroundColor = RGBHex(qwColor10);
    [scrollView addSubview:line1];
    NSString * content = [QWGLOBALMANAGER replaceSpecialStringWith:self.knowledgeContent];
    
//    CGSize size = getTempTextSize(content, fontSystem(kFontS4), APP_W-20);
    UITextView * contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, line1.frame.origin.y + line1.frame.size.height + 5, APP_W-20, [self height:fontSystem(kFontS4) withtext:content])];
    contentLabel.textColor = RGBHex(qwColor7);
//    contentLabel.numberOfLines = 0;
    contentLabel.editable = NO;
    contentLabel.font =fontSystem(kFontS4);
    contentLabel.text = content;
    [scrollView addSubview:contentLabel];
    
//    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(10, contentLabel.frame.origin.y + contentLabel.frame.size.height + 8, APP_W-20, 0.5)];
//    line2.backgroundColor = [UIColor grayColor];
//    [scrollView addSubview:line2];
    
    
    [self.view addSubview:scrollView];
}

- (float)height:(UIFont *)font withtext:(NSString *)text
{
    text = [QWGLOBALMANAGER replaceSpecialStringWith:text];
    UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, APP_W-20, 5000)];
    t.font = font;
    t.textContainer.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    t.text = text;
    [t sizeToFit];
    return t.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

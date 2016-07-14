//
//  FinderQuestionDetailViewController.m
//  APP
//
//  Created by 李坚 on 16/1/14.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "FinderQuestionDetailViewController.h"

@interface FinderQuestionDetailViewController (){
    
    NSInteger kfont;
}
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation FinderQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"问答详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Aa" style:UIBarButtonItemStylePlain target:self action:@selector(fontChange:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    kfont = 14;
    if(_model){
        self.questionLabel.text = _model.question;
        self.answerLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:_model.answer];
    }
}

- (void)fontChange:(id)sender{
    
    if(kfont == 18){
        kfont = 14;
    }else{
        kfont += 2;
    }
    
    self.questionLabel.font = fontSystem(kfont);
    self.answerLabel.font = fontSystem(kfont);
    [self.view layoutIfNeeded];
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

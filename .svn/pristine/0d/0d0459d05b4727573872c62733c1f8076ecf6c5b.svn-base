//
//  HealthQADetailViewController.m
//  wenyao-store
//
//  Created by chenzhipeng on 4/3/15.
//  Copyright (c) 2015 xiezhenghong. All rights reserved.
//

#import "HealthQADetailViewController.h"
#import "AppDelegate.h"
#import "QALibrary.h"
#import "QALibraryModel.h"
#import "QALibraryModelR.h"
#import <CoreSpotlight/CoreSpotlight.h>
@interface HealthQADetailViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblResultTitle;
@property (weak, nonatomic) IBOutlet UITextView *tvResultContent;
@property (weak, nonatomic) IBOutlet UITextView *tvResultTitle;

@end

@implementation HealthQADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"问答详情";
    self.lblResultTitle.text = self.questionTitle;

    self.tvResultContent.textContainer.lineFragmentPadding = 0;
    self.tvResultContent.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.tvResultTitle.textContainer.lineFragmentPadding = 0;
    self.tvResultTitle.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [self queryQADetail];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (iOSv9) {
        NSUserActivity *actUser = [self getActivity];
        actUser.eligibleForSearch = YES;
        // 不与 core spotlight进行联系，所以传nil
        actUser.contentAttributeSet.relatedUniqueIdentifier = nil;
        self.userActivity = actUser;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// 当程序处于UIResponder的生命周期内，会不断的调用这个方法更新Index
- (void)updateUserActivityState:(NSUserActivity *)activity
{
    [activity addUserInfoEntriesFromDictionary:@{@"id":self.questionID,
                                                 @"type":APP_SEARCH_ACTIVITY_HEALTHQA}];
}

- (NSUserActivity *)getActivity
{
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:APP_SEARCH_ACTIVITY_KEY];
    activity.title = self.questionTitle;
    activity.userInfo = @{@"id":self.questionID,
                          @"type":APP_SEARCH_ACTIVITY_HEALTHQA};
    activity.keywords = [NSSet setWithObjects:self.questionTitle, nil];
    return activity;
}
#pragma mark - view model methods
- (void)queryQADetail
{
    QALibraryDetailModelR *modelR = [[QALibraryDetailModelR alloc] init];
    modelR.questionId = self.questionID;
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [QALibrary getQALibraryDetailWithParams:modelR success:^(id obj) {
        QALibraryResultDetailModel *model = (QALibraryResultDetailModel *)obj;
        if (model != nil) {
//            self.lblResultTitle.text = model.question;
            self.tvResultTitle.text = model.question;
            NSString *strAnswer = [QWGLOBALMANAGER replaceSpecialStringWith:model.answer];
            self.tvResultContent.text = strAnswer;
        }
    } failure:^(HttpException *e) {
        
    }];
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

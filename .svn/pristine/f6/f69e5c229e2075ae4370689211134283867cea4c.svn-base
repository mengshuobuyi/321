//
//  MemberSelectReusableView.h
//  wenYao-store
//
//  Created by PerryChen on 5/9/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol memberSelectReuseDelegate <NSObject>

- (void)chooseGender:(NSInteger)intGender;
- (void)chooseOrderNum;

@end

@interface MemberSelectReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *viewStepOne;
@property (weak, nonatomic) IBOutlet UIView *viewStepTwo;

@property (weak, nonatomic) IBOutlet UILabel *lblMemberSelect;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewAllGender;
@property (weak, nonatomic) IBOutlet UIView *viewAllGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewMale;
@property (weak, nonatomic) IBOutlet UIView *viewMale;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewFemale;
@property (weak, nonatomic) IBOutlet UIView *viewFemale;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;

@property (weak, nonatomic) id<memberSelectReuseDelegate> delegate;

- (IBAction)allGenderAction:(UIButton *)sender;
- (IBAction)maleSelectAction:(UIButton *)sender;
- (IBAction)femaleSelectAction:(UIButton *)sender;
- (IBAction)selectOrderNumAction:(UIButton *)sender;

@end

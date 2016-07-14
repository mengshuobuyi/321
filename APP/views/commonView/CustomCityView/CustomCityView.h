//
//  CustomCityView.h
//  wenYao-store
//
//  Created by YYX on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCityViewDelegaet <NSObject>

- (void)getProvinceAndCityAction:(NSString *)str provinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode;

@end

@interface CustomCityView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

+ (CustomCityView *)sharedManager;

@property (assign , nonatomic) id<CustomCityViewDelegaet> delegate;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@property (strong, nonatomic) NSMutableArray *cityArray;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bg;

- (IBAction)makeSureAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

-(void)show;

-(void)hidden;

@end

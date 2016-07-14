//
//  CustomInternalProductSubmitCategoryView.m
//  wenYao-store
//
//  Created by PerryChen on 6/14/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "CustomInternalProductSubmitCategoryView.h"
#import "InternalProductModel.h"
@interface CustomInternalProductSubmitCategoryView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{

}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *arrData;
@end
@implementation CustomInternalProductSubmitCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.arrData = @[];
}

- (IBAction)actionCancel:(id)sender {
    self.blockCancel();
    [self removeFromSuperview];
}
- (IBAction)actionConfirm:(id)sender {
    self.blockConfirm([self.pickerView selectedRowInComponent:0]);
    [self removeFromSuperview];
}

- (void)reloadPickerViewData:(NSArray *)arrDatasource
{
    self.arrData = arrDatasource;
    [self.pickerView reloadComponent:0];
}

#pragma mark - UIPickerView methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrData.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    InternalProductCateModel *model = self.arrData[row];
    NSString *strTitle = @"";
    if (model.isRecommend == YES) {
        strTitle = [NSString stringWithFormat:@"推荐分类：%@",model.name];
    } else {
        strTitle = model.name;
    }
    return strTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end

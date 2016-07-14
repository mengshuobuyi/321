//
//  FinderSearchViewController.h
//  APP
//
//  Created by 李坚 on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWSearchBaseVC.h"

@interface FinderSearchViewController : QWSearchBaseVC

@property (nonatomic ,strong) NSString *searchWord;


@end

//症状和疾病
@interface DiseaseHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *diseaseName;
@property (weak, nonatomic) IBOutlet UILabel *diseaseDesc;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Layout;
+ (DiseaseHeadView *)getView;
@end
//药品
@interface MedicineHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *medicintBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Layout;
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *porperty;
@property (weak, nonatomic) IBOutlet UILabel *spec;
@property (weak, nonatomic) IBOutlet UILabel *purpose;
+ (MedicineHeadView *)getView;
@end
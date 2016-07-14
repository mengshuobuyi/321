//
//  EditAddressViewController.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Address.h"
typedef void(^SelectAddress)(NSString *addressStr); //选择地址将地址返回H5
typedef NS_ENUM(NSInteger,AddressPageType) {
    AddressPageTypeAdd,     //添加地址
    AddressPageTypeEdit,    //编辑地址
};
@interface SetCellModel : NSObject
@property(nonatomic,strong) NSString    *cellIdentifier;
@property(nonatomic,assign) CGFloat     cellHeight;
@property(nonatomic,strong) id          dataModel;
@end

@interface EditAddressViewController : QWBaseVC
@property (nonatomic,assign) AddressPageType pageType;
@property (nonatomic,strong) EmpAddressVo    *EmpAddressModel;
@property (nonatomic,copy)SelectAddress      addressBlock;
@property (nonatomic,assign) NSInteger       pageFrom;
@end

//
//  InternalProductDetailViewController.h
//  wenYao-store
//
//  Created by PerryChen on 3/8/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "InternalProduct.h"

typedef void(^updateProductModelBlock)(InternalProductModel *productModel);

@interface InternalProductDetailViewController : QWBaseVC
@property (nonatomic, strong) NSString *proId;          // 商品id
@property (nonatomic, strong) InternalProductModel *productModel;
@property (nonatomic, copy)   updateProductModelBlock   updateModelBlock;
@end

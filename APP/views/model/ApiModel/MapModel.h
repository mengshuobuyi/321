//
//  MapModel.h
//  wenYao-store
//
//  Created by Meng on 15/3/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface MapModel : BaseModel

@end


@interface QueryAreaListModel : MapModel

@property (nonatomic ,strong) NSArray *list;

@end


@interface AreaListModel : MapModel

@property (nonatomic ,strong) NSString *code;
@property (nonatomic ,strong) NSString *name;

@end


@interface AreaCodeModel : MapModel

@property (nonatomic ,strong) NSString *provinceCode;

@end
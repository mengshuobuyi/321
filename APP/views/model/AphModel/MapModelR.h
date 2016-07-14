//
//  MapModelR.h
//  wenYao-store
//
//  Created by Meng on 15/3/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface MapModelR : BaseModel

@end

@interface GetAreaCodeModelR : MapModelR

@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *province;
@property (nonatomic ,strong) NSString *county ;

@end


@interface UpdateBranchLatModelR : MapModelR

@property (nonatomic ,strong) NSString *groupId;
@property (nonatomic ,strong) NSString *longitude;
@property (nonatomic ,strong) NSString *latitude  ;

@end
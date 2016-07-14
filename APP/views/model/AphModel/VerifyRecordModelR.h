//
//  VerifyRecordModelR.h
//  wenYao-store
//
//  Created by PerryChen on 6/21/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseModel.h"

@interface VerifyRecordModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;
@end

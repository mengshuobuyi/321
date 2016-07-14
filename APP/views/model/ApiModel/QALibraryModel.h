//
//  QALibraryModel.h
//  wenyao-store
//
//  Created by chenzhipeng on 4/3/15.
//  Copyright (c) 2015 xiezhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAPIModel.h"

@interface QALibraryModel : BaseAPIModel

@end

//@interface QALibraryCountListModel : QALibraryModel
//@property (nonatomic, strong) NSArray *list;
//@end
//
//@interface QALibraryCountModel : QALibraryModel
//@property (nonatomic, strong) NSString *count;
//@property (nonatomic, strong) NSString *healthyId;
//@property (nonatomic, strong) NSString *tagName;
//@property (nonatomic, strong) NSString *tagUrl;
//@end

@interface QALibraryQuestionClassifyListModel : QALibraryModel
@property (nonatomic, strong) NSArray *list;
@end

@interface QALibraryQuestionClassifyModel : QALibraryModel
@property (nonatomic, strong) NSString *classifyName;
@property (nonatomic, strong) NSString *totalNum;
@property (nonatomic, strong) NSString *imageUrl;
@end

@interface QALibraryHIQuestionListModel : QALibraryModel
@property (nonatomic, strong) NSArray *list;
@end

@interface QALibraryHIQuestionModel : QALibraryModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *answerId;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSArray *hlPositions;
@end

@interface QALibraryHIPositionsModel : QALibraryModel
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *length;
@end

//@interface QALibraryResultRootModel : QALibraryModel
//@property (nonatomic, strong) NSArray *list;
//@end
//
//@interface QALibraryResultListModel : QALibraryModel
//@property (nonatomic, strong) NSString *healthyId;
//@property (nonatomic, strong) NSString *question;
//@property (nonatomic, strong) NSString *questionId;
//@end

@interface QALibraryResultDetailModel : QALibraryModel
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;
@end

@interface QALibrarySearchResultModel : BaseModel
@property (nonatomic, strong) NSString *quizStr;
@end

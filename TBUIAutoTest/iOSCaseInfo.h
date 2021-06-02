//
//  iOSCaseInfo.h
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/31.
//

#import <Foundation/Foundation.h>
#import "iOSHookInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface iOSCaseInfo : NSObject

@property(nonatomic, strong) NSMutableArray<iOSHookInfo*> *hookInfoArr;
@property(nonatomic, strong) NSString *caseName;
@property(nonatomic, strong) NSString *caseId;

@end

NS_ASSUME_NONNULL_END

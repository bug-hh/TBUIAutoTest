//
//  iOSCaseInfo.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/31.
//

#import "iOSCaseInfo.h"

@implementation iOSCaseInfo

- (NSString *)description
{
    NSArray *arr = @[@"hookInfoArr", @"caseName", @"caseId"];
    return [[self dictionaryWithValuesForKeys:arr] description];
}
@end

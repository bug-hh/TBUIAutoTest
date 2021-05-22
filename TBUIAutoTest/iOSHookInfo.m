//
//  iOSHookInfo.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/19.
//

#import "iOSHookInfo.h"

@implementation iOSHookInfo

- (NSString *)description
{
    NSArray *arr = @[@"xcID", @"xcLabel", @"appCompName", @"appSuperViewCompName", @"appUserOperation", @"appOperationName", @"appCompText", @"appCompHint", @"hookMethodName"];
    return [[self dictionaryWithValuesForKeys:arr] description];
    
}



@end

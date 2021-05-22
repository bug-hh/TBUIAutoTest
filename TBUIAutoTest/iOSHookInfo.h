//
//  iOSHookInfo.h
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface iOSHookInfo : NSObject

//XCTest 属性
@property(nonatomic, strong, nullable) NSString *xcID;
@property(nonatomic, strong, nullable) NSString *xcLabel;

//APP 内控件自有属性
@property(nonatomic, strong, nullable) NSString *appCompName;
@property(nonatomic, strong, nullable) NSString *appSuperViewCompName;
@property(nonatomic, strong, nullable) NSString *appUserOperation;
@property(nonatomic, strong, nullable) NSString *appOperationName;
@property(nonatomic, strong, nullable) NSString *appCompText;
@property(nonatomic, strong, nullable) NSString *appCompHint;
@property(nonatomic, strong, nullable) NSString *hookMethodName;

@end

NS_ASSUME_NONNULL_END

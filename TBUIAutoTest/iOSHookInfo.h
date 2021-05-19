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
@property(nonatomic, strong) NSString *xcID;
@property(nonatomic, strong) NSString *xcLabel;

//APP 内控件自有属性
@property(nonatomic, strong) NSString *appCompName;
@property(nonatomic, strong) NSString *appSuperViewCompName;
@property(nonatomic, strong) NSString *appUserOperation;
@property(nonatomic, strong) NSString *appOperationName;


@end

NS_ASSUME_NONNULL_END

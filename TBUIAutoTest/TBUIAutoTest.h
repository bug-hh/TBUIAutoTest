//
//  TBUIAutoTest.h
//  TBUIAutoTestDemo
//
//  Created by 杨萧玉 on 16/3/4.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kAutoTestUITurnOnKey; // 是否生成 UI 标签
extern NSString * const kAutoTestUILongPressKey; // 是否开启长按弹窗显示 UI 标签

#define ZHDebugEnableAutoUIKey @"ZHDebugEnableAutoUIKey"

@interface TBUIAutoTest : NSObject <UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSMutableArray *hookInfoArr;
@property(nonatomic, strong) NSString *uuidString;

+ (instancetype)sharedInstance;
+ (BOOL)isEnableAutoUI;
+ (NSString*)getUUIDtring;
- (UIAlertController*)getAlert;

@end

@interface NSObject (TBUIAutoTest)

+ (void)swizzleSelector:(SEL)originalSelector withAnotherSelector:(SEL)swizzledSelector;

@end

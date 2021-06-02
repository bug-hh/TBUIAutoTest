//
//  TBUIAutoTest.m
//  TBUIAutoTestDemo
//
//  Created by 杨萧玉 on 16/3/4.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "TBUIAutoTest.h"
#import "iOSCaseInfo.h"
#import <objc/runtime.h>

@import ZHLogger;

NSString * const kAutoTestUITurnOnKey = @"kAutoTestUITurnOnKey";
NSString * const kAutoTestUILongPressKey = @"kAutoTestUILongPressKey";

@implementation TBUIAutoTest

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static TBUIAutoTest *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [TBUIAutoTest new];
    });
    return _instance;
}

- (NSMutableArray *)hookInfoArr {
    if (!_hookInfoArr) {
        _hookInfoArr = [NSMutableArray array];
    }
    return _hookInfoArr;
}

+ (BOOL)isEnableAutoUI {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ZHDebugEnableAutoUIKey];
}

- (UIAlertController*)getAlert {
    //提示框添加文本输入框
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"给你的用例取个名字吧"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //得到文本信息
                                                              for(UITextField *textField in alert.textFields){
                                                                  iOSCaseInfo *caseInfo = [[iOSCaseInfo alloc] init];
                                                                  caseInfo.caseName = textField.text;
                                                                  caseInfo.caseId = self.uuidString;
                                                                  caseInfo.hookInfoArr = self.hookInfoArr;
                                                                  ZHLogInfo(@"用例名：%@", textField.text);
                                                                  ZHLogInfo(@"case info: %@", caseInfo.description);
                                                              }
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             ZHLogInfo(@"用户取消了操作");
                                                             // todo 是否需要取消发送 hook info 给后端？？？
                                                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"用例名";
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
   
    
    return alert;
}

- (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isDescendantOfView:gestureRecognizer.view]) {
        return YES;
    }
    if (![otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end

@implementation NSObject (TBUIAutoTest)

+ (void)swizzleSelector:(SEL)originalSelector withAnotherSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(self,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

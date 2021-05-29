//
//  UITextField+AutoUI.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/18.
//

#import "UITextField+AutoUI.h"
#import "TBUIAutoTest.h"
#import "iOSHookInfo.h"
#import <objc/runtime.h>

@import ZHLogger;
@import ZHCoreZASDK;


@implementation UITextField (AutoUI)

+ (void)doAutoUISwizzling {
    [UITextField swizzleSelector:@selector(becomeFirstResponder) withAnotherSelector:@selector(auto_becomeFirstResponder)];
    [UITextField swizzleSelector:@selector(resignFirstResponder) withAnotherSelector:@selector(auto_resignFirstResponder)];
}

- (BOOL)auto_becomeFirstResponder {
    if (![TBUIAutoTest isEnableAutoUI]) {
        ZHLogInfo(@"没有开启 AutoUI 开关，请到 DebugUI 中开启");
        return [self auto_becomeFirstResponder];
    }
    
    ZHLogInfo(@"hook become responder");
    NSString *selfName = NSStringFromClass([self class]);
    NSString *superViewName = NSStringFromClass([self.superview class]);
    ZHLogInfo(@"class name: %@", selfName);
    ZHLogInfo(@"super view class name: %@", superViewName);
    
    ZABaseContextModel *model = self.zaContextModel;
    // unknown
    if (model.zaUIType == 0) {
//        这种情况下，model 是个空的，打点是空的
    } else if (model.zaUIType == 1) { // button
        // 这种情况下是有打点信息的
        NSString *buttonText = model.detail.view.elementLocation.text;
        NSInteger buttonUIAction = model.zaUIActionType;
        NSInteger buttonUIEvent = model.zaUIEventType;
        
    }
    
    iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
    
    if ([self isKindOfClass:UITextField.class]) {
        UITextField *temp = (UITextField*)self;
        NSString *xcID = temp.accessibilityIdentifier;
        NSString *xcLabel = temp.accessibilityLabel;
        ZABaseContextModel *model = temp.zaContextModel;
        
        if (model.detail.hasView) {
            ZHLogInfo(@"%@", model.detail.view.eventType);
            ZHLogInfo(@"%@", model.detail.view.action);
            ZHLogInfo(@"%d", model.detail.view.elementLocation.type);
            ZHLogInfo(@"%@", model.detail.view.hasElementLocation ? model.detail.view.elementLocation.text : @"没有 element location");
        } else {
            ZHLogInfo(@"没有 view");
        }
        ZHLogInfo(@"%@", temp.zaContextModel.description);
        ZHLogInfo(@"id: %@", xcID);
        ZHLogInfo(@"label: %@", xcLabel);
        ZHLogInfo(@"hint: %@", temp.attributedPlaceholder.string);
        NSString *appCompText = temp.attributedText.string;
        NSString *appCompHint = temp.attributedPlaceholder.string;
        hookInfo.xcID = xcID;
        hookInfo.xcLabel = xcLabel;
        
        hookInfo.appCompName = selfName;
        hookInfo.appSuperViewCompName = superViewName;
        hookInfo.appUserOperation = @"click";
        hookInfo.appCompText = appCompText;
        hookInfo.appCompHint = appCompHint;
        hookInfo.hookMethodName = @"becomeFirstResponder";
        ZHLogInfo(@"%@", hookInfo.description);
        
        [[TBUIAutoTest sharedInstance].hookInfoArr addObject:hookInfo.description];
        
    }
    return [self auto_becomeFirstResponder];
    
}

- (BOOL)auto_resignFirstResponder {
    if (![TBUIAutoTest isEnableAutoUI]) {
        ZHLogInfo(@"没有开启 AutoUI 开关，请到 DebugUI 中开启");
        return [self auto_resignFirstResponder];;
    }
    
    ZHLogInfo(@"hook resign responder");
    NSString *selfName = NSStringFromClass([self class]);
    NSString *superViewName = NSStringFromClass([self.superview class]);
    ZHLogInfo(@"class name: %@", selfName);
    ZHLogInfo(@"super view class name: %@", superViewName);
    
    ZABaseContextModel *model = self.zaContextModel;
    
    iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
    
    // unknown
    if (model.zaUIType == 0) {
//        这种情况下，model 是个空的，打点是空的
    } else if (model.zaUIType == 1) { // button
        // 这种情况下是有打点信息的
        NSString *buttonText = model.detail.view.elementLocation.text;
        NSInteger buttonUIAction = model.zaUIActionType;
        NSInteger buttonUIEvent = model.zaUIEventType;
        
    }
    
    if ([self isKindOfClass:UITextField.class]) {
        UITextField *temp = (UITextField*)self;
        NSString *xcID = temp.accessibilityIdentifier;
        NSString *xcLabel = temp.accessibilityLabel;
        ZABaseContextModel *model = temp.zaContextModel;
        
        if (model.detail.hasView) {
            ZHLogInfo(@"%@", model.detail.view.eventType);
            ZHLogInfo(@"%@", model.detail.view.action);
            ZHLogInfo(@"%d", model.detail.view.elementLocation.type);
            ZHLogInfo(@"%@", model.detail.view.hasElementLocation ? model.detail.view.elementLocation.text : @"没有 element location");
        } else {
            ZHLogInfo(@"没有 view");
        }
        ZHLogInfo(@"%@", temp.zaContextModel.description);
        ZHLogInfo(@"id: %@", xcID);
        ZHLogInfo(@"label: %@", xcLabel);
        ZHLogInfo(@"hint: %@", temp.attributedPlaceholder.string);
        ZHLogInfo(@"input text: %@", temp.attributedText.string);
        
        NSString *appCompText = temp.attributedText.string;
        NSString *appCompHint = temp.attributedPlaceholder.string;
        
        hookInfo.xcID = xcID;
        hookInfo.xcLabel = xcLabel;
        
        hookInfo.appCompName = selfName;
        hookInfo.appSuperViewCompName = superViewName;
        hookInfo.appUserOperation = @"click";
        hookInfo.appCompText = appCompText;
        hookInfo.appCompHint = appCompHint;
        hookInfo.hookMethodName = @"resignFirstResponder";
        ZHLogInfo(@"%@", hookInfo.description);
        
        [[TBUIAutoTest sharedInstance].hookInfoArr addObject:hookInfo.description];
    }
    return [self auto_resignFirstResponder];
}

@end

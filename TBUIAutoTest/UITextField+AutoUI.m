//
//  UITextField+AutoUI.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/18.
//

#import "UITextField+AutoUI.h"
#import "TBUIAutoTest.h"
#import <objc/runtime.h>

@import ZHLogger;
@import ZHCoreZASDK;


@implementation UITextField (AutoUI)

+ (void)doAutoUISwizzling {
    [UITextField swizzleSelector:@selector(becomeFirstResponder) withAnotherSelector:@selector(auto_becomeFirstResponder)];
    [UITextField swizzleSelector:@selector(resignFirstResponder) withAnotherSelector:@selector(auto_resignFirstResponder)];
}

- (BOOL)auto_becomeFirstResponder {
    [self auto_becomeFirstResponder];
    ZHLogInfo(@"hook become responder");
    NSString *className = NSStringFromClass([self class]);
    NSString *superViewClassName = NSStringFromClass([self.superview class]);
    ZHLogInfo(@"class name: %@", className);
    ZHLogInfo(@"super view class name: %@", superViewClassName);
    
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
        
    }
    
}

- (BOOL)auto_resignFirstResponder {
    [self auto_resignFirstResponder];
    
    ZHLogInfo(@"hook resign responder");
    NSString *className = NSStringFromClass([self class]);
    NSString *superViewClassName = NSStringFromClass([self.superview class]);
    ZHLogInfo(@"class name: %@", className);
    ZHLogInfo(@"super view class name: %@", superViewClassName);
    
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
        
    }
    
    
}

@end

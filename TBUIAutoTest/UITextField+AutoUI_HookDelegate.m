//
//  UITextField+AutoUI_HookDelegate.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/19.
//

#import <objc/runtime.h>
#import "UITextField+AutoUI_HookDelegate.h"
#import "iOSHookInfo.h"
#import "TBUIAutoTest.h"

@import ZHLogger;

@implementation UITextField (AutoUI_HookDelegate)

static void auto_exchangeDelegateMethod(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel, SEL orginReplaceSel){
    // 原方法
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    // 替换方法
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originalMethod) {
        Method orginReplaceMethod = class_getInstanceMethod(replacedClass, orginReplaceSel);
        BOOL didAddOriginMethod = class_addMethod(originalClass, originalSel, method_getImplementation(orginReplaceMethod), method_getTypeEncoding(orginReplaceMethod));
        if (didAddOriginMethod) {
            NSLog(@"did Add Origin Replace Method");
        }
        return;
    }
    // 向实现 delegate 的类中添加新的方法
    // 这里是向 originalClass 的 replaceSel（@selector(replace_webViewDidFinishLoad:)） 添加 replaceMethod
    BOOL didAddMethod = class_addMethod(originalClass, replacedSel, method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
    if (didAddMethod) {
        // 添加成功
        NSLog(@"class_addMethod_success --> (%@)", NSStringFromSelector(replacedSel));
        // 重新拿到添加被添加的 method,这里是关键(注意这里 originalClass, 不 replacedClass), 因为替换的方法已经添加到原类中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        // 实现交换
        method_exchangeImplementations(originalMethod, newMethod);
    }else{
        // 添加失败，则说明已经 hook 过该类的 delegate 方法，防止多次交换。
        NSLog(@"Already hook class --> (%@)",NSStringFromClass(originalClass));
    }
}

+ (void)doAutoUIDelegateSwizzling {
    [UITextField swizzleSelector:@selector(setDelegate:) withAnotherSelector:@selector(auto_setDelegate:)];
}


- (void)auto_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self auto_setDelegate:delegate];
    [self exchangeUITextViewDelegateMethod:delegate];
}

- (void)exchangeUITextViewDelegateMethod:(id)delegate {
    auto_exchangeDelegateMethod([delegate class], @selector(textFieldShouldReturn:), [self class], @selector(replace_textFieldShouldReturn:),@selector(oriReplace_textFieldShouldReturn:));
}


// 在未添加该 delegate 的情况下，手动添加 delegate 方法。
- (BOOL)oriReplace_textFieldShouldReturn:(UITextField *)textField {
    ZHLogInfo(@"hook return");
    return [self oriReplace_textFieldShouldReturn:textField];
    
}

// 在添加该 delegate 的情况下，使用 swizzling 交换方法实现。
// 交换后的具体方法实现
// 这个方法用来 hook 用户点击键盘的 return 按钮
- (BOOL)replace_textFieldShouldReturn:(UITextField *)textField {
    if (![TBUIAutoTest isEnableAutoUI]) {
        ZHLogInfo(@"没有开启 AutoUI 开关，请到 DebugUI 中开启");
        return [self replace_textFieldShouldReturn:textField];
    }
    
    ZHLogInfo(@"Hook textFieldShouldReturn");
    
    NSString *superViewName = NSStringFromClass(textField.superview.class);
    NSString *selfName = @"UITextField";
    
    iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
    
    hookInfo.appCompName = selfName;
    hookInfo.appSuperViewCompName = superViewName;
    hookInfo.appUserOperation = @"click";
    hookInfo.appCompText = @"return";
    hookInfo.appCompHint = @"return";
    hookInfo.hookMethodName = @"textFieldShouldReturn";
    
    ZHLogInfo(@"%@", hookInfo.description);
    
    [[TBUIAutoTest sharedInstance].hookInfoArr addObject:hookInfo.description];
    
    return [self replace_textFieldShouldReturn:textField];
    
}

@end


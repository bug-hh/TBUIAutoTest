//
//  UIScrollView+AutoUI_HookDelegate.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/23.
//

#import <objc/runtime.h>

#import "UIScrollView+AutoUI_HookDelegate.h"
#import "TBUIAutoTest.h"
#import "iOSHookInfo.h"

@import ZHLogger;

@implementation UIScrollView (AutoUI_HookDelegate)

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
    [UIScrollView swizzleSelector:@selector(setDelegate:) withAnotherSelector:@selector(auto_setDelegate:)];
}


- (void)auto_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self auto_setDelegate:delegate];
    [self exchangeUIScrollViewDelegateMethod:delegate];
}


- (void)exchangeUIScrollViewDelegateMethod:(id)delegate {
    auto_exchangeDelegateMethod([delegate class], @selector(scrollViewDidEndDragging:willDecelerate:), [self class], @selector(replace_scrollViewDidEndDragging:willDecelerate:),@selector(oriReplace_scrollViewDidEndDragging:willDecelerate:));
}

// 在未添加该 delegate 的情况下，手动添加 delegate 方法
- (void)oriReplace_scrollViewDidEndDragging:(UIScrollView *)scrollView
                             willDecelerate:(BOOL)decelerate {
    if ([TBUIAutoTest isEnableAutoUI]) {
        ZHLogInfo(@"hook scrollview");
        ZHLogInfo(@"oriReplace_scrollViewDidEndDragging");
        CGPoint point = scrollView.contentOffset;
        CGPoint point2 = [scrollView.panGestureRecognizer translationInView:scrollView];
        
        ZHLogInfo(@"x: %f, y: %f", point.x, point.y);
        
        NSMutableString *appUserOperation = [[NSMutableString alloc] init];
        if (point.x != 0) {
            if (point2.x > 0) {
                [appUserOperation appendString:@"右滑"];
            } else {
                [appUserOperation appendString:@"左滑"];
            }
        } else if (point.y != 0){
            if (point2.y > 0) {
                [appUserOperation appendString:@"下滑"];
            } else {
                [appUserOperation appendString:@"上滑"];
            }
            
        }
        iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
        hookInfo.appUserOperation = appUserOperation;
        hookInfo.hookMethodName = @"scrollViewDidEndDragging";
        
        ZHLogInfo(@"%@", hookInfo.description);
    } else {
        ZHLogInfo(@"没有开启 AutoUI 开关，请到 DebugUI 中开启");
    }
    
    if ([self respondsToSelector:@selector(oriReplace_scrollViewDidScroll:)]) {
        [self oriReplace_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

// 在添加该 delegate 的情况下，使用 swizzling 交换方法实现。
// 交换后的具体方法实现
- (void)replace_scrollViewDidEndDragging:(UIScrollView *)scrollView
                          willDecelerate:(BOOL)decelerate {
    if ([TBUIAutoTest isEnableAutoUI]) {
        ZHLogInfo(@"hook scrollview");
        ZHLogInfo(@"replace_scrollViewDidEndDragging");
        CGPoint point = scrollView.contentOffset;
        CGPoint point2 = [scrollView.panGestureRecognizer translationInView:scrollView];
        ZHLogInfo(@"x: %f, y: %f", point.x, point.y);     // x 不为 0 左右滑动，y 不为 0 上下滑动，x 和 y 不可能同时不为 0
        ZHLogInfo(@"x: %f, y: %f", point2.x, point2.y);   // 下滑 + 上滑 -
        
        NSMutableString *appUserOperation = [[NSMutableString alloc] init];
        if (point.x != 0) {
            if (point2.x > 0) {
                [appUserOperation appendString:@"右滑"];
            } else {
                [appUserOperation appendString:@"左滑"];
            }
        } else if (point.y != 0){
            if (point2.y > 0) {
                [appUserOperation appendString:@"下滑"];
            } else {
                [appUserOperation appendString:@"上滑"];
            }
        }
        
        iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
        hookInfo.appUserOperation = appUserOperation;
        hookInfo.hookMethodName = @"scrollViewDidEndDragging";
        
        ZHLogInfo(@"%@", hookInfo.description);
    } else {
        ZHLogInfo(@"没有开启 AutoUI 开关，请到 DebugUI 中开启");
    }
    
    if([self respondsToSelector:@selector(replace_scrollViewDidScroll:)]) {
        [self oriReplace_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end

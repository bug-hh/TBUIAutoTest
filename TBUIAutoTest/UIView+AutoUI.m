//
//  UIView+AutoUI.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/19.
//

#import "UIView+AutoUI.h"
#import <objc/runtime.h>

@import ZHLogger;

@implementation UIView (AutoUI)

+ (void)doAutoUISwizzling {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL mySEL = @selector(auto_addGestureRecognizer:);
        SEL systemSEL = @selector(addGestureRecognizer:);
        Class class = [self class];
        Method myM = class_getInstanceMethod(class, mySEL);
        Method systemM = class_getInstanceMethod(class, systemSEL);
        BOOL success = class_addMethod(class,
                                       mySEL,
                                       method_getImplementation(systemM),
                                       method_getTypeEncoding(systemM));
        if (success) {
            class_replaceMethod(class,
                                systemSEL,
                                method_getImplementation(myM),
                                method_getTypeEncoding(myM));
        }else {
            method_exchangeImplementations(myM, systemM);
        }
    });

}

- (void)auto_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self auto_addGestureRecognizer:gestureRecognizer];
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [gestureRecognizer addTarget:self action:@selector(auto_tapAction)];
    }
}

- (void)auto_tapAction {
    ZHLogInfo(@"hook tap");
}
@end

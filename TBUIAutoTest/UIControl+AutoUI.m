//
//  UIControl+AutoUI.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/14.
//

#import "UIControl+AutoUI.h"
#import "TBUIAutoTest.h"
#import "iOSHookInfo.h"
#import <objc/runtime.h>


@import ZHLogger;
@import ZHCoreZASDK;
@import LogEntryProto;
@import ZHTabBar;


@implementation UIControl (AutoUI)

+ (NSString*)translateType:(int)type {
    switch (type) {
        case 0:
            return @"Unknow";
        case 1:
            return @"Hover";
        case 2:
            return @"SwipeLeft";
        case 3:
            return @"SwipeRight";
        case 4:
            return @"SwipeUp";
        case 5:
            return @"SwipeDown";
        case 6:
            return @"RotateScreen";
        case 7:
            return @"Shake";
        case 8:
            return @"DoubleClick";
        case 9:
            return @"Drag";
        case 10:
            return @"Click";
        default:
            return @"Unknow";
    }
}

+ (void)doAutoUISwizzling {
    [UIControl swizzleSelector:@selector(sendAction:to:forEvent:) withAnotherSelector:@selector(auto_sendAction:to:forEvent:)];

}

- (void)auto_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self auto_sendAction:action to:target forEvent:event];
    
    if (![TBUIAutoTest isEnableAutoUI]) {
        ZHLogInfo(@"没有开启 AutoUI 开关，请到 DebugUI 中开启");
        return;
    }
    
    ZHLogInfo(@"##### hook #####");
    NSString *selfName = NSStringFromClass([self class]);
    NSString *superViewName = NSStringFromClass([self.superview class]);
    ZHLogInfo(@"%@", selfName);
    ZHLogInfo(@"%@", superViewName);
    ZHLogInfo(@"%@", NSStringFromSelector(action));
    
    iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
    
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        UIButton *temp = (UIButton*)self;
        NSString *xcID = temp.accessibilityIdentifier;
        NSString *xcLabel = temp.accessibilityLabel;
        NSString *actionName = NSStringFromSelector(action);
        NSString *appCompText = nil;
        
        ZABaseContextModel *model = temp.zaContextModel;
        
        if (model.detail.hasView) {
            ZHLogInfo(@"%@", model.detail.view.eventType);
            ZHLogInfo(@"%@", model.detail.view.action);
            ZHLogInfo(@"%d", model.detail.view.elementLocation.type);
            ZHLogInfo(@"%@", model.detail.view.hasElementLocation ? model.detail.view.elementLocation.text : @"没有 element location");
            appCompText = model.detail.view.elementLocation.text;
        } else {
            ZHLogInfo(@"没有获取到埋点信息");
            // tabbar button
            if ([selfName containsString:@"TabBarButton"]) {
                ZHTabBarItemView *itemView = self.superview;
                ZHTabBarItem *item = itemView.item;
                appCompText = item.title;
                ZHLogInfo(@"%@", itemView.accessibilityIdentifier);
                ZHLogInfo(@"title: %@", item.title);
                ZHLogInfo(@"name: %@", item.name);
                ZHLogInfo(@"identifier: %d", item.identifier);
            } else {
                if (temp.titleLabel && [temp.titleLabel respondsToSelector:@selector(text)]) {
                    appCompText = temp.titleLabel.text;
                }
            }
        }
        
        
        hookInfo.xcID = xcID;
        hookInfo.xcLabel = xcLabel;
        
        hookInfo.appCompName = selfName;
        hookInfo.appSuperViewCompName = superViewName;
        hookInfo.appUserOperation = @"click";
        hookInfo.appOperationName = NSStringFromSelector(action);
        hookInfo.appCompText = appCompText;
        hookInfo.hookMethodName = @"sendAction";
        ZHLogInfo(@"%@", hookInfo.description);
        
    } else {
        ZHLogInfo(@"不属于 UIButton");
        
    }
    
}



@end

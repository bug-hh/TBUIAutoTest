//
//  UIControl+AutoUI.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/14.
//

#import "UIControl+AutoUI.h"
#import "TBUIAutoTest.h"
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
    ZHLogInfo(@"##### hook #####");
    NSString *selfName = NSStringFromClass([self class]);
    NSString *superViewName = NSStringFromClass([self.superview class]);
    ZHLogInfo(@"%@", selfName);
    ZHLogInfo(@"%@", superViewName);
    ZHLogInfo(@"%@", NSStringFromSelector(action));
    
    if ([selfName containsString:@"TabBarButton"]) {
        ZHTabBarItemView *itemView = self.superview;
        ZHTabBarItem *item = itemView.item;
        ZHLogInfo(@"%@", itemView.accessibilityIdentifier);
        ZHLogInfo(@"title: %@", item.title);
        ZHLogInfo(@"name: %@", item.name);
        ZHLogInfo(@"identifier: %d", item.identifier);
    }
    
    ZABaseContextModel *model = self.zaContextModel;
    // unknown
    if (model.zaUIType == 0) {
//        这种情况下，model 是个空的，打点是空的
    } else if (model.zaUIType == 1) { // button
        // 这种情况下是有打点信息的
        NSString *buttonText = model.detail.view.elementLocation.text;
        NSInteger buttonUIAction = model.zaUIActionType;
        NSInteger buttonUIEvent = model.zaUIEventType;
        NSString *buttonAction = NSStringFromSelector(action);
        
    }
    
    if ([self isKindOfClass:UIButton.class]) {
        UIButton *temp = (UIButton*)self;
        NSString *xcID = temp.accessibilityIdentifier;
        NSString *xcLabel = temp.accessibilityLabel;
        NSString *actionName = NSStringFromSelector(action);
        
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
    }
    
}



@end

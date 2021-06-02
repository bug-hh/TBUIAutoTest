//
//  UICollectionView+AutoUI_HookDelegate.m
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/29.
//

#import <objc/runtime.h>

#import "TBUIAutoTest.h"
#import "UICollectionView+AutoUI_HookDelegate.h"
#import "iOSHookInfo.h"

@import ZHLogger;
@import ZHCoreZASDK;
@import ZHCoreUsefullViews;



@implementation UICollectionView (AutoUI_HookDelegate)

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

+ (void)doAutoUICollectionViewDelegateSwizzling {
    [UICollectionView swizzleSelector:@selector(setDelegate:) withAnotherSelector:@selector(auto_collectionViewSetDelegate:)];
}


- (void)auto_collectionViewSetDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([self respondsToSelector:@selector(exchangeUICollectionViewDelegateMethod:)]) {
        [self exchangeUICollectionViewDelegateMethod:delegate];
    }
    
    if ([self respondsToSelector:@selector(auto_collectionViewSetDelegate:)]) {
        [self auto_collectionViewSetDelegate:delegate];
    }
    
}


- (void)exchangeUICollectionViewDelegateMethod:(id)delegate {
    auto_exchangeDelegateMethod([delegate class], @selector(collectionView:shouldSelectItemAtIndexPath:), [self class], @selector(replace_collectionView:shouldSelectItemAtIndexPath:),@selector(oriReplace_collectionView:shouldSelectItemAtIndexPath:));
}

- (BOOL)oriReplace_collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHLogInfo(@"hook collectionview");
    ZHLogInfo(@"oriReplace_collectionView");
    
    
    iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
    UICollectionViewCell* cell = [collectionView.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *selfName = NSStringFromClass(cell.class);
    NSString *collectionViewName = NSStringFromClass(collectionView.class);
    NSString *superClassName = NSStringFromClass(collectionView.superview.class);
    NSString *xcID = cell.accessibilityIdentifier;
    NSString *xcLabel = cell.accessibilityLabel;
    NSString *appCompText = @"";
    NSString *appCompHint = @"";

    if ([cell isKindOfClass:ZHFlexibleTopBarItemCell.class]) {
        ZHFlexibleTopTabBar *topTabBar = collectionView.superview;
        int index = topTabBar.currentIndex == topTabBar.itemModels.count - 1 ? 0 : topTabBar.currentIndex + 1;
        ZHFlexibleTopBarItem *item = topTabBar.itemModels[indexPath.item];
        ZHFlexibleTopBarContent* itemContent = item.selected;
        appCompText = itemContent.title;
        appCompHint = itemContent.title;
        ZHLogInfo(@"选中顶部标题：%@", itemContent.title);
    }

    hookInfo.xcID = xcID;
    hookInfo.xcID = xcLabel;
    hookInfo.appCompName = selfName;
    hookInfo.appSuperViewCompName = superClassName;
    hookInfo.appUserOperation = @"click";
    hookInfo.appCompText = appCompText;
    hookInfo.appCompHint = appCompHint;
    hookInfo.hookMethodName = @"collectionView:shouldSelectItemAtIndexPath:";
    
    ZHLogInfo(@"%@", hookInfo.description);
    
    [[TBUIAutoTest sharedInstance].hookInfoArr addObject:hookInfo.description];
    
    if ([self respondsToSelector:@selector(oriReplace_collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self oriReplace_collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }

    return YES;

}

- (BOOL)replace_collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHLogInfo(@"hook collectionview");
    ZHLogInfo(@"replace_collectionView");

    iOSHookInfo *hookInfo = [[iOSHookInfo alloc] init];
    UICollectionViewCell* cell = [collectionView.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *selfName = NSStringFromClass(cell.class);
    NSString *collectionViewName = NSStringFromClass(collectionView.class);
    NSString *superClassName = NSStringFromClass(collectionView.superview.class);
    NSString *xcID = cell.accessibilityIdentifier;
    NSString *xcLabel = cell.accessibilityLabel;
    NSString *appCompText = @"";
    NSString *appCompHint = @"";
    
    if ([cell isKindOfClass:ZHFlexibleTopBarItemCell.class]) {
        ZHFlexibleTopTabBar *topTabBar = collectionView.superview;
        int index = topTabBar.currentIndex == topTabBar.itemModels.count - 1 ? 0 : topTabBar.currentIndex + 1;
        ZHFlexibleTopBarItem *item = topTabBar.itemModels[indexPath.item];
        ZHFlexibleTopBarContent* itemContent = item.selected;
        appCompText = itemContent.title;
        appCompHint = itemContent.title;
        ZHLogInfo(@"选中顶部标题：%@", itemContent.title);
    }
    

    hookInfo.xcID = xcID;
    hookInfo.xcID = xcLabel;
    hookInfo.appCompName = selfName;
    hookInfo.appSuperViewCompName = superClassName;
    hookInfo.appUserOperation = @"click";
    hookInfo.appCompText = appCompText;
    hookInfo.appCompHint = appCompHint;
    hookInfo.hookMethodName = @"collectionView:shouldSelectItemAtIndexPath:";
    
    ZHLogInfo(@"%@", hookInfo.description);
    
    [[TBUIAutoTest sharedInstance].hookInfoArr addObject:hookInfo.description];

    if ([self respondsToSelector:@selector(replace_collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self replace_collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    return YES;
}


@end

//
//  UIScrollView+AutoUI_HookDelegate.h
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (AutoUI_HookDelegate)

+ (void)doAutoUIDelegateSwizzling;

@end

NS_ASSUME_NONNULL_END

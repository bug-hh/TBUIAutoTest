//
//  UICollectionView+AutoUI_HookDelegate.h
//  TBUIAutoTest
//
//  Created by bughh on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (AutoUI_HookDelegate)

+ (void)doAutoUICollectionViewDelegateSwizzling;

@end

NS_ASSUME_NONNULL_END

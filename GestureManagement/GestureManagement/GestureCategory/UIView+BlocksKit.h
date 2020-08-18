//
//  UIView+BlocksKit.h
//  GestureManagement
//
//  Created by Jenson on 2020/8/19.
//  Copyright © 2020 Jenson. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BlocksKit)
- (void)je_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block;

- (void)je_whenTapped:(void (^)(void))block;
- (void)je_whenTappedView:(void (^)(UIView *view))block;
- (void)je_whenDoubleTapped:(void (^)(void))block;
- (void)je_eachSubview:(void (^)(UIView *subview))block;

- (void)je_whenLongTapped:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END

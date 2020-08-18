//
//  UIGestureRecognizer+BlocksKit.h
//  GestureManagement
//
//  Created by Jenson on 2020/8/19.
//  Copyright © 2020 Jenson. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (BlocksKit)

+ (id)je_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay;

- (id)je_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay NS_REPLACES_RECEIVER;

+ (id)je_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;

- (id)je_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block NS_REPLACES_RECEIVER;

@property (nonatomic, copy, setter = je_setHandler:) void (^je_handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);

@property (nonatomic, setter = je_setHandlerDelay:) NSTimeInterval je_handlerDelay;

- (void)je_cancel;

@end

NS_ASSUME_NONNULL_END

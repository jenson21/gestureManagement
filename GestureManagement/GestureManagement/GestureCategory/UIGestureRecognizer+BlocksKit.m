//
//  UIGestureRecognizer+BlocksKit.m
//  GestureManagement
//
//  Created by Jenson on 2020/8/19.
//  Copyright © 2020 Jenson. All rights reserved.
//

#import <objc/runtime.h>
#import "UIGestureRecognizer+BlocksKit.h"

static const void *JEGestureRecognizerBlockKey = &JEGestureRecognizerBlockKey;
static const void *JEGestureRecognizerDelayKey = &JEGestureRecognizerDelayKey;
static const void *JEGestureRecognizerShouldHandleActionKey = &JEGestureRecognizerShouldHandleActionKey;

@interface UIGestureRecognizer (BlocksKitInternal)

@property (nonatomic, setter = je_setShouldHandleAction:) BOOL je_shouldHandleAction;

- (void)je_handleAction:(UIGestureRecognizer *)recognizer;

@end

@implementation UIGestureRecognizer (BlocksKit)

+ (id)je_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    return [[[self class] alloc] je_initWithHandler:block delay:delay];
}

- (id)je_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    self = [self initWithTarget:self action:@selector(je_handleAction:)];
    if (!self) return nil;
    
    self.je_handler = block;
    self.je_handlerDelay = delay;
    
    return self;
}

+ (id)je_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return [self je_recognizerWithHandler:block delay:0.0];
}

- (id)je_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return (self = [self je_initWithHandler:block delay:0.0]);
}

- (void)je_handleAction:(UIGestureRecognizer *)recognizer
{
    void (^handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) = recognizer.je_handler;
    if (!handler) return;
    
    NSTimeInterval delay = self.je_handlerDelay;
    CGPoint location = [self locationInView:self.view];
    void (^block)(void) = ^{
        if (!self.je_shouldHandleAction) return;
        handler(self, self.state, location);
    };
    
    self.je_shouldHandleAction = YES;
    
    if (!delay) {
        block();
        return;
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void)je_setHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))handler
{
    objc_setAssociatedObject(self, JEGestureRecognizerBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))je_handler
{
    return objc_getAssociatedObject(self, JEGestureRecognizerBlockKey);
}

- (void)je_setHandlerDelay:(NSTimeInterval)delay
{
    NSNumber *delayValue = delay ? @(delay) : nil;
    objc_setAssociatedObject(self, JEGestureRecognizerDelayKey, delayValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)je_handlerDelay
{
    return [objc_getAssociatedObject(self, JEGestureRecognizerDelayKey) doubleValue];
}

- (void)je_setShouldHandleAction:(BOOL)flag
{
    objc_setAssociatedObject(self, JEGestureRecognizerShouldHandleActionKey, @(flag), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)je_shouldHandleAction
{
    return [objc_getAssociatedObject(self, JEGestureRecognizerShouldHandleActionKey) boolValue];
}

- (void)je_cancel
{
    self.je_shouldHandleAction = NO;
}

@end

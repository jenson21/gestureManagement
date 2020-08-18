//
//  UIView+BlocksKit.m
//  GestureManagement
//
//  Created by Jenson on 2020/8/19.
//  Copyright © 2020 Jenson. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+BlocksKit.h"
#import "UIGestureRecognizer+BlocksKit.h"

@implementation UIView (BlocksKit)

- (void)je_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block
{
    if (!block) return;
    self.userInteractionEnabled = true;
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer je_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (state == UIGestureRecognizerStateRecognized) block();
    }];
    
    gesture.numberOfTouchesRequired = numberOfTouches;
    gesture.numberOfTapsRequired = numberOfTaps;
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UITapGestureRecognizer class]]) return;
        
        UITapGestureRecognizer *tap = obj;
        BOOL rightTouches = (tap.numberOfTouchesRequired == numberOfTouches);
        BOOL rightTaps = (tap.numberOfTapsRequired == numberOfTaps);
        if (rightTouches && rightTaps) {
            [gesture requireGestureRecognizerToFail:tap];
        }
    }];
    
    [self addGestureRecognizer:gesture];
}



- (void)je_whenTapped:(void (^)(void))block
{
    [self je_whenTouches:1 tapped:1 handler:block];
}

- (void)je_whenTappedView:(void (^)(UIView *))block{
    __weak typeof(self) weakSelf = self;
    [self je_whenTouches:1 tapped:1 handler:^{
        __strong typeof(self) self = weakSelf;
        block(self);
    }];
}

- (void)je_whenDoubleTapped:(void (^)(void))block
{
    [self je_whenTouches:2 tapped:1 handler:block];
}

- (void)je_eachSubview:(void (^)(UIView *subview))block
{
    NSParameterAssert(block != nil);
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        block(subview);
    }];
}

- (void)je_whenLongTapped:(void (^)(void))block {
    
    [self addGestureLongPressEventHandle:^(id sender, UILongPressGestureRecognizer *recognizer) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            if (block) {
                block();
            }
        }
    }];
}

- (UILongPressGestureRecognizer *)addGestureLongPressEventHandle:(void (^)(id sender, UILongPressGestureRecognizer *recognizer))event {
    return [self addGestureEventHandle:event gestureClass:[UILongPressGestureRecognizer class]];
}

- (NSMutableDictionary *)gestureBlocks
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(gestureBlocks), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (id)addGestureEventHandle:(void (^)(id, id))event gestureClass:(Class)class {
    UIGestureRecognizer *gesture = [[class alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    [self addGestureRecognizer:gesture];
    if (event) {
        [[self gestureBlocks] setObject:event forKey:NSStringFromClass(class)];
    }
    return gesture;
}


- (void)handleGestureRecognizer:(UIGestureRecognizer *)gesture
{
    NSString *key = NSStringFromClass(gesture.class);
    void (^block)(id sender, UIGestureRecognizer *tap) = [self gestureBlocks][key];
    block ? block(self, gesture) : nil;
}

@end

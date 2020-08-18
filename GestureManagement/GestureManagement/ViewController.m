//
//  ViewController.m
//  GestureManagement
//
//  Created by Jenson on 2020/8/19.
//  Copyright © 2020 Jenson. All rights reserved.
//

#import "ViewController.h"
#import "UIView+BlocksKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    test.backgroundColor = [UIColor brownColor];
    [self.view addSubview:test];
    
    [test je_whenTapped:^{
        NSLog(@"test");
    }];
}


@end

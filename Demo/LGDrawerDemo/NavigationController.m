//
//  NavigationController.m
//  LGDrawerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "NavigationController.h"
#import "CollectionViewController.h"

@interface NavigationController ()

@property (strong, nonatomic) CollectionViewController *collectionViewController;

@end

@implementation NavigationController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.collectionViewController = [CollectionViewController new];
        [self setViewControllers:@[self.collectionViewController]];
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

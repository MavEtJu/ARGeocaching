//
//  GroupObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface GroupObject ()

@end

@implementation GroupObject

- (instancetype)init
{
    self = [super init];

    self.nodes = [NSMutableArray arrayWithCapacity:20];

    return self;
}

- (void)finish
{
    self.origin = SCNVector3Make([[self.aOrigin objectAtIndex:0] floatValue],
                                 [[self.aOrigin objectAtIndex:1] floatValue],
                                 [[self.aOrigin objectAtIndex:2] floatValue]);
}

@end

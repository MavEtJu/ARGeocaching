//
//  ConeObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface ConeObject ()

@end

@implementation ConeObject

- (void)finish
{
    [super finish];

    NSAssert(self.sBottomRadius != nil, @"radius-bottom should be defined");
    NSAssert(self.sTopRadius != nil, @"radius-top should be defined");
    self.topRadius = [self.sTopRadius floatValue];
    self.bottomRadius = [self.sBottomRadius floatValue];

    self.geometry = [SCNCone coneWithTopRadius:self.topRadius bottomRadius:self.bottomRadius height:1];

    [self finished];
}

@end

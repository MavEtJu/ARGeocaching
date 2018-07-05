//
//  TubeObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface TubeObject ()

@end

@implementation TubeObject

- (void)finish
{
    [super finish];

    NSAssert(self.sInnerRadius != nil, @"radius-innner should be defined");
    NSAssert(self.sOuterRadius != nil, @"radius-outer should be defined");
    self.innerRadius = [self.sInnerRadius floatValue];
    self.outerRadius = [self.sOuterRadius floatValue];

    self.geometry = [SCNTube tubeWithInnerRadius:self.innerRadius outerRadius:self.outerRadius height:1];

    [self finished];
}

@end

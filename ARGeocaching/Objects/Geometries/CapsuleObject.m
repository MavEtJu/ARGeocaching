//
//  CapsuleObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface CapsuleObject ()

@end

@implementation CapsuleObject

- (void)finish
{
    [super finish];

    NSAssert(self.sRadiusCap != nil, @"radius-cap should be defined");
    self.radiusCap = [self.sRadiusCap floatValue];

    self.geometry = [SCNCapsule capsuleWithCapRadius:self.radiusCap height:1];

    [self finished];
}

@end

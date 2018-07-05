//
//  SphereObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface SphereObject ()

@end

@implementation SphereObject

- (void)finish
{
    [super finish];

    NSAssert(self.sRadius != nil, @"radius should be defined");
    self.radius = [self.sRadius floatValue];

    self.geometry = [SCNSphere sphereWithRadius:self.radius];

    [self finished];
}

@end

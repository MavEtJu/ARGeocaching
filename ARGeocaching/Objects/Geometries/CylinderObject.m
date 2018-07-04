//
//  CylinderObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface CylinderObject ()

@end

@implementation CylinderObject

- (void)finish
{
    [super finish];

    self.radius = [self.sRadius floatValue];

    self.geometry = [SCNCylinder cylinderWithRadius:self.radius height:1];

    [self finished];
}

@end

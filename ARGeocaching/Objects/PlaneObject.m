//
//  PlaneObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface PlaneObject ()

@end

@implementation PlaneObject

- (void)finish
{
    [super finish];

    self.geometry = [SCNPlane planeWithWidth:1 height:1];

    [self finished];
}

@end

//
//  TorusObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface TorusObject ()

@end

@implementation TorusObject

- (void)finish
{
    [super finish];

    self.ringRadius = [[self.sRadius objectAtIndex:0] floatValue];
    self.pipeRadius = [[self.sRadius objectAtIndex:1] floatValue];

    self.geometry = [SCNTorus torusWithRingRadius:self.ringRadius pipeRadius:self.pipeRadius];

    [self finished];
}

@end

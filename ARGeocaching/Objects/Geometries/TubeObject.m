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

    self.innerRadius = [[self.sRadius objectAtIndex:0] floatValue];
    self.outerRadius = [[self.sRadius objectAtIndex:1] floatValue];

    self.geometry = [SCNTube tubeWithInnerRadius:self.innerRadius outerRadius:self.outerRadius height:1];

    [self finished];
}

@end

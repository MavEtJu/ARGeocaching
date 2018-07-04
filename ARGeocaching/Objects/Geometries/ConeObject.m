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

    self.topRadius = [[self.sRadius objectAtIndex:0] floatValue];
    self.bottomRadius = [[self.sRadius objectAtIndex:1] floatValue];

    self.geometry = [SCNCone coneWithTopRadius:self.topRadius bottomRadius:self.bottomRadius height:1];

    [self finished];
}

@end

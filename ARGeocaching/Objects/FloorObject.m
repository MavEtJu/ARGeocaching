//
//  FloorObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface FloorObject ()

@end

@implementation FloorObject

- (void)finish
{
    [super finish];

    self.geometry = [SCNFloor floor];

    [self finished];
}


@end

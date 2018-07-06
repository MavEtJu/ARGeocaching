//
//  TextObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 6/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface TextObject ()

@end

@implementation TextObject

- (void)finish
{
    [super finish];

    self.depth = [self.sDepth floatValue];
    self.geometry = [SCNText textWithString:self.text extrusionDepth:self.depth];

    [self finished];
}

@end

//
//  PyramidObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface PyramidObject ()

@end

@implementation PyramidObject

- (void)finish
{
    [super finish];

    self.geometry = [SCNPyramid pyramidWithWidth:1 height:1 length:1];

    [self finished];
}

@end

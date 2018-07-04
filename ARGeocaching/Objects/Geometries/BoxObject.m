//
//  GeometryObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface BoxObject ()

@end

@implementation BoxObject

- (void)finish
{
    [super finish];

    self.geometry = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];

    [self finished];
}

@end

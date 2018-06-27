//
//  SCNFloor.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 25/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "SCNFloorTile.h"
#import "Geometries.h"

@interface SCNFloorTile ()

@end

@implementation SCNFloorTile

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_FLOORTILE];

    return self;
}

@end

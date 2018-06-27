//
//  Geometries.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 25/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface Geometries ()

@property (nonatomic, retain) NSArray *geometries;

@end

@implementation Geometries

- (instancetype)init
{
    self = [super init];

    NSMutableArray *geometries = [NSMutableArray arrayWithCapacity:20];

#define GEOMETRY(__nr__, __material__, __width__, __height__, __length__) { \
    NSAssert(__nr__ == [geometries count], @"Wrong order"); \
    SCNBox *g = [SCNBox boxWithWidth:__width__ height:__height__ length:__length__ chamferRadius:0.0]; \
    SCNMaterial *m = [Materials get:__material__]; \
    NSAssert1(m != nil, @"No material for: %ld", __material__); \
    g.materials = @[m]; \
    [geometries addObject:g]; \
    }

    float boxLength = 0.5;          // half a meter
    float boxWidth = boxLength;
    float boxHeight = 3.0;          // 2 meters
    float floorHeight = 0.1;        // 10 centimeters

    GEOMETRY(GEOMETRY_FLOORTILE, MATERIAL_GRANITE, boxWidth, floorHeight, boxLength)
    GEOMETRY(GEOMETRY_ROOFTILE, MATERIAL_SEMITRANSPARENT, boxWidth, floorHeight, boxLength)

    NSAssert([geometries count] == GEOMETRY_MAX, @"Not enough geometries");

    self.geometries = geometries;

    return self;
}

- (SCNGeometry *)getByIndex:(Geometry)geometry
{
    return [self.geometries objectAtIndex:geometry];
}

+ (SCNGeometry *)get:(Geometry)geometry
{
    return [geometries getByIndex:geometry];
}

@end

Geometries *geometries;

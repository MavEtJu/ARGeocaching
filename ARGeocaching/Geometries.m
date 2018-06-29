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
    g.materials = @[m, m, m, m, m, m]; \
    [geometries addObject:g]; \
}

#define GEOMETRY_ARRAY(__nr__, __m1__, __m2__, __m3__, __m4__, __m5__, __m6__, __width__, __height__, __length__) { \
    NSAssert(__nr__ == [geometries count], @"Wrong order"); \
    SCNBox *g = [SCNBox boxWithWidth:__width__ height:__height__ length:__length__ chamferRadius:0.0]; \
    SCNMaterial *m1 = [Materials get:__m1__]; \
    SCNMaterial *m2 = [Materials get:__m2__]; \
    SCNMaterial *m3 = [Materials get:__m3__]; \
    SCNMaterial *m4 = [Materials get:__m4__]; \
    SCNMaterial *m5 = [Materials get:__m5__]; \
    SCNMaterial *m6 = [Materials get:__m6__]; \
    NSAssert(m1 != nil && m2 != nil && m3 != nil && m4 != nil && m5 != nil && m6 != nil, @"No material for one of them"); \
    g.materials = @[m1, m2, m3, m4, m5, m6]; \
    [geometries addObject:g]; \
}

    float boxLength = 1.0;          // half a meter
    float boxWidth = 1.0;
    float boxHeight = 1.0;
    float floorHeight = 0.1;        // 10 centimeters

    GEOMETRY(GEOMETRY_FLOORTILE, MATERIAL_GRANITE, boxWidth, floorHeight, boxLength)
    GEOMETRY(GEOMETRY_REDMETALWALL_FORWARD, MATERIAL_METALRED, floorHeight, boxHeight, boxLength)
    GEOMETRY_ARRAY(GEOMETRY_REDMETALWALLARROW_FORWARD, MATERIAL_METALRED, MATERIAL_METALRED_ARROW, MATERIAL_METALRED, MATERIAL_METALRED_ARROW, MATERIAL_METALRED, MATERIAL_METALRED, floorHeight, boxHeight, boxLength)
    GEOMETRY(GEOMETRY_REDMETALWALL_RIGHT, MATERIAL_METALRED, boxWidth, boxHeight, floorHeight)
    GEOMETRY(GEOMETRY_METALRASTER_FORWARD, MATERIAL_RASTER, floorHeight, boxHeight, boxLength)
    GEOMETRY(GEOMETRY_METALRASTER_RIGHT, MATERIAL_RASTER, boxWidth, boxHeight, floorHeight)
    GEOMETRY(GEOMETRY_SILVERMETALWALL_HORIZONTAL, MATERIAL_WHITE, boxWidth, floorHeight, boxLength)

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

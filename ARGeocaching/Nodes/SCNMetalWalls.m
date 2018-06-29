//
//  SCNMetalWallForward.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 28/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "SCNMetalWalls.h"
#import "Geometries.h"

@implementation SCNMetalWallRedForward

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_REDMETALWALL_FORWARD];

    return self;
}

@end

@implementation SCNMetalWallRedArrowForward

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_REDMETALWALLARROW_FORWARD];

    return self;
}

@end

@implementation SCNMetalWallRedRight

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_REDMETALWALL_RIGHT];

    return self;
}

@end

@implementation SCNMetalRasterForward

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_METALRASTER_FORWARD];

    return self;
}

@end

@implementation SCNMetalRasterRight

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_METALRASTER_RIGHT];

    return self;
}

@end

@implementation SCNMetalWallSilverHorizontal

- (instancetype)init
{
    self = [super init];

    self.geometry = [Geometries get:GEOMETRY_SILVERMETALWALL_HORIZONTAL];

    return self;
}

@end

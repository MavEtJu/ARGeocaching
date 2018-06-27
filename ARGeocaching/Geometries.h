//
//  Geometries.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 25/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef NS_ENUM(NSInteger, Geometry) {
    GEOMETRY_FLOORTILE,
    GEOMETRY_ROOFTILE,
    GEOMETRY_MAX,
    GEOMETRY_OUTSIDEWALL,
    GEOMETRY_OUTSIDEWALLWINDOW_WALL,
    GEOMETRY_OUTSIDEWALLWINDOW_WINDOW_NS,
    GEOMETRY_OUTSIDEWALLWINDOW_WINDOW_EW,
    GEOMETRY_INSIDEWALL,
    GEOMETRY_PILLAR,

};


@interface Geometries : NSObject

- (SCNGeometry *)getByIndex:(Geometry)material;
+ (SCNGeometry *)get:(Geometry)material;

@end

//
//  NodeObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface NodeObject ()

@end

@implementation NodeObject

- (void)finish
{
    __block GeometryObject *geometry = nil;
    [objectManager.geometries enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    NSAssert1(geometry != nil, @"Unknown geometry: %@", self.sGeometry);

    self.scale = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sScale objectAtIndex:0] floatValue], [[self.sScale objectAtIndex:1] floatValue], [[self.sScale objectAtIndex:2] floatValue])];

    self.position = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sPosition objectAtIndex:0] floatValue], [[self.sPosition objectAtIndex:1] floatValue], [[self.sPosition objectAtIndex:2] floatValue])];

    self.geometry = geometry.geometry;

    self.node = [SCNNode nodeWithGeometry:self.geometry];
    self.node.scale = [self.scale SCNVector3Value];
    SCNVector3 v = [self.position SCNVector3Value];
    [ObjectManager position:self.node x:v.x y:v.y z:v.z];
}

@end

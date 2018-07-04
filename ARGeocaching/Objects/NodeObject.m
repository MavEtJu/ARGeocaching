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
    [objectManager.tubes enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.boxes enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.spheres enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.capsules enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.cylinders enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.pyramids enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.planes enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.floors enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.toruses enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];
    [objectManager.cones enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];

    NSAssert1(geometry != nil, @"Unknown geometry: %@", self.sGeometry);

    self.scale = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sScale objectAtIndex:0] floatValue], [[self.sScale objectAtIndex:1] floatValue], [[self.sScale objectAtIndex:2] floatValue])];
    self.position = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sPosition objectAtIndex:0] floatValue] + self.group.origin.x, [[self.sPosition objectAtIndex:1] floatValue] + self.group.origin.y, [[self.sPosition objectAtIndex:2] floatValue] + self.group.origin.z)];
    self.visisble = self.sVisible == nil ? YES : [self.sVisible isEqualToString:@"yes"] == YES ? YES : NO;

    self.geometry = geometry.geometry;

    self.node = [SCNNode nodeWithGeometry:self.geometry];
    self.node.hidden = !self.visisble;
    self.node.scale = [self.scale SCNVector3Value];
    SCNVector3 v = [self.position SCNVector3Value];
    [ObjectManager position:self.node x:v.x y:v.y z:v.z];
}

@end

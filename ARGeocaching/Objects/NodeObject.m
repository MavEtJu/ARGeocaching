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
    [objectManager.texts enumerateObjectsUsingBlock:^(GeometryObject * _Nonnull go, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([go.name isEqualToString:self.sGeometry] == YES) {
            *stop = YES;
            geometry = go;
        }
    }];

    NSAssert1(geometry != nil, @"Unknown geometry: %@", self.sGeometry);

    self.scale = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sScale objectAtIndex:0] floatValue], [[self.sScale objectAtIndex:1] floatValue], [[self.sScale objectAtIndex:2] floatValue])];
    self.position = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sPosition objectAtIndex:0] floatValue] + self.group.origin.x, [[self.sPosition objectAtIndex:1] floatValue] + self.group.origin.y, [[self.sPosition objectAtIndex:2] floatValue] + self.group.origin.z)];
    self.position = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sPosition objectAtIndex:0] floatValue] + self.group.origin.x, [[self.sPosition objectAtIndex:1] floatValue] + self.group.origin.y, [[self.sPosition objectAtIndex:2] floatValue] + self.group.origin.z)];
    self.rotation = [NSValue valueWithSCNVector4:SCNVector4Make([[self.sRotation objectAtIndex:0] floatValue], [[self.sRotation objectAtIndex:1] floatValue], [[self.sRotation objectAtIndex:2] floatValue], [[self.sRotation objectAtIndex:3] floatValue])];
    self.visisble = self.sVisible == nil ? YES : [self.sVisible isEqualToString:@"yes"] == YES ? YES : NO;

    self.geometry = geometry.geometry;

    self.node = [SCNNode nodeWithGeometry:self.geometry];
    self.node.hidden = !self.visisble;
    self.node.scale = [self.scale SCNVector3Value];
    SCNVector3 v3 = [self.position SCNVector3Value];
    [self nodePositionX:v3.x y:v3.y z:v3.z];
    SCNVector4 v4 = [self.rotation SCNVector4Value];
    [self nodeRotationX:v4.x y:v4.y z:v4.z w:v4.w];
}

- (void)nodeRotationX:(float)x y:(float)y z:(float)z w:(float)angle
{
    self.node.rotation = SCNVector4Make(x, y, -z, GLKMathDegreesToRadians(angle));
}

// Adjust the JSON coordinates into the SCNNode coordinates.
- (void)nodePositionX:(float)x y:(float)y z:(float)z
{
    self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY), (z - objectManager.originZ));
    return;
    if (self.node.geometry == nil) {
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNCone class]] == YES) {
        SCNCone *g = (SCNCone *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + self.node.scale.y * g.height / 2), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX + self.node.scale.x * g.width / 2), (y - objectManager.originY + self.node.scale.y * g.height / 2), -(z - objectManager.originZ + self.node.scale.z * g.length / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNPyramid class]] == YES) {
        SCNPyramid *g = (SCNPyramid *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX + self.node.scale.x * g.width / 2), (y - objectManager.originY + self.node.scale.y * g.height / 2), -(z - objectManager.originZ + self.node.scale.z * g.length / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNPlane class]] == YES) {
        SCNPlane *g = (SCNPlane *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX + self.node.scale.x * g.width / 2), (y - objectManager.originY + self.node.scale.y * g.height / 2), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + self.node.scale.y * g.height / 2), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNCapsule class]] == YES) {
        SCNCapsule *g = (SCNCapsule *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + self.node.scale.y * g.height / 2), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNSphere class]] == YES) {
        SCNSphere *g = (SCNSphere *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + self.node.scale.y * g.radius / 2), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNCylinder class]] == YES) {
        SCNCylinder *g = (SCNCylinder *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + self.node.scale.y * g.radius / 2), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNTorus class]] == YES) {
        // SCNTorus *g = (SCNTorus *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY), -(z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNText class]] == YES) {
        // SCNText *g = (SCNText *)self.node.geometry;
        self.node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY), -(z - objectManager.originZ));
    } else {
        NSAssert1(NO, @"Unknown class: %@", [self.node.geometry class]);
    }
}

// Returns the bottom left front JSON coordinates of the object.
- (float)jsonPositionX
{
    return (self.node.position.x + objectManager.originX);
    if (self.node.geometry == nil) {
        return (self.node.position.x + objectManager.originX);
    } else if ([self.node.geometry isKindOfClass:[SCNPyramid class]] == YES) {
        SCNPyramid *g = (SCNPyramid *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.width / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNPlane class]] == YES) {
        SCNPlane *g = (SCNPlane *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.width / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.width / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.height / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNSphere class]] == YES) {
        SCNSphere *g = (SCNSphere *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.radius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNCapsule class]] == YES) {
        SCNCapsule *g = (SCNCapsule *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.capRadius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNCylinder class]] == YES) {
        SCNCylinder *g = (SCNCylinder *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.radius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNTorus class]] == YES) {
        SCNTorus *g = (SCNTorus *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.ringRadius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNCone class]] == YES) {
        SCNCone *g = (SCNCone *)self.node.geometry;
        return (self.node.position.x + objectManager.originX - self.node.scale.x * g.topRadius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNText class]] == YES) {
        // SCNText *g = (SCNText *)self.node.geometry;
        return (self.node.position.x + objectManager.originX);
    } else {
        NSAssert1(NO, @"Unknown class: %@", [self.node.geometry class]);
    }
    // NOT REACHED
    return -1;
}

- (float)jsonPositionY
{
    return (self.node.position.y + objectManager.originY);
    if (self.node.geometry == nil) {
        return (self.node.position.y + objectManager.originY);
    } else if ([self.node.geometry isKindOfClass:[SCNPyramid class]] == YES) {
        SCNPyramid *g = (SCNPyramid *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.height / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNPlane class]] == YES) {
        SCNPlane *g = (SCNPlane *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.height / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.height / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.height / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNSphere class]] == YES) {
        SCNSphere *g = (SCNSphere *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.radius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNCapsule class]] == YES) {
        SCNCapsule *g = (SCNCapsule *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.capRadius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNCylinder class]] == YES) {
        SCNCylinder *g = (SCNCylinder *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.radius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNTorus class]] == YES) {
        SCNTorus *g = (SCNTorus *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.ringRadius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNCone class]] == YES) {
        SCNCone *g = (SCNCone *)self.node.geometry;
        return (self.node.position.y + objectManager.originY - self.node.scale.y * g.topRadius / 2);
    } else if ([self.node.geometry isKindOfClass:[SCNText class]] == YES) {
        // SCNText *g = (SCNText *)self.node.geometry;
        return (self.node.position.y + objectManager.originY);
    } else {
        NSAssert1(NO, @"Unknown class: %@", [self.node.geometry class]);
    }
    // NOT REACHED
    return -1;
}

- (float)jsonPositionZ
{
    return (- (self.node.position.z + objectManager.originZ));
    if (self.node.geometry == nil) {
        return (- (self.node.position.z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNPyramid class]] == YES) {
        SCNPyramid *g = (SCNPyramid *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.length / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNPlane class]] == YES) {
        // SCNPlane *g = (SCNPlane *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ));
    } else if ([self.node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.length / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.height / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNSphere class]] == YES) {
        SCNSphere *g = (SCNSphere *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.radius / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNCapsule class]] == YES) {
        SCNCapsule *g = (SCNCapsule *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.capRadius / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNCylinder class]] == YES) {
        SCNCylinder *g = (SCNCylinder *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.radius / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNTorus class]] == YES) {
        SCNTorus *g = (SCNTorus *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.ringRadius / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNCone class]] == YES) {
        SCNCone *g = (SCNCone *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ + self.node.scale.z * g.topRadius / 2));
    } else if ([self.node.geometry isKindOfClass:[SCNText class]] == YES) {
        // SCNText *g = (SCNText *)self.node.geometry;
        return (- (self.node.position.z - objectManager.originZ));
    } else {
        NSAssert1(NO, @"Unknown class: %@", [self.node.geometry class]);
    }
    // NOT REACHED
    return -1;
}

@end

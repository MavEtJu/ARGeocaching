//
//  NodeObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface NodeObject : NSObject

// References to the real object
@property (nonatomic, retain) SCNNode *node;

// References to the resolved objects
@property (nonatomic, retain) SCNGeometry *geometry;
@property (nonatomic, retain) NSValue *scale;
@property (nonatomic, retain) NSValue *position;
@property (nonatomic, retain) NSValue *rotation;
@property (nonatomic, retain) GroupObject *group;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic        ) BOOL visisble;

// Read from the configuration
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sGeometry;
@property (nonatomic, retain) NSArray<NSNumber *> *sPosition;
@property (nonatomic, retain) NSArray<NSNumber *> *sScale;
@property (nonatomic, retain) NSArray<NSNumber *> *sRotation;
@property (nonatomic, retain) NSString *sID;
@property (nonatomic, retain) NSString *sVisible;

- (void)finish;

// Adjust the JSON coordinates into the SCNNode coordinates.
- (void)nodePositionX:(float)x y:(float)y z:(float)z;

// Adjust the JSON rotation into the SCNNode rotation.
- (void)nodeRotationX:(float)x y:(float)y z:(float)z w:(float)w;

// Returns the bottom left front JSON coordinates of the object.
- (float)jsonPositionX;
- (float)jsonPositionY;
- (float)jsonPositionZ;

@end

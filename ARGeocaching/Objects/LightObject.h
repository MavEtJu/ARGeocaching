//
//  LightObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface LightObject : NSObject

// References to the real object
@property (nonatomic, retain) SCNLight *light;
@property (nonatomic, retain) SCNNode *node;

// References to the resolved objects
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic        ) SCNLightType type;
@property (nonatomic, retain) NSValue *position;
@property (nonatomic, retain) GroupObject *group;

// Read from the configuration
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sType;
@property (nonatomic, retain) NSArray<NSNumber *> *sColour;
@property (nonatomic, retain) NSArray<NSNumber *> *sPosition;

- (void)finish;

@end

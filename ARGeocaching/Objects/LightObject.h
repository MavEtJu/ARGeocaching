//
//  LightObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface LightObject : NodeObject

// References to the real object
@property (nonatomic, retain) SCNLight *light;

// References to the resolved objects
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic        ) SCNLightType type;

// Read from the configuration
@property (nonatomic, retain) NSString *sType;
@property (nonatomic, retain) NSArray<NSNumber *> *sColour;

- (void)finish;

@end

//
//  CapsuleObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface CapsuleObject : GeometryObject

// References to the real object

// References to the resolved objects
@property (nonatomic        ) float radiusCap;

// Read from the configuration
@property (nonatomic, retain) NSNumber *sRadiusCap;

- (void)finish;

@end

//
//  ConeObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface ConeObject : GeometryObject

// References to the real object

// References to the resolved objects
@property (nonatomic        ) float topRadius;
@property (nonatomic        ) float bottomRadius;

// Read from the configuration
@property (nonatomic, retain) NSNumber *sTopRadius;
@property (nonatomic, retain) NSNumber *sBottomRadius;

- (void)finish;

@end

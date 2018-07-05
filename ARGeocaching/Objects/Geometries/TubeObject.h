//
//  TubeObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface TubeObject : GeometryObject

// References to the real object

// References to the resolved objects
@property (nonatomic        ) float innerRadius;
@property (nonatomic        ) float outerRadius;

// Read from the configuration
@property (nonatomic, retain) NSNumber *sInnerRadius;
@property (nonatomic, retain) NSNumber *sOuterRadius;

- (void)finish;

@end

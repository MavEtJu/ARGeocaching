//
//  TorusObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface TorusObject : GeometryObject

// References to the real object

// References to the resolved objects
@property (nonatomic        ) float ringRadius;
@property (nonatomic        ) float pipeRadius;

// Read from the configuration
@property (nonatomic, retain) NSArray<NSNumber *> *sRadius;

- (void)finish;

@end

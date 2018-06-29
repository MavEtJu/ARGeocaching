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

// Read from the configuration
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sGeometry;
@property (nonatomic, retain) NSArray<NSNumber *> *sPosition;
@property (nonatomic, retain) NSArray<NSNumber *> *sScale;

- (void)finish;

@end

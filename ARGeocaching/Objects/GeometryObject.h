//
//  GeometryObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface GeometryObject : NSObject

// References to the real object
@property (nonatomic, retain) SCNGeometry *geometry;

// References to the resolved objects
@property (nonatomic, retain) SCNMaterial *material;
@property (nonatomic, retain) NSArray<SCNMaterial *> *materials;

// Read from the configuration
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sMaterial;
@property (nonatomic, retain) NSArray<NSString *> *sMaterials;

- (void)finish;

@end

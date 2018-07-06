//
//  ObjectManager.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface ObjectManager : NSObject

@property (nonatomic, retain) NSArray<MaterialObject *> *materials;
@property (nonatomic, retain) NSArray<BoxObject *> *boxes;
@property (nonatomic, retain) NSArray<TubeObject *> *tubes;
@property (nonatomic, retain) NSArray<SphereObject *> *spheres;
@property (nonatomic, retain) NSArray<CapsuleObject *> *capsules;
@property (nonatomic, retain) NSArray<CylinderObject *> *cylinders;
@property (nonatomic, retain) NSArray<PlaneObject *> *planes;
@property (nonatomic, retain) NSArray<FloorObject *> *floors;
@property (nonatomic, retain) NSArray<ConeObject *> *cones;
@property (nonatomic, retain) NSArray<TorusObject *> *toruses;
@property (nonatomic, retain) NSArray<PyramidObject *> *pyramids;
@property (nonatomic, retain) NSArray<TextObject *> *texts;
@property (nonatomic, retain) NSArray<LightObject *> *lights;
@property (nonatomic, retain) NSArray<NodeObject *> *nodes;
@property (nonatomic, retain) NSArray<GroupObject *> *groups;

@property (nonatomic        ) float originX;
@property (nonatomic        ) float originY;
@property (nonatomic        ) float originZ;

- (void)loadFile:(NSString *)filename;
- (NSArray<NodeObject *> *)nodesByGroupName:(NSString *)name;
- (NodeObject *)nodeByID:(NSString *)name;

@end

extern ObjectManager *objectManager;

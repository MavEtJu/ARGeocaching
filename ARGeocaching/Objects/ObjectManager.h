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
@property (nonatomic, retain) NSArray<LightObject *> *lights;
@property (nonatomic, retain) NSArray<NodeObject *> *nodes;
@property (nonatomic, retain) NSArray<GroupObject *> *groups;

- (void)loadFile:(NSString *)filename;
- (NSArray<NodeObject *> *)nodesByGroupName:(NSString *)name;
- (NodeObject *)nodeByID:(NSString *)name;
+ (void)position:(SCNNode *)node x:(float)x y:(float)y z:(float)z;
+ (float)positionY:(SCNNode *)node y:(float)y;

@end

extern ObjectManager *objectManager;

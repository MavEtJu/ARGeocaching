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
+ (void)position:(SCNNode *)node x:(float)x y:(float)y z:(float)z;

@end

extern ObjectManager *objectManager;

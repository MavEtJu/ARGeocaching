//
//  GroupObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface GroupObject : NSObject

@property (nonatomic        ) SCNVector3 origin;

@property (nonatomic, retain) NSMutableArray<NodeObject *> *nodes;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray<NSNumber *> *aOrigin;

- (void)finish;

@end

//
//  GroupObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface GroupObject : NSObject

@property (nonatomic, retain) NSMutableArray<NodeObject *> *nodes;
@property (nonatomic, retain) NSString *name;

@end

//
//  TextObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 6/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface TextObject : GeometryObject

@property (nonatomic, retain) NSString *text;
@property (nonatomic        ) float depth;

@property (nonatomic, retain) NSNumber *sDepth;

@end

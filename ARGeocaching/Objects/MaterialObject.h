//
//  MaterialObject.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

@interface MaterialObject : NSObject

// References to the real object
@property (nonatomic, retain) SCNMaterial *material;

// References to the resolved objects
@property (nonatomic, retain) UIImage *image;

// Read from the configuration
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sImage;
@property (nonatomic, retain) NSString *sTransparency;

- (void)finish;

@end

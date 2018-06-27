//
//  Materials.h
//  ARGeocaching
//
//  Created by Edwin Groothuis on 25/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef NS_ENUM(NSInteger, Material) {
    MATERIAL_BRICKS_WHITE12,
    MATERIAL_BRICKS_WHITE4,
    MATERIAL_PILLAR_STONE,
    MATERIAL_GRANITE,
    MATERIAL_GLASS,
    MATERIAL_SEMITRANSPARENT,
    MATERIAL_WALLPAPER,

    MATERIAL_MAX
};

@interface Materials : NSObject

- (SCNMaterial *)getByIndex:(Material)material;
+ (SCNMaterial *)get:(Material)material;

@end

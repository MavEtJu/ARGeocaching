//
//  Materials.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 25/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface Materials ()

@property (nonatomic, retain) NSArray *materials;

@end

@implementation Materials

- (instancetype)init
{
    self = [super init];

    NSMutableArray *materials = [NSMutableArray arrayWithCapacity:20];

#define MATERIAL(__nr__, __img__) { \
    NSAssert(__nr__ == [materials count], @"Wrong order"); \
    SCNMaterial *m = [SCNMaterial material]; \
    UIImage *img = [UIImage imageNamed:__img__]; \
    NSAssert1(img != nil, @"No material image: %@", __img__); \
    m.diffuse.contents = img; \
    [materials addObject:m]; \
}
#define MATERIAL_TRANSPARENCY(__nr__, __img__, __transparent__) { \
    NSAssert(__nr__ == [materials count], @"Wrong order"); \
    SCNMaterial *m = [SCNMaterial material]; \
    UIImage *img = [UIImage imageNamed:__img__]; \
    NSAssert1(img != nil, @"No material image: %@", __img__); \
    m.diffuse.contents = img; \
    m.transparency = __transparent__; \
    [materials addObject:m]; \
}

    MATERIAL(MATERIAL_BRICKS_WHITE12, @"Bricks - White - 12")
    MATERIAL(MATERIAL_BRICKS_WHITE4, @"Bricks - White - 4")
    MATERIAL(MATERIAL_PILLAR_STONE, @"Pillar - Stone")
    MATERIAL(MATERIAL_GRANITE, @"Granite")
    MATERIAL_TRANSPARENCY(MATERIAL_GLASS, @"Glass", 0.1)
    MATERIAL_TRANSPARENCY(MATERIAL_SEMITRANSPARENT, @"Roof - Transparent", 0.1)
    MATERIAL(MATERIAL_WALLPAPER, @"Wallpaper")

    NSAssert([materials count] == MATERIAL_MAX, @"Not enough materials");

    self.materials = materials;

    return self;
}

- (SCNMaterial *)getByIndex:(Material)material
{
    return [self.materials objectAtIndex:material];
}

+ (SCNMaterial *)get:(Material)material
{
    return [materials getByIndex:material];
}

@end

Materials *materials;

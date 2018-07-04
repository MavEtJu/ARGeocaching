//
//  GeometryObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface GeometryObject ()

@end

@implementation GeometryObject

- (void)finish
{
    __block MaterialObject *material = nil;
    NSAssert(self.sMaterials != nil || self.sMaterial != nil, @"No materials defined");
    if (self.sMaterial != nil) {
        [objectManager.materials enumerateObjectsUsingBlock:^(MaterialObject * _Nonnull mo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([mo.name isEqualToString:self.sMaterial] == YES) {
                *stop = YES;
                material = mo;
            }
        }];
        NSAssert1(material != nil, @"Unknown material: %@", self.sMaterial);
        self.material = material.material;
    }
    if (self.sMaterials != nil) {
        NSMutableArray<SCNMaterial *> *materials = [NSMutableArray arrayWithCapacity:6];
        [self.sMaterials enumerateObjectsUsingBlock:^(NSString * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
            material = nil;
            [objectManager.materials enumerateObjectsUsingBlock:^(MaterialObject * _Nonnull mo, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([m isEqualToString:mo.name] == YES) {
                    *stop = YES;
                    material = mo;
                }
            }];
            NSAssert1(material != nil, @"Unknown material: %@", m);
            [materials addObject:material.material];
        }];
        self.materials = materials;
    }
}

- (void)finished
{
    if (self.material != nil)
        self.geometry.materials = @[self.material, self.material, self.material, self.material, self.material, self.material];
    if (self.materials != nil)
        self.geometry.materials = self.materials;
}

@end

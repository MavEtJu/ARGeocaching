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
    NSAssert(self.sMaterial != nil, @"No materials defined");
    if ([self.sMaterial isKindOfClass:[NSString class]] == YES) {
        NSString *sMaterial = (NSString *)self.sMaterial;
        [objectManager.materials enumerateObjectsUsingBlock:^(MaterialObject * _Nonnull mo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([mo.name isEqualToString:sMaterial] == YES) {
                *stop = YES;
                material = mo;
            }
        }];
        NSAssert1(material != nil, @"Unknown material: %@", self.sMaterial);
        self.materials = @[material.material, material.material, material.material, material.material, material.material, material.material];
    }
    if ([self.sMaterial isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray<SCNMaterial *> *materials = [NSMutableArray arrayWithCapacity:6];
        [(NSArray *)self.sMaterial enumerateObjectsUsingBlock:^(NSString * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
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
    self.geometry.materials = self.materials;
}

@end

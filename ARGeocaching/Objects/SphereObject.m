//
//  SphereObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface SphereObject ()

@end

@implementation SphereObject

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

    self.radius = [self.sRadius floatValue];
    self.material = material.material;

    self.geometry = [SCNSphere sphereWithRadius:self.radius];
    if (self.material != nil)
        self.geometry.materials = @[self.material, self.material, self.material, self.material, self.material, self.material];
    if (self.materials != nil)
        self.geometry.materials = self.materials;
}

@end

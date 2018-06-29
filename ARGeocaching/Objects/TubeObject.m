//
//  TubeObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface TubeObject ()

@end

@implementation TubeObject

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

    self.innerRadius = [[self.sRadius objectAtIndex:0] floatValue];
    self.outerRadius = [[self.sRadius objectAtIndex:1] floatValue];
    self.material = material.material;

    self.geometry = [SCNTube tubeWithInnerRadius:self.innerRadius outerRadius:self.outerRadius height:1];
    if (self.material != nil)
        self.geometry.materials = @[self.material, self.material, self.material, self.material, self.material, self.material];
    if (self.materials != nil)
        self.geometry.materials = self.materials;
}

@end

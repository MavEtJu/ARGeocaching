//
//  MaterialObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface MaterialObject ()

@end

@implementation MaterialObject

- (void)finish
{
    UIImage *image = [UIImage imageNamed:self.sImage];
    NSAssert1(image, @"No material image: %@", self.sImage);

    self.image = image;
    self.insideToo = self.sInsideToo == nil ? NO : [self.sInsideToo isEqualToString:@"yes"] == YES ? YES : NO;

    self.material = [SCNMaterial material];
    self.material.diffuse.contents = self.image;
    self.material.doubleSided = self.insideToo;
    if (self.sTransparency != nil)
        self.material.transparency = [self.sTransparency floatValue];
}

@end

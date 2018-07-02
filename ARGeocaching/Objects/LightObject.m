//
//  LightObject.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@implementation LightObject

- (void)finish
{
    self.colour = [UIColor colorWithRed:[[self.sColour objectAtIndex:0] floatValue] green:[[self.sColour objectAtIndex:1] floatValue] blue:[[self.sColour objectAtIndex:2] floatValue] alpha:[[self.sColour objectAtIndex:3] floatValue]];
    if ([self.sType isEqualToString:@"omni"] == YES)
        self.type = SCNLightTypeOmni;
    if ([self.sType isEqualToString:@"directional"] == YES)
        self.type = SCNLightTypeDirectional;
    NSAssert1(self.type != nil, @"Unknown light type: %@", self.sType);

    self.light = [SCNLight light];
    self.light.color = self.colour;
    self.light.type = self.type;
    self.position = [NSValue valueWithSCNVector3:SCNVector3Make([[self.sPosition objectAtIndex:0] floatValue], [[self.sPosition objectAtIndex:1] floatValue], [[self.sPosition objectAtIndex:2] floatValue])];

    self.node = [SCNNode node];
    self.node.light = self.light;
    SCNVector3 v = [self.position SCNVector3Value];
    [ObjectManager position:self.node x:v.x y:v.y z:v.z];
}

@end

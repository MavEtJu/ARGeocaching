//
//  ObjectManager.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 29/6/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface ObjectManager ()

@end

@implementation ObjectManager

- (void)loadFile:(NSString *)filename
{
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename]];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    NSAssert1(json != nil, @"%@", error);

    NSArray<NSDictionary *> *materials = [json objectForKey:@"materials"];
    NSArray<NSDictionary *> *geometries = [json objectForKey:@"geometries"];
    NSArray<NSDictionary *> *nodes = [json objectForKey:@"nodes"];

    NSMutableArray<MaterialObject *> *allMaterials = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<GeometryObject *> *allGeometries = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<NodeObject *> *allNodes = [NSMutableArray arrayWithCapacity:10];

    [materials enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull material, NSUInteger idx, BOOL * _Nonnull stop) {
        MaterialObject *mo = [[MaterialObject alloc] init];
        mo.name = [material objectForKey:@"name"];
        mo.sImage = [material objectForKey:@"image"];
        mo.sTransparency = [material objectForKey:@"transparency"];
        [mo finish];
        [allMaterials addObject:mo];
    }];
    self.materials = allMaterials;

    [geometries enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull geometry, NSUInteger idx, BOOL * _Nonnull stop) {
        GeometryObject *go = [[GeometryObject alloc] init];
        go.name = [geometry objectForKey:@"name"];
        go.sMaterial = [geometry objectForKey:@"material"];
        go.sMaterials = [geometry objectForKey:@"materials"];
        [go finish];
        [allGeometries addObject:go];
    }];
    self.geometries = allGeometries;

    [nodes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([node objectForKey:@"position"] != nil) {
            NodeObject *no = [[NodeObject alloc] init];
            no.name = [node objectForKey:@"name"];
            no.sGeometry = [node objectForKey:@"geometry"];
            no.sScale = [node objectForKey:@"size"];
            no.sPosition = [node objectForKey:@"position"];
            [no finish];
            [allNodes addObject:no];
        }
        [[node objectForKey:@"positions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NodeObject *no = [[NodeObject alloc] init];
            no.name = [node objectForKey:@"name"];
            no.sGeometry = [node objectForKey:@"geometry"];
            no.sScale = [[node objectForKey:@"sizes"] objectAtIndex:idx];
            no.sPosition = [[node objectForKey:@"positions"] objectAtIndex:idx];
            [no finish];
            [allNodes addObject:no];
        }];
    }];
    self.nodes = allNodes;

    NSLog(@"Loaded %ld materials", [self.materials count]);
    NSLog(@"Loaded %ld geometries", [self.geometries count]);
    NSLog(@"Loaded %ld nodes", [self.nodes count]);
}

/*
 * x: left or right from you. Positive is right.
 * y: up or down. Positive is up.
 * z: forward or backwards away from you. Positive is forward.
 */
+ (void)position:(SCNNode *)node x:(float)x y:(float)y z:(float)z
{
#define ORIGINX -5
#define ORIGINZ 1
#define ORIGINY -2

    SCNBox *g = (SCNBox *)node.geometry;
    node.position = SCNVector3Make((x + ORIGINX + node.scale.x * g.width / 2), (y + ORIGINY + node.scale.y * g.height / 2), -(z + ORIGINZ + node.scale.z * g.length / 2));
}

@end

ObjectManager *objectManager;

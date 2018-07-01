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

- (instancetype)init
{
    self = [super init];

    self.materials = [NSArray array];
    self.boxes = [NSArray array];
    self.tubes = [NSArray array];
    self.nodes = [NSArray array];
    self.lights = [NSArray array];
    self.groups = [NSArray array];

    return self;
}

- (void)loadFile:(NSString *)filename
{
    NSLog(@"Loading from %@", filename);
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename]];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    NSAssert1(json != nil, @"%@", error);

    NSArray<NSDictionary *> *materials = [json objectForKey:@"materials"];
    NSArray<NSDictionary *> *boxes = [json objectForKey:@"boxes"];
    NSArray<NSDictionary *> *tubes = [json objectForKey:@"tubes"];
    NSArray<NSDictionary *> *nodes = [json objectForKey:@"nodes"];
    NSArray<NSDictionary *> *lights = [json objectForKey:@"lights"];

    NSMutableArray<MaterialObject *> *allMaterials = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<BoxObject *> *allBoxes = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<TubeObject *> *allTubes = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<NodeObject *> *allNodes = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<LightObject *> *allLights = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray<GroupObject *> *allGroups = [NSMutableArray arrayWithCapacity:10];

    [materials enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull material, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[material objectForKey:@"disabled"] boolValue] == YES)
            return;
        MaterialObject *mo = [[MaterialObject alloc] init];
        mo.name = [material objectForKey:@"name"];
        mo.sImage = [material objectForKey:@"image"];
        mo.sTransparency = [material objectForKey:@"transparency"];
        mo.sInsideToo = [material objectForKey:@"insidetoo"];
        [mo finish];
        [allMaterials addObject:mo];
    }];
    self.materials = [self.materials arrayByAddingObjectsFromArray:allMaterials];

    [boxes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull box, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[box objectForKey:@"disabled"] boolValue] == YES)
            return;
        BoxObject *bo = [[BoxObject alloc] init];
        bo.name = [box objectForKey:@"name"];
        bo.sMaterial = [box objectForKey:@"material"];
        bo.sMaterials = [box objectForKey:@"materials"];
        [bo finish];
        [allBoxes addObject:bo];
    }];
    self.boxes = [self.boxes arrayByAddingObjectsFromArray:allBoxes];

    [tubes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull tube, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[tube objectForKey:@"disabled"] boolValue] == YES)
            return;
        TubeObject *to = [[TubeObject alloc] init];
        to.name = [tube objectForKey:@"name"];
        to.sMaterial = [tube objectForKey:@"material"];
        to.sMaterials = [tube objectForKey:@"materials"];
        to.sRadius = [tube objectForKey:@"radius"];
        [to finish];
        [allTubes addObject:to];
    }];
    self.tubes = [self.tubes arrayByAddingObjectsFromArray:allTubes];

    [nodes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[node objectForKey:@"disabled"] boolValue] == YES)
            return;
        if ([node objectForKey:@"position"] != nil) {
            NodeObject *no = [[NodeObject alloc] init];
            no.name = [node objectForKey:@"name"];
            no.sGeometry = [node objectForKey:@"geometry"];
            no.sScale = [node objectForKey:@"size"];
            no.sPosition = [node objectForKey:@"position"];
            no.sID = [node objectForKey:@"id"];
            [no finish];
            [allNodes addObject:no];

            NSString *group = [node objectForKey:@"group"];
            if (group != nil)
                [self addToGroup:group node:no groups:allGroups];
        }
        [[node objectForKey:@"positions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NodeObject *no = [[NodeObject alloc] init];
            no.name = [node objectForKey:@"name"];
            no.sGeometry = [node objectForKey:@"geometry"];
            no.sScale = [[node objectForKey:@"sizes"] objectAtIndex:idx];
            no.sPosition = [[node objectForKey:@"positions"] objectAtIndex:idx];
            no.sID = [[node objectForKey:@"ids"] objectAtIndex:idx];
            [no finish];
            [allNodes addObject:no];

            NSString *group = [node objectForKey:@"group"];
            if (group != nil)
                [self addToGroup:group node:no groups:allGroups];
        }];
    }];
    self.nodes = [self.nodes arrayByAddingObjectsFromArray:allNodes];

    [lights enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull light, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[light objectForKey:@"disabled"] boolValue] == YES)
            return;
        if ([light objectForKey:@"position"] != nil) {
            LightObject *lo = [[LightObject alloc] init];
            lo.name = [light objectForKey:@"name"];
            lo.sColour = [light objectForKey:@"colour"];
            lo.sType = [light objectForKey:@"type"];
            lo.sPosition = [light objectForKey:@"position"];
            [lo finish];
            [allLights addObject:lo];

            NSString *group = [light objectForKey:@"group"];
            if (group != nil)
                [self addToGroup:group node:lo groups:allGroups];
        }
        [[light objectForKey:@"positions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LightObject *lo = [[LightObject alloc] init];
            lo.name = [light objectForKey:@"name"];
            lo.sColour = [light objectForKey:@"colour"];
            lo.sType = [light objectForKey:@"type"];
            lo.sPosition = [[light objectForKey:@"positions"] objectAtIndex:idx];
            [lo finish];
            [allLights addObject:lo];

            NSString *group = [light objectForKey:@"group"];
            if (group != nil)
                [self addToGroup:group node:lo groups:allGroups];
        }];
    }];
    self.lights = [self.lights arrayByAddingObjectsFromArray:allLights];

    self.groups = [self.groups arrayByAddingObjectsFromArray:allGroups];

    NSLog(@"Loaded %ld materials", [self.materials count]);
    NSLog(@"Loaded %ld boxes", [self.boxes count]);
    NSLog(@"Loaded %ld tubes", [self.tubes count]);
    NSLog(@"Loaded %ld nodes", [self.nodes count]);
    NSLog(@"Loaded %ld lights", [self.lights count]);
    NSLog(@"Loaded %ld groups", [self.groups count]);
}

- (void)addToGroup:(NSString *)name node:(id)node groups:(NSMutableArray<GroupObject *> *)groups
{
    __block GroupObject *group = nil;
    [groups enumerateObjectsUsingBlock:^(GroupObject * _Nonnull g, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([g.name isEqualToString:name] == YES) {
            *stop = YES;
            group = g;
        }
    }];
    if (group == nil) {
        group = [[GroupObject alloc] init];
        group.name = name;
        [groups addObject:group];
    }
    [group.nodes addObject:node];
    ((NodeObject *)node).group = group;
}

/*
 * x: left or right from you. Positive is right.
 * y: up or down. Positive is up.
 * z: forward or backwards away from you. Positive is forward.
 */
+ (void)position:(SCNNode *)node x:(float)x y:(float)y z:(float)z
{
#define ORIGINX -5
#define ORIGINZ 2
#define ORIGINY -2   // 15

    if (node.geometry == nil) {
        node.position = SCNVector3Make((x + ORIGINX), (y + ORIGINY), -(z + ORIGINZ));
    } else if ([node.geometry isKindOfClass:[SCNBox class]] == YES) {
//        [node.geometry isKindOfClass:[SCNLight class]] == YES) {
        SCNBox *g = (SCNBox *)node.geometry;
        node.position = SCNVector3Make((x + ORIGINX + node.scale.x * g.width / 2), (y + ORIGINY + node.scale.y * g.height / 2), -(z + ORIGINZ + node.scale.z * g.length / 2));
    } else if ([node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)node.geometry;
        node.position = SCNVector3Make((x + ORIGINX), (y + ORIGINY + node.scale.y * g.height / 2), -(z + ORIGINZ));
    } else {
        NSAssert1(NO, @"Unknown class: %@", [node.geometry class]);
    }
}

+ (float)positionY:(SCNNode *)node y:(float)y
{

    if (node.geometry == nil) {
        return (y + ORIGINY);
    } else if ([node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)node.geometry;
        return (y + ORIGINY + node.scale.y * g.height / 2);
    } else if ([node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)node.geometry;
        return (y + ORIGINY + node.scale.y * g.height / 2);
    } else {
        NSAssert1(NO, @"Unknown class: %@", [node.geometry class]);
    }
    return -1;
}

- (NSArray<NodeObject *> *)nodesByGroupName:(NSString *)name
{
    __block GroupObject *group = nil;
    [self.groups enumerateObjectsUsingBlock:^(GroupObject * _Nonnull g, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([g.name isEqualToString:name] == YES) {
            *stop = YES;
            group = g;
        }
    }];
    return group.nodes;
}

- (NodeObject *)nodeByID:(NSString *)name
{
    __block NodeObject *node = nil;
    [self.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([n.sID isEqualToString:name] == YES) {
            *stop = YES;
            node = n;
        }
    }];
    return node;
}

@end

ObjectManager *objectManager;

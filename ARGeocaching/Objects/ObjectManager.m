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
    self.spheres = [NSArray array];
    self.capsules = [NSArray array];
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
    NSArray<NSDictionary *> *spheres = [json objectForKey:@"spheres"];
    NSArray<NSDictionary *> *capsules = [json objectForKey:@"capsules"];
    NSArray<NSDictionary *> *lights = [json objectForKey:@"lights"];

    NSArray<NSNumber *> *origins = [json objectForKey:@"origin"];
    if (origins != nil) {
        self.originX = [[origins objectAtIndex:0] floatValue];
        self.originY = [[origins objectAtIndex:1] floatValue];
        self.originZ = [[origins objectAtIndex:2] floatValue];
    }

    NSMutableArray<MaterialObject *> *allMaterials = [NSMutableArray array];
    NSMutableArray<BoxObject *> *allBoxes = [NSMutableArray array];
    NSMutableArray<TubeObject *> *allTubes = [NSMutableArray array];
    NSMutableArray<NodeObject *> *allNodes = [NSMutableArray array];
    NSMutableArray<SphereObject *> *allSpheres = [NSMutableArray array];
    NSMutableArray<CapsuleObject *> *allCapsules = [NSMutableArray array];
    NSMutableArray<LightObject *> *allLights = [NSMutableArray array];
    NSMutableArray<GroupObject *> *allGroups = [NSMutableArray array];

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

    [spheres enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sphere, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[sphere objectForKey:@"disabled"] boolValue] == YES)
        return;
        SphereObject *so = [[SphereObject alloc] init];
        so.name = [sphere objectForKey:@"name"];
        so.sMaterial = [sphere objectForKey:@"material"];
        so.sMaterials = [sphere objectForKey:@"materials"];
        so.sRadius = [sphere objectForKey:@"radius"];
        [so finish];
        [allSpheres addObject:so];
    }];
    self.spheres = [self.spheres arrayByAddingObjectsFromArray:allSpheres];

    [capsules enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull capsule, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[capsule objectForKey:@"disabled"] boolValue] == YES)
            return;
        CapsuleObject *co = [[CapsuleObject alloc] init];
        co.name = [capsule objectForKey:@"name"];
        co.sMaterial = [capsule objectForKey:@"material"];
        co.sMaterials = [capsule objectForKey:@"materials"];
        co.sRadius = [capsule objectForKey:@"radius"];
        [co finish];
        [allCapsules addObject:co];
    }];
    self.capsules = [self.capsules arrayByAddingObjectsFromArray:allCapsules];

    [nodes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull groupdata, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[groupdata objectForKey:@"disabled"] boolValue] == YES)
            return;
        GroupObject *group = [[GroupObject alloc] init];
        group.name = [groupdata objectForKey:@"group"];
        group.aOrigin = [groupdata objectForKey:@"origin"];
        [group finish];
        [allGroups addObject:group];

        NSMutableArray<NodeObject *> *groupNodes = [NSMutableArray array];

        [[groupdata objectForKey:@"objects"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {

            if ([[node objectForKey:@"disabled"] boolValue] == YES)
                return;
            if ([node objectForKey:@"position"] != nil) {
                NodeObject *no = [[NodeObject alloc] init];
                no.name = [node objectForKey:@"name"];
                no.sGeometry = [node objectForKey:@"geometry"];
                no.sScale = [node objectForKey:@"size"];
                no.sPosition = [node objectForKey:@"position"];
                no.sID = [node objectForKey:@"id"];
                no.group = group;
                [no finish];
                [allNodes addObject:no];
                [groupNodes addObject:no];
            }
            [[node objectForKey:@"positions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NodeObject *no = [[NodeObject alloc] init];
                no.name = [node objectForKey:@"name"];
                no.sGeometry = [node objectForKey:@"geometry"];
                no.sScale = [[node objectForKey:@"sizes"] objectAtIndex:idx];
                no.sPosition = [[node objectForKey:@"positions"] objectAtIndex:idx];
                no.sID = [[node objectForKey:@"ids"] objectAtIndex:idx];
                no.group = group;
                [no finish];
                [allNodes addObject:no];
                [groupNodes addObject:no];
            }];
        }];
        group.nodes = groupNodes;
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
        }
        [[light objectForKey:@"positions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LightObject *lo = [[LightObject alloc] init];
            lo.name = [light objectForKey:@"name"];
            lo.sColour = [light objectForKey:@"colour"];
            lo.sType = [light objectForKey:@"type"];
            lo.sPosition = [[light objectForKey:@"positions"] objectAtIndex:idx];
            [lo finish];
            [allLights addObject:lo];
        }];
    }];
    self.lights = [self.lights arrayByAddingObjectsFromArray:allLights];

    self.groups = [self.groups arrayByAddingObjectsFromArray:allGroups];

    NSLog(@"Loaded %ld materials", [self.materials count]);
    NSLog(@"Loaded %ld boxes", [self.boxes count]);
    NSLog(@"Loaded %ld tubes", [self.tubes count]);
    NSLog(@"Loaded %ld spheres", [self.spheres count]);
    NSLog(@"Loaded %ld nodes", [self.nodes count]);
    NSLog(@"Loaded %ld lights", [self.lights count]);
    NSLog(@"Loaded %ld groups", [self.groups count]);
}

/*
 * x: left or right from you. Positive is right.
 * y: up or down. Positive is up.
 * z: forward or backwards away from you. Positive is forward.
 */
+ (void)position:(SCNNode *)node x:(float)x y:(float)y z:(float)z
{
    if (node.geometry == nil) {
        node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY), -(z - objectManager.originZ));
    } else if ([node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)node.geometry;
        node.position = SCNVector3Make((x - objectManager.originX + node.scale.x * g.width / 2), (y - objectManager.originY + node.scale.y * g.height / 2), -(z - objectManager.originZ + node.scale.z * g.length / 2));
    } else if ([node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)node.geometry;
        node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + node.scale.y * g.height / 2), -(z - objectManager.originZ));
    } else if ([node.geometry isKindOfClass:[SCNCapsule class]] == YES) {
        SCNCapsule *g = (SCNCapsule *)node.geometry;
        node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + node.scale.y * g.height / 2), -(z - objectManager.originZ));
    } else if ([node.geometry isKindOfClass:[SCNSphere class]] == YES) {
        SCNSphere *g = (SCNSphere *)node.geometry;
        node.position = SCNVector3Make((x - objectManager.originX), (y - objectManager.originY + node.scale.y * g.radius / 2), -(z - objectManager.originZ));
    } else {
        NSAssert1(NO, @"Unknown class: %@", [node.geometry class]);
    }
}

+ (float)positionY:(SCNNode *)node y:(float)y
{

    if (node.geometry == nil) {
        return (y - objectManager.originY);
    } else if ([node.geometry isKindOfClass:[SCNBox class]] == YES) {
        SCNBox *g = (SCNBox *)node.geometry;
        return (y - objectManager.originY + node.scale.y * g.height / 2);
    } else if ([node.geometry isKindOfClass:[SCNTube class]] == YES) {
        SCNTube *g = (SCNTube *)node.geometry;
        return (y - objectManager.originY + node.scale.y * g.height / 2);
    } else if ([node.geometry isKindOfClass:[SCNSphere class]] == YES) {
        SCNSphere *g = (SCNSphere *)node.geometry;
        return (y - objectManager.originY + node.scale.y * g.radius / 2);
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

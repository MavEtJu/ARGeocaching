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
    self.cylinders = [NSArray array];
    self.lights = [NSArray array];
    self.groups = [NSArray array];
    self.planes = [NSArray array];
    self.pyramids = [NSArray array];
    self.floors = [NSArray array];
    self.toruses = [NSArray array];
    self.cones = [NSArray array];

    return self;
}

- (void)loadFile:(NSString *)filename
{
    NSLog(@"Loading from %@", filename);
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename]];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    NSAssert1(json != nil, @"%@", error);

    NSArray<NSNumber *> *origins = [json objectForKey:@"origin"];
    if (origins != nil) {
        self.originX = [[origins objectAtIndex:0] floatValue];
        self.originY = [[origins objectAtIndex:1] floatValue];
        self.originZ = [[origins objectAtIndex:2] floatValue];
    }

    NSMutableArray<id> *all = [NSMutableArray array];
    NSMutableArray<GroupObject *> *allGroups = [NSMutableArray array];

    [all removeAllObjects];
    [[json objectForKey:@"materials"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull material, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[material objectForKey:@"disabled"] boolValue] == YES)
            return;
        MaterialObject *mo = [[MaterialObject alloc] init];
        mo.name = [material objectForKey:@"name"];
        mo.sImage = [material objectForKey:@"image"];
        mo.sTransparency = [material objectForKey:@"transparency"];
        mo.sInsideToo = [material objectForKey:@"insidetoo"];
        [mo finish];
        [all addObject:mo];
    }];
    self.materials = [self.materials arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"boxes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull box, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[box objectForKey:@"disabled"] boolValue] == YES)
            return;
        BoxObject *bo = [[BoxObject alloc] init];
        bo.name = [box objectForKey:@"name"];
        bo.sMaterial = [box objectForKey:@"material"];
        [bo finish];
        [all addObject:bo];
    }];
    self.boxes = [self.boxes arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"tubes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull tube, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[tube objectForKey:@"disabled"] boolValue] == YES)
        return;
        TubeObject *to = [[TubeObject alloc] init];
        to.name = [tube objectForKey:@"name"];
        to.sMaterial = [tube objectForKey:@"material"];
        to.sRadius = [tube objectForKey:@"radius"];
        [to finish];
        [all addObject:to];
    }];
    self.tubes = [self.tubes arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"spheres"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sphere, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[sphere objectForKey:@"disabled"] boolValue] == YES)
            return;
        SphereObject *so = [[SphereObject alloc] init];
        so.name = [sphere objectForKey:@"name"];
        so.sMaterial = [sphere objectForKey:@"material"];
        so.sRadius = [sphere objectForKey:@"radius"];
        [so finish];
        [all addObject:so];
    }];
    self.spheres = [self.spheres arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"capsules"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull capsule, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[capsule objectForKey:@"disabled"] boolValue] == YES)
        return;
        CapsuleObject *co = [[CapsuleObject alloc] init];
        co.name = [capsule objectForKey:@"name"];
        co.sMaterial = [capsule objectForKey:@"material"];
        co.sRadius = [capsule objectForKey:@"radius"];
        [co finish];
        [all addObject:co];
    }];
    self.capsules = [self.capsules arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"cylinders"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cylinder, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[cylinder objectForKey:@"disabled"] boolValue] == YES)
        return;
        CylinderObject *co = [[CylinderObject alloc] init];
        co.name = [cylinder objectForKey:@"name"];
        co.sMaterial = [cylinder objectForKey:@"material"];
        co.sRadius = [cylinder objectForKey:@"radius"];
        [co finish];
        [all addObject:co];
    }];
    self.cylinders = [self.cylinders arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"planes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull plane, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[plane objectForKey:@"disabled"] boolValue] == YES)
        return;
        PlaneObject *po = [[PlaneObject alloc] init];
        po.name = [plane objectForKey:@"name"];
        po.sMaterial = [plane objectForKey:@"material"];
        [po finish];
        [all addObject:po];
    }];
    self.planes = [self.planes arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"pyramids"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull pyramid, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[pyramid objectForKey:@"disabled"] boolValue] == YES)
        return;
        PyramidObject *po = [[PyramidObject alloc] init];
        po.name = [pyramid objectForKey:@"name"];
        po.sMaterial = [pyramid objectForKey:@"material"];
        [po finish];
        [all addObject:po];
    }];
    self.pyramids = [self.pyramids arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"toruses"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull torus, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[torus objectForKey:@"disabled"] boolValue] == YES)
        return;
        TorusObject *to = [[TorusObject alloc] init];
        to.name = [torus objectForKey:@"name"];
        to.sMaterial = [torus objectForKey:@"material"];
        to.sRadius = [torus objectForKey:@"radius"];
        [to finish];
        [all addObject:to];
    }];
    self.toruses = [self.toruses arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"cones"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cone, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[cone objectForKey:@"disabled"] boolValue] == YES)
        return;
        ConeObject *co = [[ConeObject alloc] init];
        co.name = [cone objectForKey:@"name"];
        co.sMaterial = [cone objectForKey:@"material"];
        co.sRadius = [cone objectForKey:@"radius"];
        [co finish];
        [all addObject:co];
    }];
    self.cones = [self.cones arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"floors"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull floor, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[floor objectForKey:@"disabled"] boolValue] == YES)
            return;
        FloorObject *fo = [[FloorObject alloc] init];
        fo.name = [floor objectForKey:@"name"];
        fo.sMaterial = [floor objectForKey:@"material"];
        [fo finish];
        [all addObject:fo];
    }];
    self.floors = [self.floors arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"nodes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull groupdata, NSUInteger idx, BOOL * _Nonnull stop) {
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
            NSObject *sPosition = [[node objectForKey:@"position"] objectAtIndex:0];
            if ([sPosition isKindOfClass:[NSNumber class]] == YES) {
                NodeObject *no = [[NodeObject alloc] init];
                no.name = [node objectForKey:@"name"];
                no.sGeometry = [node objectForKey:@"geometry"];
                no.sScale = [node objectForKey:@"size"];
                no.sPosition = [node objectForKey:@"position"];
                no.sRotation = [node objectForKey:@"rotation"];
                no.sID = [node objectForKey:@"id"];
                no.group = group;
                [no finish];
                [all addObject:no];
                [groupNodes addObject:no];
            }
            if ([sPosition isKindOfClass:[NSArray class]] == YES) {
                [[node objectForKey:@"position"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NodeObject *no = [[NodeObject alloc] init];
                    no.name = [node objectForKey:@"name"];
                    no.sGeometry = [node objectForKey:@"geometry"];
                    no.sScale = [[node objectForKey:@"size"] objectAtIndex:idx];
                    no.sPosition = [[node objectForKey:@"position"] objectAtIndex:idx];
                    no.sRotation = [[node objectForKey:@"rotation"] objectAtIndex:idx];
                    no.sID = [[node objectForKey:@"id"] objectAtIndex:idx];
                    no.group = group;
                    [no finish];
                    [all addObject:no];
                    [groupNodes addObject:no];
                }];
            }
        }];
        group.nodes = groupNodes;
    }];
    self.nodes = [self.nodes arrayByAddingObjectsFromArray:all];

    [all removeAllObjects];
    [[json objectForKey:@"lights"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull light, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[light objectForKey:@"disabled"] boolValue] == YES)
        return;

        NSObject *sPosition = [[light objectForKey:@"position"] objectAtIndex:0];
        if ([sPosition isKindOfClass:[NSNumber class]] == YES) {
            LightObject *lo = [[LightObject alloc] init];
            lo.name = [light objectForKey:@"name"];
            lo.sColour = [light objectForKey:@"colour"];
            lo.sType = [light objectForKey:@"type"];
            lo.sPosition = [light objectForKey:@"position"];
            lo.sRotation = [light objectForKey:@"rotation"];
            [lo finish];
            [all addObject:lo];
        }
        if ([sPosition isKindOfClass:[NSArray class]] == YES) {
            [[light objectForKey:@"position"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LightObject *lo = [[LightObject alloc] init];
                lo.name = [light objectForKey:@"name"];
                lo.sColour = [light objectForKey:@"colour"];
                lo.sType = [light objectForKey:@"type"];
                lo.sPosition = [[light objectForKey:@"position"] objectAtIndex:idx];
                lo.sRotation = [[light objectForKey:@"rotation"] objectAtIndex:idx];
                [lo finish];
                [all addObject:lo];
            }];
        }
    }];
    self.lights = [self.lights arrayByAddingObjectsFromArray:all];

    self.groups = [self.groups arrayByAddingObjectsFromArray:allGroups];

    NSLog(@"Loaded %ld materials", [self.materials count]);
    NSLog(@"Loaded %ld boxes", [self.boxes count]);
    NSLog(@"Loaded %ld tubes", [self.tubes count]);
    NSLog(@"Loaded %ld spheres", [self.spheres count]);
    NSLog(@"Loaded %ld nodes", [self.nodes count]);
    NSLog(@"Loaded %ld lights", [self.lights count]);
    NSLog(@"Loaded %ld groups", [self.groups count]);
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

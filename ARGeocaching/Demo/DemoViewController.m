//
//  GAxxxxViewController.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

typedef NS_ENUM(NSInteger, GameStage) {
    STAGE_BOXES = 0,
    STAGE_TEXTS,
    STAGE_PLANES,
    STAGE_CONES,
    STAGE_TORUSES,
    STAGE_PYRAMIDS,
    STAGE_CYLINDERS,
    STAGE_SPHERES,
    STAGE_TUBES,
    STAGE_CAPSULES,

    STAGE_MAX
};


@interface DemoViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic        ) float boxLength;
@property (nonatomic        ) float boxWidth;
@property (nonatomic        ) float boxHeight;
@property (nonatomic        ) float floorHeight;

@property (nonatomic        ) BOOL animating;

@property (nonatomic        ) GameStage stage;

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    objectManager = [[ObjectManager alloc] init];
    [objectManager loadFile:@"Demo.json"];

    self.queue = [[NSOperationQueue alloc] init];
    self.stage = STAGE_BOXES;

    [self loadFloor];

    [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
        n.node.hidden = YES;
    }];
    [[objectManager nodesByGroupName:@"boxes"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
        n.node.hidden = NO;
    }];

    //    self.sceneView.autoenablesDefaultLighting = NO;
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;
}

- (void)loadFloor
{
    // Container to hold all of the 3D geometry
    SCNScene *scene = [SCNScene new];

    [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        [scene.rootNode addChildNode:node.node];
    }];
    [objectManager.lights enumerateObjectsUsingBlock:^(LightObject * _Nonnull light, NSUInteger idx, BOOL * _Nonnull stop) {
        [scene.rootNode addChildNode:light.node];
    }];

    // Set the scene to the view
    self.sceneView.scene = scene;

    [self performAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];

    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.sceneView.session pause];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    NSValue *v = [NSValue valueWithCGPoint:p];
    NSLog(@"%@", v);

    // Touch at top right
    if (p.x > 550 && p.y < 120) {
        CGFloat dx, dz;

        dz = (p.y < 60) ? 0.6 : -0.6;
        dx = (p.x > 640) ? -0.6 : 0.6;

        [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
            n.node.position = SCNVector3Make(n.node.position.x + dx, n.node.position.y, n.node.position.z + dz);
        }];

        return;
    }

    // Touch on nodes
    NSArray <SCNHitTestResult *> *res = [self.sceneView hitTest:[[touches anyObject] locationInView:self.sceneView] options:@{SCNHitTestFirstFoundOnlyKey:@YES}];
    if (res.count != 0) {

        // SCNHitTestResult *result = res.lastObject;
        // SCNNode *block = result.node;

        self.animating = !self.animating;
        if (self.animating == YES)
            [self performAction];
    } else {
        [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
            n.node.hidden = YES;
        }];
        self.stage = (self.stage + 1) % STAGE_MAX;
        NSArray<NodeObject *> *nodes;
        switch (self.stage) {
            case STAGE_BOXES:
                nodes = [objectManager nodesByGroupName:@"boxes"];
                break;
            case STAGE_TUBES:
                nodes = [objectManager nodesByGroupName:@"tubes"];
                break;
            case STAGE_CAPSULES:
                nodes = [objectManager nodesByGroupName:@"capsules"];
                break;
            case STAGE_SPHERES:
                nodes = [objectManager nodesByGroupName:@"spheres"];
                break;
            case STAGE_CYLINDERS:
                nodes = [objectManager nodesByGroupName:@"cylinders"];
                break;
            case STAGE_PYRAMIDS:
                nodes = [objectManager nodesByGroupName:@"pyramids"];
                break;
            case STAGE_TORUSES:
                nodes = [objectManager nodesByGroupName:@"toruses"];
                break;
            case STAGE_CONES:
                nodes = [objectManager nodesByGroupName:@"cones"];
                break;
            case STAGE_PLANES:
                nodes = [objectManager nodesByGroupName:@"planes"];
                break;
            case STAGE_TEXTS:
                nodes = [objectManager nodesByGroupName:@"texts"];
                break;
            case STAGE_MAX:
                break;
        }
        NSAssert(nodes != nil, @"No nodes found");
        [nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
            n.node.hidden = NO;
        }];

    }
}

- (void)performAction
{
#define FIND(__variable__, __name__) \
    NodeObject *__variable__ = [objectManager nodeByID:__name__]; \
    NSAssert1(__variable__ != nil, @"Node '%@' not found", __name__);

    NSArray<NodeObject *> *nodes = nil;
    NodeObject *left = nil;
    switch (self.stage) {
        case STAGE_BOXES: {
            nodes = [objectManager nodesByGroupName:@"boxes"];
            left = [objectManager nodeByID:@"large box #1"];
            break;
        }
        case STAGE_TUBES: {
            nodes = [objectManager nodesByGroupName:@"tubes"];
            left = [objectManager nodeByID:@"large tube #1"];
            break;
        }
        case STAGE_CAPSULES: {
            nodes = [objectManager nodesByGroupName:@"capsules"];
            left = [objectManager nodeByID:@"large capsule #1"];
            break;
        }
        case STAGE_SPHERES: {
            nodes = [objectManager nodesByGroupName:@"spheres"];
            left = [objectManager nodeByID:@"large sphere #1"];
            break;
        }
        case STAGE_CYLINDERS: {
            nodes = [objectManager nodesByGroupName:@"cylinders"];
            left = [objectManager nodeByID:@"large cylinder #1"];
            break;
        }
        case STAGE_PYRAMIDS: {
            nodes = [objectManager nodesByGroupName:@"pyramids"];
            left = [objectManager nodeByID:@"large pyramid #1"];
            break;
        }
        case STAGE_TORUSES: {
            nodes = [objectManager nodesByGroupName:@"toruses"];
            left = [objectManager nodeByID:@"large torus #1"];
            break;
        }
        case STAGE_CONES: {
            nodes = [objectManager nodesByGroupName:@"cones"];
            left = [objectManager nodeByID:@"large cone #1"];
            break;
        }
        case STAGE_PLANES: {
            nodes = [objectManager nodesByGroupName:@"planes"];
            left = [objectManager nodeByID:@"large plane #1"];
            break;
        }
        case STAGE_TEXTS: {
            nodes = [objectManager nodesByGroupName:@"texts"];
            left = [objectManager nodeByID:@"large text #1"];
            break;
        }

        case STAGE_MAX:
        break;
    }

    NSAssert(nodes != nil, @"No nodes");
    NSAssert(left != nil, @"No left-hand object");

    [self.queue addOperationWithBlock:^{
        float dx = -0.1;
        float dy = -0.1;
        float dz = -0.2;
        while (self.animating == YES) {
            [NSThread sleepForTimeInterval:0.1];
            [nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                n.node.position = SCNVector3Make(n.node.position.x + dx, n.node.position.y + dy, n.node.position.z + dz);
                n.node.rotation = SCNVector4Make(n.node.rotation.x, n.node.rotation.y, n.node.rotation.z, n.node.rotation.w + GLKMathDegreesToRadians(10));
            }];

            if ([left jsonPositionX] < -3) dx = +0.1;
            if ([left jsonPositionX] > 3) dx = -0.1;
            if ([left jsonPositionY] < 0) dy = +0.1;
            if ([left jsonPositionY] > 3) dy = -0.1;
            if ([left jsonPositionZ] < 0) dz = -0.1;
            if ([left jsonPositionZ] > 3) dz = +0.1;
        }
    }];
}


@end

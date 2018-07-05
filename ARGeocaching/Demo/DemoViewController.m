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

        SCNHitTestResult *result = res.lastObject;
        SCNNode *block = result.node;

        self.animating = !self.animating;
        if (self.animating == YES)
            [self performAction];
    }
}

- (void)performAction
{
#define FIND(__variable__, __name__) \
    NodeObject *__variable__ = [objectManager nodeByID:__name__]; \
    NSAssert1(__variable__ != nil, @"Node '%@' not found", __name__);
    FIND(boxLarge1, @"large box #1")
    FIND(boxLarge2, @"large box #2")
    FIND(boxSmall1, @"small box #1")
    FIND(boxSmall2, @"small box #2")

    switch (self.stage) {
        case STAGE_BOXES: {
            [self.queue addOperationWithBlock:^{
                float dx = -0.1;
                float dy = -0.1;
                float dz = -0.2;
                float angle = 0;
                while (self.animating == YES) {
                    [NSThread sleepForTimeInterval:0.1];
                    [[objectManager nodesByGroupName:@"boxes"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
//                        n.node.position = SCNVector3Make(n.node.position.x + dx, n.node.position.y + dy, n.node.position.z + dz);
                        n.node.rotation = SCNVector4Make(0, 0, 1, angle);
                    }];

                    NSLog(@"%f - %f - %f",
                          [boxSmall1 jsonPositionX], [boxSmall1 jsonPositionY], [boxSmall1 jsonPositionZ]);
                    if ([boxSmall1 jsonPositionX] < -3) dx = +0.1;
                    if ([boxSmall1 jsonPositionX] > 3) dx = -0.1;
                    if ([boxSmall1 jsonPositionY] < 0) dy = +0.1;
                    if ([boxSmall1 jsonPositionY] > 3) dy = -0.1;
                    if ([boxSmall1 jsonPositionZ] < 0) dz = -0.1;
                    if ([boxSmall1 jsonPositionZ] > 3) dz = +0.1;
                    angle += GLKMathDegreesToRadians(10);
                }
            }];
            break;
        }
    }
}


@end

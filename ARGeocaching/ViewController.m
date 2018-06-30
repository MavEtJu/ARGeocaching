//
//  ViewController.m
//  TestAR
//
//  Created by Edwin Groothuis on 10/3/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

typedef NS_ENUM(NSInteger, CageStage) {
    CAGE_START = 0,
    CAGE_GOING_TO_BEGIN,
    CAGE_BEGIN,
    CAGE_GOING_UP,
    CAGE_TOP,
    CAGE_GOING_DOWN,
    CAGE_DOWN
};

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic)         float boxLength;
@property (nonatomic)         float boxWidth;
@property (nonatomic)         float boxHeight;
@property (nonatomic)         float floorHeight;

@property (nonatomic)         CageStage cageStage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.queue = [[NSOperationQueue alloc] init];
    self.cageStage = CAGE_START;

    [self loadFloor];

    self.sceneView.autoenablesDefaultLighting = NO;
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;
}

/*
 * x: left or right from you. Positive is right.
 * y: up or down. Positive is up.
 * z: forward or backwards away from you. Positive is forward.
 */

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

    [self changeCageLevel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.lightEstimationEnabled = NO;

    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tap");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.vectors = [[NSMutableArray alloc] init];
    NSArray <SCNHitTestResult *> *res = [self.sceneView hitTest:[[touches anyObject] locationInView:self.sceneView] options:@{SCNHitTestFirstFoundOnlyKey:@YES}];
    if (res.count != 0) {
        SCNHitTestResult *result = res.lastObject;
        SCNNode *block = result.node;
//        if ([[block class] isEqual:[SCNFloorTile class]] == NO)
//            return;


        SCNNode *n = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0]];
        n.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
        n.position = result.worldCoordinates;
        [self.sceneView.scene.rootNode addChildNode:n];
        [self changeCageLevel];
    }
}

- (void)changeCageLevel
{
    switch (self.cageStage) {
        case CAGE_START: {
            self.cageStage = CAGE_GOING_TO_BEGIN;
            [self.queue addOperationWithBlock:^{
                NodeObject *roof = [objectManager nodeByID:@"cage roof"];
                NSAssert(roof != nil, @"No cage roof");
                while (roof.node.position.y > -2) {
                    [NSThread sleepForTimeInterval:0.1];
                    [[objectManager nodesByGroupName:@"cage"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y - 0.1, n.node.position.z);
                    }];
                }
                self.cageStage = CAGE_BEGIN;
            }];
            break;
        }

        case CAGE_BEGIN: {
            self.cageStage = CAGE_GOING_UP;
            [self.queue addOperationWithBlock:^{
                NodeObject *floor = [objectManager nodeByID:@"cage floor"];
                NSAssert(floor != nil, @"No cage floor");
                while (floor.node.position.y < -2) {
                    [NSThread sleepForTimeInterval:0.1];
                    [[objectManager nodesByGroupName:@"cage"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y + 0.1, n.node.position.z);
                    }];
                }
                self.cageStage = CAGE_TOP;
            }];
            break;
        }

        case CAGE_TOP: {
            self.cageStage = CAGE_GOING_DOWN;
            [self.queue addOperationWithBlock:^{
                NodeObject *bottom = [objectManager nodeByID:@"cage bottom"];
                NSAssert(bottom != nil, @"No cage bottom");
                while (bottom.node.position.y < -2) {
                    [NSThread sleepForTimeInterval:0.1];
                    [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([n.group.name isEqualToString:@"cage"] == YES)
                            return;
                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y + 0.1, n.node.position.z);
                    }];
                }
                self.cageStage = CAGE_DOWN;
            }];
            break;
        }

        case CAGE_DOWN:
            break;

        case CAGE_GOING_TO_BEGIN:
        case CAGE_GOING_DOWN:
        case CAGE_GOING_UP:
            break;
    }
}

@end

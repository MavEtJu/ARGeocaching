//
//  GAxxxxViewController.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 4/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

typedef NS_ENUM(NSInteger, GameStage) {
    STAGE_START = 0,
    STAGE_GOING_TO_INITIAL,
    STAGE_AT_INITIAL,
    STAGE_GOING_TO_GAME_1,
    STAGE_AT_GAME_1,
    STAGE_FINISHED_GAME_1,
    STAGE_GOING_TO_GAME_2,
    STAGE_AT_GAME_2,
    STAGE_FINISHED_GAME_2,
};


@interface GAxxxxxViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic)         float boxLength;
@property (nonatomic)         float boxWidth;
@property (nonatomic)         float boxHeight;
@property (nonatomic)         float floorHeight;

@property (nonatomic)         GameStage stage;

@end

@implementation GAxxxxxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    objectManager = [[ObjectManager alloc] init];
    [objectManager loadFile:@"Totem Pole.json"];

    self.queue = [[NSOperationQueue alloc] init];
    self.stage = STAGE_START;

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


#define FIND(__var__, __name__) \
    NodeObject *__var__ = [objectManager nodeByID:__name__]; \
    NSAssert1(__var__ != nil, @"No '%@'", __name__);

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

        switch (self.stage) {
            case STAGE_AT_INITIAL: {
                NSLog(@"STAGE_AT_INITIAL");
                FIND(n, @"Layer 0")
                if (n.node != block)
                    break;
                self.stage = STAGE_GOING_TO_GAME_1;
                [self performAction];
                break;
            }

            case STAGE_AT_GAME_1: {
                NSLog(@"STAGE_AT_GAME_1");
                FIND(ball1, @"game 1 - 1")
                FIND(ball2, @"game 1 - 2")
                FIND(ball3, @"game 1 - 3")
                FIND(ball4, @"game 1 - 4")

                NodeObject *n = nil;
                if (ball1.node == block) n = ball1;
                if (ball2.node == block) n = ball2;
                if (ball3.node == block) n = ball3;
                if (ball4.node == block) n = ball4;
                if (n == nil)
                    break;

                SCNAction *dropOne = [SCNAction moveBy:SCNVector3Make(0, -0.3, 0) duration:2];
                [n.node runAction:dropOne completionHandler:^{
                    if ([ball1 jsonPositionY] <= -1.2 &&
                        [ball2 jsonPositionY] <= -1.2 &&
                        [ball3 jsonPositionY] <= -1.2 &&
                        [ball4 jsonPositionY] <= -1.2) {
                        self.stage = STAGE_FINISHED_GAME_1;
                        [self performAction];
                    }
                }];
                break;
            }

            case STAGE_GOING_TO_INITIAL:
            case STAGE_GOING_TO_GAME_1:
            case STAGE_START:
            case STAGE_GOING_TO_GAME_2:
            case STAGE_FINISHED_GAME_2:
            case STAGE_AT_GAME_2:
            case STAGE_FINISHED_GAME_1:
            break;
        }

        //      SCNNode *n = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0]];
        //      n.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
        //      n.position = result.worldCoordinates;
        //      [self.sceneView.scene.rootNode addChildNode:n];
    }
}

- (void)performAction
{
//    NodeObject *paperUnreadable = [objectManager nodeByID:@"paper unreadable"];
//    NSAssert(paperUnreadable != nil, @"No paper unreadable");
//    NodeObject *paperWithCodeword = [objectManager nodeByID:@"paper with codeword"];
//    NSAssert(paperWithCodeword != nil, @"No paper with codeword");

#define ACTION_LAYER_0  @"Action layer 0"
#define ACTION_LAYER_1  @"Action layer 1"

    switch (self.stage) {
        case STAGE_START: {
            NSLog(@"STAGE_START");
            SCNAction *rotateOneAroundYInFifteenSeconds = [SCNAction rotateByX:0 y:M_PI z:0 duration:15];
            SCNAction *rotateForever = [SCNAction repeatActionForever:rotateOneAroundYInFifteenSeconds];
            SCNAction *raiseOne = [SCNAction moveBy:SCNVector3Make(0, 1, 0) duration:5];

            FIND(topSphere, @"Layer 0")

            self.stage = STAGE_GOING_TO_INITIAL;
            [topSphere.node runAction:raiseOne completionHandler:^{
                [topSphere.node runAction:rotateForever];
                self.stage = STAGE_AT_INITIAL;
            }];
            break;
        }

        case STAGE_GOING_TO_GAME_1: {
            NSLog(@"STAGE_GOING_TO_GAME_1");
            FIND(ball1, @"game 1 - 1")
            FIND(ball2, @"game 1 - 2")
            FIND(ball3, @"game 1 - 3")
            FIND(ball4, @"game 1 - 4")

            SCNAction *raiseOne = [SCNAction moveBy:SCNVector3Make(0, 0.30, 0) duration:5];
            [ball1.node runAction:raiseOne];
            [ball2.node runAction:raiseOne];
            [ball3.node runAction:raiseOne];
            [ball4.node runAction:raiseOne completionHandler:^{
                self.stage = STAGE_AT_GAME_1;
            }];

            break;
        }

        case STAGE_FINISHED_GAME_1: {
            NSLog(@"STAGE_FINISHED_GAME_1");
            SCNAction *raiseOne = [SCNAction moveBy:SCNVector3Make(0, 1, 0) duration:5];
            FIND(sphere, @"Layer 0")
            FIND(layer1, @"Layer 1")
            self.stage = STAGE_GOING_TO_GAME_2;
            [layer1.node runAction:raiseOne];
            [sphere.node runAction:raiseOne completionHandler:^{
                self.stage = STAGE_AT_GAME_2;
            }];
            break;
        }

        case STAGE_GOING_TO_INITIAL:
        case STAGE_AT_INITIAL:
        case STAGE_AT_GAME_1:
        case STAGE_AT_GAME_2:
        case STAGE_FINISHED_GAME_2:
        case STAGE_GOING_TO_GAME_2:
        break;
    }
}


@end

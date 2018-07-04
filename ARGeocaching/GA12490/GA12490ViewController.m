//
//  ViewController.m
//  TestAR
//
//  Created by Edwin Groothuis on 10/3/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

typedef NS_ENUM(NSInteger, GameStage) {
    STAGE_START = 0,
    STAGE_CAGE_GOING_TO_INITIAL,
    STAGE_CAGE_AT_INITIAL,
    STAGE_CAGE_GOING_UP,
    STAGE_CAGE_AT_TOP,
    STAGE_CAGE_GOING_DOWN,
    STAGE_CAGE_DOWN,
    STAGE_BOX_OPENED,
};

@interface GA12490ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic)         float boxLength;
@property (nonatomic)         float boxWidth;
@property (nonatomic)         float boxHeight;
@property (nonatomic)         float floorHeight;

@property (nonatomic)         GameStage stage;

@end

@implementation GA12490ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    objectManager = [[ObjectManager alloc] init];
    [objectManager loadFile:@"Mineshaft.json"];
    [objectManager loadFile:@"Underground.json"];

    self.queue = [[NSOperationQueue alloc] init];
    self.stage = STAGE_START;

    [self loadFloor];

//    self.sceneView.autoenablesDefaultLighting = NO;
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

        switch (self.stage) {
            case STAGE_CAGE_AT_INITIAL: {
                NodeObject *n = [objectManager nodeByID:@"outside button up"];
                NSAssert(n != nil, @"No outside button up");
                if (n.node != block)
                    break;
                [self performAction];
                break;
            }

            case STAGE_CAGE_AT_TOP: {
                NodeObject *n = [objectManager nodeByID:@"cage button down"];
                NSAssert(n != nil, @"No cage button down");
                if (n.node != block)
                    break;
                [self performAction];
                break;
            }

            case STAGE_CAGE_DOWN: {
                NodeObject *n = [objectManager nodeByID:@"wooden chest top closed"];
                NSAssert(n != nil, @"No wooden chest top closed");
                if (n.node != block)
                    break;
                [self performAction];
                break;
            }

            case STAGE_BOX_OPENED: {
                NodeObject *n = [objectManager nodeByID:@"paper unreadable"];
                NSAssert(n != nil, @"No paper unreadable");
                if (n.node != block)
                    break;
                [self performAction];
                break;
            }

            case STAGE_CAGE_GOING_UP:
            case STAGE_CAGE_GOING_DOWN:
            case STAGE_CAGE_GOING_TO_INITIAL:
            case STAGE_START:
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
    NodeObject *roof = [objectManager nodeByID:@"cage roof"];
    NSAssert(roof != nil, @"No cage roof");
    NodeObject *floor = [objectManager nodeByID:@"cage floor"];
    NSAssert(floor != nil, @"No cage floor");

    NodeObject *bottom = [objectManager nodeByID:@"cage bottom"];
    NSAssert(bottom != nil, @"No cage bottom");

    NodeObject *outsideDown = [objectManager nodeByID:@"outside button down"];
    NSAssert(outsideDown != nil, @"No outside down button");
    NodeObject *outsideUp = [objectManager nodeByID:@"outside button up"];
    NSAssert(outsideUp != nil, @"No outside up button");
    NodeObject *outsideNone = [objectManager nodeByID:@"outside button none"];
    NSAssert(outsideNone != nil, @"No outside none button");

    NodeObject *insideDown = [objectManager nodeByID:@"cage button down"];
    NSAssert(insideDown != nil, @"No cage down button");
    NodeObject *insideUp = [objectManager nodeByID:@"cage button up"];
    NSAssert(insideUp != nil, @"No cage up button");
    NodeObject *insideNone = [objectManager nodeByID:@"cage button none"];
    NSAssert(insideNone != nil, @"No cage none button");

    NodeObject *chestTopOpen = [objectManager nodeByID:@"wooden chest top open"];
    NSAssert(chestTopOpen != nil, @"No wooden chest top open");
    NodeObject *chestTopClosed = [objectManager nodeByID:@"wooden chest top closed"];
    NSAssert(chestTopClosed != nil, @"No wooden chest top closed");

    NodeObject *paperUnreadable = [objectManager nodeByID:@"paper unreadable"];
    NSAssert(paperUnreadable != nil, @"No paper unreadable");
    NodeObject *paperWithCodeword = [objectManager nodeByID:@"paper with codeword"];
    NSAssert(paperWithCodeword != nil, @"No paper with codeword");

    switch (self.stage) {
        case STAGE_START: {
            outsideUp.node.hidden = YES;
            outsideDown.node.hidden = NO;
            outsideNone.node.hidden = YES;
            insideUp.node.hidden = YES;
            insideDown.node.hidden = NO;
            insideNone.node.hidden = YES;
            chestTopOpen.node.hidden = YES;
            chestTopClosed.node.hidden = NO;
            paperUnreadable.node.hidden = NO;
            paperWithCodeword.node.hidden = YES;

            self.stage = STAGE_CAGE_GOING_TO_INITIAL;
            [self.queue addOperationWithBlock:^{
                while (roof.node.position.y > [ObjectManager positionY:roof.node y:0]) {
                    [NSThread sleepForTimeInterval:0.1];
                    [[objectManager nodesByGroupName:@"cage"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y - 0.1, n.node.position.z);
                    }];
                }
                self.stage = STAGE_CAGE_AT_INITIAL;
                outsideUp.node.hidden = NO;
                outsideDown.node.hidden = YES;
                insideUp.node.hidden = NO;
                insideDown.node.hidden = YES;
            }];
            break;
        }

        case STAGE_CAGE_AT_INITIAL: {
            self.stage = STAGE_CAGE_GOING_UP;
            [self.queue addOperationWithBlock:^{
                while (floor.node.position.y < [ObjectManager positionY:floor.node y:0]) {
                    [NSThread sleepForTimeInterval:0.1];
                    [[objectManager nodesByGroupName:@"cage"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y + 0.1, n.node.position.z);
                    }];
                }
                self.stage = STAGE_CAGE_AT_TOP;
                outsideDown.node.hidden = YES;
                outsideUp.node.hidden = YES;
                outsideNone.node.hidden = NO;
                insideDown.node.hidden = NO;
                insideUp.node.hidden = YES;
            }];
            break;
        }

        case STAGE_CAGE_AT_TOP: {
            self.stage = STAGE_CAGE_GOING_DOWN;
            [self.queue addOperationWithBlock:^{
                while (bottom.node.position.y < [ObjectManager positionY:bottom.node y:0.0]) {
                    [NSThread sleepForTimeInterval:0.1];
                    [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([n.group.name isEqualToString:@"cage"] == YES)
                            return;
                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y + 0.1, n.node.position.z);
                    }];
                }
                self.stage = STAGE_CAGE_DOWN;
                insideDown.node.hidden = YES;
                insideNone.node.hidden = NO;
            }];
            break;
        }

        case STAGE_CAGE_DOWN:
            self.stage = STAGE_BOX_OPENED;
            chestTopOpen.node.hidden = NO;
            chestTopClosed.node.hidden = YES;
            break;

        case STAGE_BOX_OPENED:
            paperUnreadable.node.hidden = YES;
            paperWithCodeword.node.hidden = NO;
            break;

        case STAGE_CAGE_GOING_TO_INITIAL:
        case STAGE_CAGE_GOING_DOWN:
        case STAGE_CAGE_GOING_UP:
            break;
    }
}

@end

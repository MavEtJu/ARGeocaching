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
    STAGE_GOING_TO_GAME_1a,
    STAGE_GOING_TO_GAME_1b,
    STAGE_AT_GAME_1a,
    STAGE_AT_GAME_1b,
    STAGE_FINISHED_GAME_1,
    STAGE_GOING_TO_GAME_2a,
    STAGE_GOING_TO_GAME_2b,
    STAGE_GOING_TO_GAME_2c,
    STAGE_AT_GAME_2,
    STAGE_FINISHED_GAME_2,
    STAGE_GOING_TO_GAME_3,
    STAGE_AT_GAME_3,
    STAGE_FINISHED_GAME_3,
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

    [self performAction];

    [self riseAll:2 nextStage:STAGE_AT_GAME_2];
//    [self riseAll:3 nextStage:STAGE_GOING_TO_GAME_3];
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

    // Touch at left corner
    if (p.x < 50 && p.y < 60) {

        switch (self.stage) {
            case STAGE_AT_GAME_1a:
            case STAGE_AT_GAME_1b:
                [self riseAll:2 nextStage:STAGE_AT_GAME_2];
                break;

            case STAGE_AT_GAME_2:
                [self riseAll:3 nextStage:STAGE_GOING_TO_GAME_3];
                break;

            case STAGE_AT_GAME_3:
//                [self riseAll:4 nextStage:STAGE_GOING_TO_GAME_4];
                break;

            case STAGE_START:
            case STAGE_GOING_TO_GAME_1a:
            case STAGE_GOING_TO_GAME_1b:
            case STAGE_GOING_TO_GAME_2a:
            case STAGE_GOING_TO_GAME_2b:
            case STAGE_GOING_TO_GAME_2c:
            case STAGE_GOING_TO_GAME_3:
            case STAGE_FINISHED_GAME_1:
            case STAGE_FINISHED_GAME_2:
            case STAGE_FINISHED_GAME_3:
                break;
        }

        return;
    }

    // Touch on nodes
    NSArray <SCNHitTestResult *> *res = [self.sceneView hitTest:[[touches anyObject] locationInView:self.sceneView] options:@{SCNHitTestFirstFoundOnlyKey:@YES}];
    if (res.count != 0) {

        SCNHitTestResult *result = res.lastObject;
        SCNNode *block = result.node;

        switch (self.stage) {
            case STAGE_AT_GAME_1a: {
                NSLog(@"STAGE_AT_GAME_1a");
                FIND(n, @"game 1 - 0")
                if (n.node != block)
                    break;
                self.stage = STAGE_GOING_TO_GAME_1b;
                [self performAction];
                break;
            }

            case STAGE_AT_GAME_1b: {
                NSLog(@"STAGE_AT_GAME_1b");
                /*
                 * Game 1
                 *
                 * Status:
                 * The center sphere just has come up. It was pressed by the user
                 * and four balls came up.
                 *
                 * User interaction:
                 * The user needs to tap a call to push them down.
                 *
                 * Follow up:
                 * One all four have been pushed down, the next level will rise.
                 *
                 */
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

                SCNAction *dropOne = [SCNAction moveBy:SCNVector3Make(0, -0.31, 0) duration:2];
                [n.node runAction:dropOne completionHandler:^{
                    if ([ball1 jsonPositionY] <= -0.3 &&
                        [ball2 jsonPositionY] <= -0.3 &&
                        [ball3 jsonPositionY] <= -0.3 &&
                        [ball4 jsonPositionY] <= -0.3) {
                        self.stage = STAGE_FINISHED_GAME_1;
                        [self performAction];
                    }
                }];
                break;
            }

            case STAGE_AT_GAME_2: {
                /*
                 * Game 2
                 *
                 * Status:
                 * There are three rings which rotate when touched.
                 *
                 * User interaction:
                 * The user needs to rotate all of them to get them at
                 * the same rotation.
                 *
                 * Follow up:
                 * One all three are at the same rotation, the next level will rise.
                 *
                 */
                NSLog(@"STAGE_AT_GAME_2");
                FIND(ring1, @"game 2 - 1")
                FIND(ring2, @"game 2 - 2")
                FIND(ring3, @"game 2 - 3")

                NodeObject *n = nil;
                if (ring1.node == block) n = ring1;
                if (ring2.node == block) n = ring2;
                if (ring3.node == block) n = ring3;
                if (n == nil)
                    break;

                SCNAction *rotate = [SCNAction rotateByX:0 y:M_PI / 2 z:0 duration:2];
                [n.node runAction:rotate completionHandler:^{
                    NSInteger w1 = lround(GLKMathRadiansToDegrees(ring1.node.rotation.w));
                    NSInteger w2 = lround(GLKMathRadiansToDegrees(ring2.node.rotation.w));
                    NSInteger w3 = lround(GLKMathRadiansToDegrees(ring3.node.rotation.w));
                    if (((-70 < w1 && w1 < -60) || (290 < w1 && w1 < 300)) &&
                        ((-70 < w2 && w2 < -60) || (290 < w2 && w2 < 300)) &&
                        ((-70 < w3 && w3 < -60) || (290 < w3 && w3 < 300))) {
                        self.stage = STAGE_FINISHED_GAME_2;
                        [self performAction];
                    }
                }];

                break;
            }

            case STAGE_AT_GAME_3: {
                break;
            }

            case STAGE_START:
            case STAGE_GOING_TO_GAME_1a:
            case STAGE_GOING_TO_GAME_1b:
            case STAGE_GOING_TO_GAME_2a:
            case STAGE_GOING_TO_GAME_2b:
            case STAGE_GOING_TO_GAME_2c:
            case STAGE_GOING_TO_GAME_3:
            case STAGE_FINISHED_GAME_3:
            case STAGE_FINISHED_GAME_2:
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

            self.stage = STAGE_GOING_TO_GAME_1a;
            break;
        }

        case STAGE_GOING_TO_GAME_1a: {
            NSLog(@"STAGE_GOING_TO_GAME_1a");

            SCNAction *rotateOneAroundYInFifteenSeconds = [SCNAction rotateByX:0 y:M_PI z:0 duration:15];
            SCNAction *rotateForever = [SCNAction repeatActionForever:rotateOneAroundYInFifteenSeconds];

            FIND(topSphere, @"game 1 - 0")
            [topSphere.node runAction:rotateForever];
            [self riseAll:1 nextStage:STAGE_AT_GAME_1a];
            break;
        }

        case STAGE_GOING_TO_GAME_1b: {
            NSLog(@"STAGE_GOING_TO_GAME_1b");

            FIND(ball1, @"game 1 - 1")
            FIND(ball2, @"game 1 - 2")
            FIND(ball3, @"game 1 - 3")
            FIND(ball4, @"game 1 - 4")

            SCNAction *raiseOne = [SCNAction moveBy:SCNVector3Make(0, 0.30, 0) duration:5];
            [ball1.node runAction:raiseOne];
            [ball2.node runAction:raiseOne];
            [ball3.node runAction:raiseOne];
            [ball4.node runAction:raiseOne completionHandler:^{
                self.stage = STAGE_AT_GAME_1b;
            }];

            break;
        }

        case STAGE_FINISHED_GAME_1: {
            NSLog(@"STAGE_FINISHED_GAME_1");

            FIND(ball1, @"game 1 - 1")
            FIND(ball2, @"game 1 - 2")
            FIND(ball3, @"game 1 - 3")
            FIND(ball4, @"game 1 - 4")

            ball1.node.hidden = YES;
            ball2.node.hidden = YES;
            ball3.node.hidden = YES;
            ball4.node.hidden = YES;

            self.stage = STAGE_GOING_TO_GAME_2a;
            [self performAction];
            break;
        }

        case STAGE_GOING_TO_GAME_2a: {
            NSLog(@"STAGE_GOING_TO_GAME_2a");

            [self riseAll:2 nextStage:STAGE_AT_GAME_2];

            FIND(ring1, @"game 2 - 1")
            FIND(ring2, @"game 2 - 2")
            FIND(ring3, @"game 2 - 3")

            SCNAction *wait5 = [SCNAction waitForDuration:5];
            SCNAction *wait1 = [SCNAction waitForDuration:1];
            SCNAction *rotateCWFull =  [SCNAction rotateByX:0 y:2 * M_PI z:0 duration:6];
            SCNAction *rotateCCWFull = [SCNAction rotateByX:0 y:-2 * M_PI z:0 duration:6];
            SCNAction *rotateCWPart1 = [SCNAction rotateByX:0 y:1 * 6 * M_PI / 4 z:0 duration:2];
            SCNAction *rotateCWPart2 = [SCNAction rotateByX:0 y:2 * 6 * M_PI / 4 z:0 duration:2];
            SCNAction *rotateCCWPart = [SCNAction rotateByX:0 y:-1 * 6 * M_PI / 4 z:0 duration:2];
            SCNAction *action1 = [SCNAction sequence:@[wait5, rotateCWFull, wait1, rotateCWPart1]];
            SCNAction *action3 = [SCNAction sequence:@[wait5, rotateCWFull, wait1, rotateCWPart2]];
            SCNAction *action2 = [SCNAction sequence:@[wait5, rotateCCWFull, wait1, rotateCCWPart]];

            [ring1.node runAction:action1];
            [ring3.node runAction:action3];
            [ring2.node runAction:action2 completionHandler:^{
                self.stage = STAGE_AT_GAME_2;
            }];

            break;
        }

        case STAGE_FINISHED_GAME_2: {
            NSLog(@"STAGE_FINISHED_GAME_2");

            FIND(ring1, @"game 2 - 1")
            FIND(ring2, @"game 2 - 2")
            FIND(ring3, @"game 2 - 3")

            SCNAction *wait1 = [SCNAction waitForDuration:1];
            SCNAction *rotateOnce =  [SCNAction rotateByX:0 y:1 * 2 * M_PI z:0 duration:1];
            SCNAction *rotateTwice = [SCNAction rotateByX:0 y:2 * 2 * M_PI z:0 duration:1];
            SCNAction *rotateThrice = [SCNAction rotateByX:0 y:3 * 2 * M_PI z:0 duration:1];
            SCNAction *action1 = [SCNAction sequence:@[wait1, rotateOnce]];
            SCNAction *action3 = [SCNAction sequence:@[wait1, rotateTwice]];
            SCNAction *action2 = [SCNAction sequence:@[wait1, rotateThrice]];

            [ring1.node runAction:action1];
            [ring2.node runAction:action2];
            [ring3.node runAction:action3 completionHandler:^{
                self.stage = STAGE_GOING_TO_GAME_3;
                [self performAction];
            }];

            break;
        }

        case STAGE_GOING_TO_GAME_3: {
            NSLog(@"STAGE_GOING_TO_GAME_3");
            [self riseAll:3 nextStage:STAGE_AT_GAME_3];
            break;
        }

        case STAGE_AT_GAME_1a:
        case STAGE_AT_GAME_1b:
        case STAGE_AT_GAME_3:
        case STAGE_FINISHED_GAME_3:
        break;
    }
}

- (void)riseAll:(NSInteger)upToGame nextStage:(GameStage)nextStage;
{
    NSString *groupname = [NSString stringWithFormat:@"Game %ld", upToGame];
    GroupObject *group = [objectManager groupByName:groupname];
    float riseAmount = [[group.properties objectForKey:@"rise-initial"] floatValue];;
    NSLog(@"Rising %f for group %ld", riseAmount, upToGame);

    SCNAction *raiseSome = [SCNAction moveBy:SCNVector3Make(0, riseAmount, 0) duration:5];

    for (NSInteger i = 1; i <= upToGame; i++) {
        NSString *group = [NSString stringWithFormat:@"Game %ld", i];
        [[objectManager nodesByGroupName:group] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull no, NSUInteger idx, BOOL * _Nonnull stop) {
            [no.node runAction:raiseSome completionHandler:^{
                self.stage = nextStage;
                // [self performAction];
            }];
        }];
    }
}

@end

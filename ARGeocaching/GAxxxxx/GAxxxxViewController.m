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
};


@interface GAxxxxViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic)         float boxLength;
@property (nonatomic)         float boxWidth;
@property (nonatomic)         float boxHeight;
@property (nonatomic)         float floorHeight;

@property (nonatomic)         GameStage stage;

@end

@implementation GAxxxxViewController

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    NSValue *v = [NSValue valueWithCGPoint:p];
    NSLog(@"%@", v);

    // Touch at top right
    //    if (p.x > 550 && p.y < 120) {
    //        CGFloat dx, dz;
    //
    //        dz = (p.y < 60) ? 0.6 : -0.6;
    //        dx = (p.x > 640) ? -0.6 : 0.6;
    //
    //        [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
    //            n.node.position = SCNVector3Make(n.node.position.x + dx, n.node.position.y, n.node.position.z + dz);
    //        }];
    //
    //        return;
    //    }

    // Touch on nodes
    NSArray <SCNHitTestResult *> *res = [self.sceneView hitTest:[[touches anyObject] locationInView:self.sceneView] options:@{SCNHitTestFirstFoundOnlyKey:@YES}];
    if (res.count != 0) {

        SCNHitTestResult *result = res.lastObject;
        SCNNode *block = result.node;

        switch (self.stage) {
            case STAGE_AT_INITIAL: {
                NodeObject *n = [objectManager nodeByID:@"outside button up"];
                NSAssert(n != nil, @"No outside button up");
                if (n.node != block)
                break;
                [self performAction];
                break;
            }

            case STAGE_GOING_TO_INITIAL:
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
//    NodeObject *paperUnreadable = [objectManager nodeByID:@"paper unreadable"];
//    NSAssert(paperUnreadable != nil, @"No paper unreadable");
//    NodeObject *paperWithCodeword = [objectManager nodeByID:@"paper with codeword"];
//    NSAssert(paperWithCodeword != nil, @"No paper with codeword");

    switch (self.stage) {
        case STAGE_START: {
//            chestTopOpen.node.hidden = YES;
//            chestTopClosed.node.hidden = NO;
//            paperUnreadable.node.hidden = NO;
//            paperWithCodeword.node.hidden = YES;
//
//            self.stage = STAGE_GOING_TO_INITIAL;
//            [self.queue addOperationWithBlock:^{
//                while (roof.node.position.y > [ObjectManager positionY:roof.node y:0]) {
//                    [NSThread sleepForTimeInterval:0.1];
//                    [[objectManager nodesByGroupName:@"cage"] enumerateObjectsUsingBlock:^(NodeObject * _Nonnull n, NSUInteger idx, BOOL * _Nonnull stop) {
//                        n.node.position = SCNVector3Make(n.node.position.x, n.node.position.y - 0.1, n.node.position.z);
//                    }];
//                }
//                self.stage = STAGE_AT_INITIAL;
//                outsideUp.node.hidden = NO;
//                outsideDown.node.hidden = YES;
//                insideUp.node.hidden = NO;
//                insideDown.node.hidden = YES;
//            }];
            break;
        }

        case STAGE_GOING_TO_INITIAL:
        case STAGE_AT_INITIAL:
        break;
    }
}


@end

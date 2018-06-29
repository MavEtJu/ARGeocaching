//
//  ViewController.m
//  TestAR
//
//  Created by Edwin Groothuis on 10/3/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic)         float boxLength;
@property (nonatomic)         float boxWidth;
@property (nonatomic)         float boxHeight;
@property (nonatomic)         float floorHeight;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.queue = [[NSOperationQueue alloc] init];

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
- (void)position:(SCNNode *)node x:(float)x y:(float)y z:(float)z
{
#define ORIGINX -5
#define ORIGINZ 1
#define ORIGINZ -4.5
#define ORIGINY -2       // height

//    NSAssert([[node.geometry class] isKindOfClass:[SCNBox class]] == YES, @"Invalid class");

    SCNBox *g = (SCNBox *)node.geometry;
    node.position = SCNVector3Make((x + ORIGINX + node.scale.x * g.width / 2), (y + ORIGINY + node.scale.y * g.height / 2), -(z + ORIGINZ + node.scale.z * g.length / 2));
}

- (void)loadFloor
{
    // Container to hold all of the 3D geometry
    SCNScene *scene = [SCNScene new];

    for (int x = 0; x < 10; x++) {
        for (int z = 0; z < 10; z++) {
            if (z / 3 == 1 && x / 3 == 1)
                continue;
            SCNNode *boxNode = [[SCNFloorTile alloc] init];
            [self position:boxNode x:x y:0 z:z];
            [scene.rootNode addChildNode:boxNode];
        }
    }

    SCNNode *boxNode;

    // Outside of the cage.
    boxNode = [[SCNMetalWallRedRight alloc] init];
    boxNode.scale = SCNVector3Make(3, 3, 1);
    [self position:boxNode x:3 y:0.1 z:6];
    [scene.rootNode addChildNode:boxNode];

    boxNode = [[SCNMetalWallRedArrowForward alloc] init];
    boxNode.scale = SCNVector3Make(1, 3, 3);
    [self position:boxNode x:3 y:0.1 z:3];
    [scene.rootNode addChildNode:boxNode];

    boxNode = [[SCNMetalWallRedArrowForward alloc] init];
    boxNode.scale = SCNVector3Make(1, 3, 3);
    [self position:boxNode x:6 y:0.1 z:3];
    [scene.rootNode addChildNode:boxNode];

    // Inside of the cage.
    boxNode = [[SCNMetalRasterRight alloc] init];
    boxNode.scale = SCNVector3Make(2.6, 2.6, 1);
    [self position:boxNode x:3.2 y:0.1 z:5.8];
    [scene.rootNode addChildNode:boxNode];

    boxNode = [[SCNMetalRasterForward alloc] init];
    boxNode.scale = SCNVector3Make(1, 2.6, 2.6);
    [self position:boxNode x:3.2 y:0.1 z:3.2];
    [scene.rootNode addChildNode:boxNode];

    boxNode = [[SCNMetalRasterForward alloc] init];
    boxNode.scale = SCNVector3Make(1, 2.6, 2.6);
    [self position:boxNode x:5.8 y:0.1 z:3.2];
    [scene.rootNode addChildNode:boxNode];

    boxNode = [[SCNMetalWallSilverHorizontal alloc] init];
    boxNode.scale = SCNVector3Make(2.7, 1, 2.7);
    [self position:boxNode x:3.2 y:0 z:3.2];
    [scene.rootNode addChildNode:boxNode];

    boxNode = [[SCNMetalWallSilverHorizontal alloc] init];
    boxNode.scale = SCNVector3Make(2.7, 1, 2.7);
    [self position:boxNode x:3.2 y:2.7 z:3.2];
    [scene.rootNode addChildNode:boxNode];

    /* Lights around the cage */
    SCNLight *oLight = [SCNLight light];
    oLight.type = SCNLightTypeOmni;
    oLight.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    SCNNode *oLightNode;
    oLightNode = [SCNNode node];
    oLightNode.light = oLight;
    [self position:oLightNode x:1.5 y:1.1 z:1.5];
    [scene.rootNode addChildNode:oLightNode];

    oLightNode = [SCNNode node];
    oLightNode.light = oLight;
    [self position:oLightNode x:8.5 y:1.1 z:8.5];
    [scene.rootNode addChildNode:oLightNode];

    oLightNode = [SCNNode node];
    oLightNode.light = oLight;
    [self position:oLightNode x:8.5 y:1.1 z:1.5];
    [scene.rootNode addChildNode:oLightNode];

    oLightNode = [SCNNode node];
    oLightNode.light = oLight;
    [self position:oLightNode x:1.5 y:1.1 z:8.5];
    [scene.rootNode addChildNode:oLightNode];

    // Inside the cage
    oLight = [SCNLight light];
    oLight.type = SCNLightTypeOmni;
    oLight.color = [UIColor colorWithRed:1.0 green:0.664 blue:0.0 alpha:1.0];

    oLightNode = [SCNNode node];
    oLightNode.light = oLight;
    [self position:oLightNode x:4.5 y:1.1 z:4.5];
    [scene.rootNode addChildNode:oLightNode];

    /* Light */
    SCNLight *sLight = [SCNLight light];
//    dLight.type = SCNLightTypeDirectional;
    sLight.type = SCNLightTypeSpot;
    sLight.color = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
    sLight.castsShadow = TRUE;
    sLight.zNear = 50;
    sLight.zFar = 120;
    sLight.spotInnerAngle = 60;
    sLight.spotOuterAngle = 90;

    SCNNode *sLightNode = [SCNNode node];
    sLightNode.light = sLight;
    [self position:sLightNode x:4.5 y:1.5 z:4.5];
//    [scene.rootNode addChildNode:sLightNode];

    /* Little green box */
    SCNNode *n = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0]];
    n.geometry.materials = @[[Materials get:MATERIAL_SEMITRANSPARENT]];
    [self position:n x:0 y:1.5 z:0];
    [scene.rootNode addChildNode:n];


    // Set the scene to the view
    self.sceneView.scene = scene;
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
        if ([[block class] isEqual:[SCNFloorTile class]] == NO)
            return;
        SCNNode *n = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0]];
        n.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
        n.position = result.worldCoordinates;
        [self.sceneView.scene.rootNode addChildNode:n];
        [self.queue addOperationWithBlock:^{
            while (1) {
                [NSThread sleepForTimeInterval:0.1];
                NSLog(@"%f", n.position.y);
                n.position = SCNVector3Make(n.position.x, n.position.y - 0.1, n.position.z);
                if (n.position.y < -self.boxHeight)
                    break;
            }
        }];
    }
}

@end

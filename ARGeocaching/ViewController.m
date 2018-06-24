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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *field = @[
        //          111111111122222222223333333333444444444455555555556
        //0123456789012345678901234567890123456789012345678901234567890
        @"                                                             ", // 35
        @" +---W-WWW-------------------------------------------------+ ", // 34
        @" |p.......................................................p| ", // 33
        @" |.........................................................| ", // 32
        @" |.........................................................| ", // 31
        @" w.........................................................| ", // 30
        @" w.........................................................| ", // 29
        @" w.........................................................| ", // 28
        @" w.........................................................| ", // 27
        @" |.........................................................| ", // 26
        @" |.........................................................| ", // 25
        @" |.........................................................| ", // 24
        @" |.........................................................| ", // 23
        @" w.........................................................| ", // 22
        @" w.........................................................| ", // 21
        @" w.........................................................| ", // 20
        @" w.........................................................| ", // 19
        @" |.........................................................| ", // 18
        @" |.........................................................| ", // 17
        @" |.........................................................| ", // 16
        @" |.........................................................| ", // 15
        @" w.........................................................| ", // 14
        @" w.........................................................| ", // 13
        @" w.........................................................| ", // 12
        @" w.........................................................| ", // 11
        @" |.........+-+.............................................| ", // 10
        @" |.........|.|.............................................| ", //  9
        @" |.........|.|.............................................| ", //  8
        @" |.........|.|.............................................| ", //  7
        @" w.........|.|.............................................| ", //  6
        @" w.........|.|.............................................| ", //  5
        @" w.........|.|.............................................| ", //  4
        @" w.........|.|.............................................| ", //  3
        @" |.........|.|............................................p| ", //  2
        @" +-p.....p-+-+---------------------------------------------+ ", //  1
        @"                                                             ", //  0
        ];

    // Container to hold all of the 3D geometry
    SCNScene *scene = [SCNScene new];

    float boxLength = 0.5;          // half a meter
    float boxWidth = boxLength;
    float boxHeight = 3.0;          // 2 meters
    float floorHeight = 0.1;        // 10 centimeters

    // Materials
    SCNMaterial *bricksWhite12 = [SCNMaterial material];
    bricksWhite12.diffuse.contents = [UIImage imageNamed:@"Bricks - White - 12"];
    SCNMaterial *bricksWhite4 = [SCNMaterial material];
    bricksWhite4.diffuse.contents = [UIImage imageNamed:@"Bricks - White - 4"];
    SCNMaterial *pillarStone = [SCNMaterial material];
    pillarStone.diffuse.contents = [UIImage imageNamed:@"Pillar - Stone"];
    SCNMaterial *floorStone = [SCNMaterial material];
    floorStone.diffuse.contents = [UIImage imageNamed:@"Floor"];
    SCNMaterial *windowTransparent = [SCNMaterial material];
    windowTransparent.diffuse.contents = [UIImage imageNamed:@"Window - Transparent"];
    windowTransparent.transparency = 0.1;
    SCNMaterial *roofStone = [SCNMaterial material];
    roofStone.diffuse.contents = [UIImage imageNamed:@"Roof - Transparent"];
    roofStone.transparency = 0.1;

    // The 3D cube geometry we want to draw
    SCNBox *floorTile = [SCNBox boxWithWidth:boxWidth height:floorHeight length:boxLength chamferRadius:0.0];
    floorTile.materials = @[floorStone];
    SCNBox *roofTile = [SCNBox boxWithWidth:boxWidth height:floorHeight length:boxLength chamferRadius:0.0];
    roofTile.materials = @[roofStone];

    SCNBox *wallBox = [SCNBox boxWithWidth:boxWidth height:boxHeight length:boxLength chamferRadius:0];
    wallBox.materials = @[bricksWhite12];

    SCNBox *wallWindow = [SCNBox boxWithWidth:boxWidth height:boxHeight / 3 length:boxLength chamferRadius:0];
    wallWindow.materials = @[bricksWhite4];
    SCNBox *wallWindowGlassBT = [SCNBox boxWithWidth:boxWidth / 6 height:boxHeight / 3 length:boxLength chamferRadius:0];
    wallWindowGlassBT.materials = @[windowTransparent];
    SCNBox *wallWindowGlassLR = [SCNBox boxWithWidth:boxWidth height:boxHeight / 3 length:boxLength / 6 chamferRadius:0];
    wallWindowGlassLR.materials = @[windowTransparent];

    SCNBox *insideBox = [SCNBox boxWithWidth:boxWidth height:boxHeight length:boxLength chamferRadius:0];
    insideBox.firstMaterial.diffuse.contents = [UIColor grayColor];

    SCNTube *pillar = [SCNTube tubeWithInnerRadius:boxLength / 2 outerRadius:3 * boxLength / 4 height:boxHeight];
    pillar.materials = @[pillarStone];

    for (float y = 0; y < [field count]; y++) {
        for (float x = 0; x < [[field objectAtIndex:y] length]; x++) {
            NSString *line = [field objectAtIndex:[field count] - y - 1];
            unichar c = [line characterAtIndex:x];

#define ORIGINX 6
//#define ORIGINY -6
#define ORIGINY 30

#define Y       (- y * boxLength + ORIGINY * boxLength)
#define X       (x * boxWidth - ORIGINX * boxWidth)
#define Z(z)    ((z))

#define FLOOR { \
    SCNNode *boxNode = [SCNNode nodeWithGeometry:floorTile]; \
    boxNode.position = SCNVector3Make(X, Z(-boxHeight / 2 - floorHeight), Y); \
    [scene.rootNode addChildNode:boxNode]; \
}

#define ROOF { \
    SCNNode *boxNode = [SCNNode nodeWithGeometry:roofTile]; \
    boxNode.position = SCNVector3Make(X, Z(boxHeight / 2), Y); \
    [scene.rootNode addChildNode:boxNode]; \
}

            switch (c) {
                case ' ':
                    FLOOR
                    break;

                case '.':
                    FLOOR ROOF
                    break;

                case '+':
                case '-':
                case '|': {
                    FLOOR ROOF
                    SCNNode *node = [SCNNode nodeWithGeometry:wallBox];
                    node.position = SCNVector3Make(X, Z(0), Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'w': {
                    ROOF FLOOR
                    SCNNode *node = [SCNNode nodeWithGeometry:wallWindow];
                    node.position = SCNVector3Make(X, Z(wallWindow.height), Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindowGlassBT];
                    node.position = SCNVector3Make(X, Z(0), Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindow];
                    node.position = SCNVector3Make(X, Z(-wallWindow.height), Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'W': {
                    ROOF FLOOR
                    SCNNode *node = [SCNNode nodeWithGeometry:wallWindow];
                    node.position = SCNVector3Make(X, Z(wallWindow.height), Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindowGlassLR];
                    node.position = SCNVector3Make(X, Z(0), Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindow];
                    node.position = SCNVector3Make(X, Z(-wallWindow.height), Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'p': {
                    FLOOR
                    ROOF
                    SCNNode *node = [SCNNode nodeWithGeometry:pillar];
                    node.position = SCNVector3Make(X, Z(0), Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                default:
                    NSLog(@"Not found: '%c'", c);
                    break;
            }
        }
    }

    self.sceneView.autoenablesDefaultLighting = NO;
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;

    // Set the scene to the view
    self.sceneView.scene = scene;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.lightEstimationEnabled = YES;

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

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor
{
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)session:(ARSession *)session didFailWithError:(NSError *)error
{
    // Present an error message to the user
}

- (void)sessionWasInterrupted:(ARSession *)session
{
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
}

- (void)sessionInterruptionEnded:(ARSession *)session
{
    // Reset tracking and/or remove existing anchors if consistent tracking is required
}

@end

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

    NSArray *field = @[
        //          111111111122222222223333333333444444444455555555556
        //0123456789012345678901234567890123456789012345678901234567890
        @"                                                             ", // 35
        @" +---WWWW----WWWW----WWWW------------WWWW----WWWW----WWWW--+ ", // 34
        @" |p...........................x.x.........................p| ", // 33
        @" |............................x.x..........................| ", // 32
        @" |............................x.x..........................| ", // 31
        @" w............................x.x..........................w ", // 30
        @" w............................xxx..........................w ", // 29
        @" w.........................................................w ", // 28
        @" w.........................................................w ", // 27
        @" |................xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx...........| ", // 26
        @" |................x............................x...........| ", // 25
        @" |................xxxxxxxxxxxxxxxxxxxxxxx......x...........| ", // 24
        @" |......................................x......x...........| ", // 23
        @" w......................................x......x...........w ", // 22
        @" w......................................x......x...........w ", // 21
        @" w......................................x......x...........w ", // 20
        @" w......................................x......x...........w ", // 19
        @" |......................................x......x...........| ", // 18
        @" +xxxxxxxxxxxxxxxxxxxxxxxxxxx...........x......x...........| ", // 17
        @" |xxxxxxxxxxxxxxxxxxxxxxxxxxx...........x......x...........| ", // 16
        @" |......................................x......x...........| ", // 15
        @" w......................................x......x...........w ", // 14
        @" w......................................x......x...........w ", // 13
        @" w......................................x......x...........w ", // 12
        @" w......................................x......x...........w ", // 11
        @" |.........xxx..........................x......x...........| ", // 10
        @" |.........x.x..........................x......x...........| ", //  9
        @" |.........x.x..........................xxxxxxxx...........| ", //  8
        @" |.........x.x.............................................| ", //  7
        @" w.........x.x.............................................w ", //  6
        @" w.........x.x.............................................w ", //  5
        @" w.........x.x.............................................w ", //  4
        @" w.........x.x.............................................w ", //  3
        @" |.........x.x............................................p| ", //  2
        @" +-p.....p-+-+-------WWWW----WWWW----WWWW----WWWW----WWWW--+ ", //  1
        @"                                                             ", //  0
        ];

    // Container to hold all of the 3D geometry
    SCNScene *scene = [SCNScene new];

    self.boxLength = 0.5;          // half a meter
    self.boxWidth = self.boxLength;
    self.boxHeight = 3.0;          // 2 meters
    self.floorHeight = 0.1;        // 10 centimeters

    // The 3D cube geometry we want to draw
//    SCNBox *floorTileObject = [SCNBox boxWithWidth:boxWidth height:floorHeight length:boxLength chamferRadius:0.0];
//    floorTileObject.materials = @[];
//    SCNBox *roofTileObject = [SCNBox boxWithWidth:boxWidth height:floorHeight length:boxLength chamferRadius:0.0];
//    roofTileObject.materials = @[[Materials get:MATERIAL_SEMITRANSPARENT]];

    SCNBox *brickWallObject = [SCNBox boxWithWidth:self.boxWidth height:self.boxHeight length:self.boxLength chamferRadius:0];
    brickWallObject.materials = @[[Materials get:MATERIAL_BRICKS_WHITE12]];

    SCNBox *wallWindowObject = [SCNBox boxWithWidth:self.boxWidth height:self.boxHeight / 3 length:self.boxLength chamferRadius:0];
    wallWindowObject.materials = @[[Materials get:MATERIAL_BRICKS_WHITE4]];

    SCNBox *wallWindowGlassBTObject = [SCNBox boxWithWidth:self.boxWidth / 6 height:self.boxHeight / 3 length:self.boxLength chamferRadius:0];
    wallWindowGlassBTObject.materials = @[[Materials get:MATERIAL_GLASS]];
    SCNBox *wallWindowGlassLRObject = [SCNBox boxWithWidth:self.boxWidth height:self.boxHeight / 3 length:self.boxLength / 6 chamferRadius:0];
    wallWindowGlassLRObject.materials = @[[Materials get:MATERIAL_GLASS]];

    SCNBox *insideWallObject = [SCNBox boxWithWidth:self.boxWidth height:self.boxHeight length:self.boxLength chamferRadius:0];
    insideWallObject.materials = @[[Materials get:MATERIAL_WALLPAPER]];

    SCNTube *pillarObject = [SCNTube tubeWithInnerRadius:self.boxLength / 2 outerRadius:3 * self.boxLength / 4 height:self.boxHeight];
    pillarObject.materials = @[[Materials get:MATERIAL_PILLAR_STONE]];

    for (float y = 0; y < [field count]; y++) {
        for (float x = 0; x < [[field objectAtIndex:y] length]; x++) {
            NSString *line = [field objectAtIndex:[field count] - y - 1];
            unichar c = [line characterAtIndex:x];

#define ORIGINX 6
#define ORIGINY -6
//#define ORIGINY 30

#define _Y       (- y * self.boxLength + ORIGINY * self.boxLength)
#define _X       (x * self.boxWidth - ORIGINX * self.boxWidth)
#define _Z(z)    ((z))

#define FLOOR { \
    SCNNode *boxNode = [[SCNFloorTile alloc] init]; \
    boxNode.position = SCNVector3Make(_X, _Z(-self.boxHeight / 2), _Y); \
    [scene.rootNode addChildNode:boxNode]; \
}

#define ROOF { \
    SCNNode *boxNode = [[SCNRoof alloc] init]; \
    boxNode.position = SCNVector3Make(_X, _Z(self.boxHeight / 2), _Y); \
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
                    SCNNode *node = [SCNNode nodeWithGeometry:brickWallObject];
                    node.position = SCNVector3Make(_X, _Z(0), _Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'w': {
                    ROOF FLOOR
                    SCNNode *node = [SCNNode nodeWithGeometry:wallWindowObject];
                    node.position = SCNVector3Make(_X, _Z(wallWindowObject.height), _Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindowGlassBTObject];
                    node.position = SCNVector3Make(_X, _Z(0), _Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindowObject];
                    node.position = SCNVector3Make(_X, _Z(-wallWindowObject.height), _Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'W': {
                    ROOF FLOOR
                    SCNNode *node = [SCNNode nodeWithGeometry:wallWindowObject];
                    node.position = SCNVector3Make(_X, _Z(wallWindowObject.height), _Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindowGlassLRObject];
                    node.position = SCNVector3Make(_X, _Z(0), _Y);
                    [scene.rootNode addChildNode:node];

                    node = [SCNNode nodeWithGeometry:wallWindowObject];
                    node.position = SCNVector3Make(_X, _Z(-wallWindowObject.height), _Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'p': {
                    FLOOR ROOF
                    SCNNode *node = [SCNNode nodeWithGeometry:pillarObject];
                    node.position = SCNVector3Make(_X, _Z(0), _Y);
                    [scene.rootNode addChildNode:node];
                    break;
                }

                case 'x': {
                    FLOOR ROOF
                    SCNNode *node = [SCNNode nodeWithGeometry:insideWallObject];
                    node.position = SCNVector3Make(_X, _Z(0), _Y);
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
        if ([[block class] isEqual:[SCNRoof class]] == NO)
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

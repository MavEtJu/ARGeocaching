# ARGeocaching - a framework for Augmented Reality geocaching on the iPhone and iPad.

## The framework

The framework provides a wrapper around the various basic shapes
(boxes, spheres, tubes, planes etc), a JSON configuration file for
that scenario and the possibility to interact via Objective-C code
with the shapes and environment.

### Shapes

The available shapes are the ones defined [by Apple for the
SceneKit](https://developer.apple.com/documentation/scenekit/built_in_geometry_types?language=objc)
like boxes, spheres, pyramids, planes etc.

### Data files

The data files for a world consist of several sections:

#### Header

This currently contains the initial location of the camera in the
scenario. This is because sometimes the final design of the world
doesn't match the final design and you need to move the camera
around.


```
{
    "origin": [0, 2, -5]
}
```

#### Materials

The materials section labels the various images towards images,
including the option for a transparency.

In this example the image `Red Colour.png` was added to the app and
is now available as the materials `Red` and `Red semi-transparent`:


```
{
    "materials":
    [
     {
     "name": "Red",
     "image": "Red colour"
     }, {
     "name": "Red semi-transparent",
     "image": "Red colour",
     "transparency": 0.5
     }
    ]
}
```

#### Shapes

Every shape has at least two fields: The `name` and the `material`
fields. The `name` is used to label the specific shape while the
`material` is an array of labels from the material section. Not all
`material` arrays have the same number of values, it's depending
on the shape.

Some shapes have radius related values to specify the various
properties  of the shape.

```
{
    "boxes":
    [
     {
     "name": "Demo box",
     "material": ["Red", "Green", "Blue", "Yellow", "Cyan", "Magenta"]
     }
    ],

    "tubes":
    [
     {
     "name": "Demo tube",
     "material": ["Red", "Green", "Blue", "Yellow"],
     "radius-inner": 0.25,
     "radius-outer": 1
     }
    ],

    "capsules":
    [
     {
     "name": "Demo capsule",
     "material": ["Red"],
     "radius-cap": 0.25,
     }
    ],

    "spheres":
    [
     {
     "name": "Demo sphere",
     "material": ["Red"],
     "radius": 0.50,
     }
    ],

    "cylinders":
    [
     {
     "name": "Demo cylinder",
     "material": ["Red", "Green", "Blue"],
     "radius": 0.50,
     }
    ],

    "pyramids":
    [
     {
     "name": "Demo pyramid",
     "material": ["Red", "Green", "Blue", "Yellow", "Cyan"],
     }
    ],

    "toruses":
    [
     {
     "name": "Demo torus",
     "material": ["Red"],
     "radius-ring": 1,
     "radius-pipe": 0.25,
     }
    ],

    "cones":
    [
     {
     "name": "Demo cone",
     "material": ["Red", "Green", "Blue"],
     "radius-top": 1,
     "radius-bottom": 0.25,
     }
    ],

    "planes":
    [
     {
     "name": "Demo plane",
     "material": ["Red"]
     }
    ]

}
```

#### Groups and nodes

This is the part which finally defines the objects in the world
based on the previous defined materials.

Each group contains a header with the name of the group and the
origin in the world. All nodes in this group are relative to this
origin.

Each `node` in the group contains at least of a `name` to identify
it, a `geometry` which describes the earlier defined shape, a
`position` relative to the group origin and a `size` of the node.
Optional fields are the `id` and the `rotation`.

Some fields can be either a single value or an array of these values:
The `position` and `size` fields are three value vectors (right,
up, forward). The `rotation` fields are four value vectors (right,
up, forward and degrees). The `id` fields are strings.


```
{
    "groups":
    [
     {
     "name": "boxes",
     "origin": [-3, 0, 2],

     "nodes":
     [
      {
      "name": "Large Colourfull box",
      "geometry": "Demo box",
      "id": ["large box #1", "large box #2"],
      "position": [[0, 0, 0], [4.5, 0, 0]],
      "size": [[1, 1, 1], [1, 1, 1]],
      "rotation": [[1, 0, 0, 90], [1, 0, 0, 180]]
      }, {
      "name": "Small Colourfull box",
      "geometry": "Demo box",
      "id": "small box #1",
      "position": [2, 0, 0],
      "size": [0.5, 0.5, 0.5],
      "rotation": [0, 0, 1, 90]
      }
      ]
     }
    ]
}
```

### API

Each scenario is implemented like this:

```
- (void)viewDidLoad
{
    [super viewDidLoad];

    objectManager = [[ObjectManager alloc] init];
    [objectManager loadFile:@"Demo.json"];

    [self loadFloor];
}

- (void)loadFloor
{
    // Container to hold all of the 3D geometry
    SCNScene *scene = [SCNScene new];

    // Put all nodes on the screen
    [objectManager.nodes enumerateObjectsUsingBlock:^(NodeObject * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        [scene.rootNode addChildNode:node.node];
    }];

    // Set the scene to the view
    self.sceneView.scene = scene;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];

    // Touch on nodes
    NSArray <SCNHitTestResult *> *res = [self.sceneView hitTest:[[touches anyObject] locationInView:self.sceneView] options:@{SCNHitTestFirstFoundOnlyKey:@YES}];
    if (res.count != 0) {
        SCNHitTestResult *result = res.lastObject;
        SCNNode *block = result.node;

        // Do something with that node
    }
}
```

To get a subset of the nodes based on the group name or or a single node by the `id`:

```
- (NSArray<NodeObject *> *)nodesByGroupName:(NSString *)name;
- (NodeObject *)nodeByID:(NSString *)name;
```

And the position and rotation of every node can be retrieved and set:

```
// Adjust the JSON coordinates into the SCNNode coordinates.
// x is towards the right, y is up, z is forwards.
- (void)nodePositionX:(float)x y:(float)y z:(float)z;

// Adjust the JSON rotation into the SCNNode rotation.
- (void)nodeRotationX:(float)x y:(float)y z:(float)z w:(float)w;

// Returns the bottom left front JSON coordinates of the object.
- (float)jsonPositionX;
- (float)jsonPositionY;
- (float)jsonPositionZ;
```

Note that there is a difference between the JSON position and the
SCNNode position. The JSON position describes the bottom left coordinates while the SCNNode position describes the middle of the object.

Or in formula: the JSON position is (x, y, z), then the SCNNode
position is (x - origin.x + node.size.width, y - origin.y +
node.size.height, -z + origin.z - node.size.length). Don't worry
too much about this, just use the JSON values and the conversion
methods.

## App Store

It is available in the Apple App Store as
[ARGeocaching](https://itunes.apple.com/au/app/argeocaching/id1406235921?mt=8).

Some scenarios require the ARKit and the power of the newer phones,
like the iPhone 6S and higher or the iPad Pro and higher. The app
will disable these automatically.

## Questions, remarks etc

Feel free to log an issue for any issues or email me at
geocaching@mavetju.org for any ideas or help.

## Current scenarios:

- Demo. See how the various basic shapes rotate and move around.

- Caringbah Mines, my first real scenario with this framework.
  Moving elevator, interaction with buttons and chest. Used for
  [GA12490](https://geocaching.com.au/cache/ga12490).

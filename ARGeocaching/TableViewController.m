//
//  TableViewController.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 2/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "main.h"

@interface TableViewController ()

@property (nonatomic, retain) NSArray<NSDictionary *> *caches;
@property (nonatomic        ) BOOL supportsARKit;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"x"];

    self.caches = @[
                    @{@"title": @"GA12490",
                      @"description": @"Caringbah Mines",
                      @"requires-arkit": @YES,
                      @"explanation":
                          @"Follow the instructions on the Geocaching Australia website for GA12490:\n"
                          "Go to a rather large area like a sports field or park. You will need about 20 meters ahead of you and 30 meters to your left.\n"
                          "Find the entrance. Get the escalator up, enter the escalator and go down. Make sure you are inside and keep your hands away from the wall!\n"
                          "At the bottom, look for the chest.\n"
                          "From the chest, obtain the codeword and the final coordinates.\n"
                          "Once the codeword has been obtained and the coordinates have been revaled, the cache can be logged.\n",
                      },
                    @{@"title": @"GAxxxxx",
                      @"requires-arkit": @YES,
                      @"description": @"Totem Pole",
                      @"explanation": @"",
                      },
                    @{@"title": @"Demo",
                      @"description": @"Demo of all objects",
                      @"requires-arkit": @NO,
                      @"explanation":
                          @"Tap on an object to make it move and spin. Tap outside the objects to chose the next type of object.",
                      },
                    ];

    self.supportsARKit = ARConfiguration.isSupported;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (ARConfiguration.isSupported == NO) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Heads up!"
                                    message:@"This device doesn't support the ARKit yet, it requires an A9 or higher processor. You can still run the scenarios which don't require movement, but integrating the images from the camera is not supported."
                                    preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *close = [UIAlertAction
                                actionWithTitle:@"Oh okay...."
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];

        [alert addAction:close];
        [self presentViewController:alert animated:YES completion:nil];
    }

    /*
    NSDictionary *dict = [self.caches objectAtIndex:2];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:[dict objectForKey:@"title"] bundle:nil];
    UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:FALSE completion:nil];
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.caches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"x"];

    NSDictionary *d = [self.caches objectAtIndex:indexPath.row];
    cell.textLabel.text = [d objectForKey:@"title"];
    cell.detailTextLabel.text = [d objectForKey:@"description"];

    if (self.supportsARKit == NO && [[d objectForKey:@"requires-arkit"] boolValue] == YES) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.userInteractionEnabled = NO;
    } else {
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.detailTextLabel.textColor = [UIColor darkTextColor];
        cell.userInteractionEnabled = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.caches objectAtIndex:indexPath.row];

    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:[NSString stringWithFormat:@"%@: %@", [dict objectForKey:@"title"], [dict objectForKey:@"description"]]
                                message:[dict objectForKey:@"explanation"]
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *close = [UIAlertAction
                            actionWithTitle:@"Start"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [alert dismissViewControllerAnimated:YES completion:nil];

                                UIStoryboard *sb = [UIStoryboard storyboardWithName:[dict objectForKey:@"title"] bundle:nil];
                                UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
                                [self presentViewController:viewController animated:FALSE completion:nil];
                            }];

    [alert addAction:close];
    [self presentViewController:alert animated:YES completion:nil];

}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

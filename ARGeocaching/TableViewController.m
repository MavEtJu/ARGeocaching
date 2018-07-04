//
//  TableViewController.m
//  ARGeocaching
//
//  Created by Edwin Groothuis on 2/7/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (nonatomic, retain) NSArray<NSDictionary *> *caches;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"x"];

    self.caches = @[
                    @{@"title": @"GA12490",
                      @"description": @"Caringbah Mines",
                      },
                    @{@"title": @"GAxxxx",
                      @"description": @"Totem Pole",
                      }
                    ];
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSDictionary *dict = [self.caches objectAtIndex:indexPath.row];
    UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:[dict objectForKey:@"title"]];

    [self presentViewController:viewController animated:FALSE completion:nil];
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

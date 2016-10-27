//
//  FriendsViewController.m
//  SlideMenu
//
//  Created by Aryan Ghassemi on 12/31/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "FriendsViewController.h"

@implementation FriendsViewController

- (void)viewDidLoad
{
    NSLog(@"1");
	[super viewDidLoad];
    NSLog(@"2");
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"3");
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"4");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    if(indexPath.row <9){
        cell.textLabel.text = [NSString stringWithFormat:@"Friend %ld", (long)indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"Priend %ld", (long)indexPath.row];
    }
	return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

@end

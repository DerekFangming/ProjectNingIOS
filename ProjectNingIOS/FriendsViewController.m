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
	[super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [PNRelationship getDetailedFriendListWithResponse:^(NSDictionary *newFriendList, NSError *error) {
        if(error == nil){
            friendList = newFriendList;
            friendListTitles = [[newFriendList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [self.tableView reloadData];
        }else{
            [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];            
        }
    }];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [friendListTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [friendListTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [friendListTitles objectAtIndex:section];
    NSArray *sectionFriends = [friendList objectForKey:sectionTitle];
    return [sectionFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cao");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //NSString *sectionTitle = [friendListTitles objectAtIndex:indexPath.section];
    //NSArray *sectionFriends = [friendList objectForKey:sectionTitle];
    //NSString *name = [[sectionFriends objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        NSLog(@"fck");
    }
    
    cell.textLabel.text = @"a";
    NSLog(@"done");
	return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    return friendListTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [friendListTitles indexOfObject:title];
}

@end

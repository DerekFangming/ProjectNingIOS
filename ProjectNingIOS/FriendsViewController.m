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
    
    [PNRelationship getDetailedFriendListWithResponse:^(NSArray *newFriendList, NSError *error) {
        if(error == nil){
            friendList = [self processFriendListToDictionary:newFriendList];
            
            friendListTitles = [[friendList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    FriendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString *sectionTitle = [friendListTitles objectAtIndex:indexPath.section];
    NSArray *sectionFriends = [friendList objectForKey:sectionTitle];
    PNFriend *friend = [sectionFriends objectAtIndex:indexPath.row];
    
    if(cell == nil) {
        cell = [[FriendTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        NSLog(@"fck");
    }
    
    cell.name.text = friend.name;
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

#pragma mark - List data processing -

- (NSMutableDictionary *) processFriendListToDictionary :(NSArray *)newFriendList{
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    
    for(PNFriend *f in newFriendList){
        NSString *index = [f.name substringToIndex:1];
        NSMutableArray *list = [result objectForKey:index];
        if(list == nil) {
            NSMutableArray *newList = [[NSMutableArray alloc] init];
            [newList addObject:f];
            [result setObject:newList forKey:index];
        }else{
            [list addObject:f];
            [result setObject:list forKey:index];
        }
    }
    return result;
}

@end

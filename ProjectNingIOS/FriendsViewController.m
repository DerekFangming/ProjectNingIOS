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
            friendArray = newFriendList;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResultsTitles count];
    }else{
        return [friendListTitles count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResultsTitles objectAtIndex:section];
    }else{
        return [friendListTitles objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *sectionTitle = [searchResultsTitles objectAtIndex:section];
        NSArray *sectionFriends = [searchResults objectForKey:sectionTitle];
        return [sectionFriends count];
    } else{
        NSString *sectionTitle = [friendListTitles objectAtIndex:section];
        NSArray *sectionFriends = [friendList objectForKey:sectionTitle];
        return [sectionFriends count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PNFriend *friend;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *sectionTitle = [searchResultsTitles objectAtIndex:indexPath.section];
        NSArray *sectionFriends = [searchResults objectForKey:sectionTitle];
        friend = [sectionFriends objectAtIndex:indexPath.row];
    }else{
        NSString *sectionTitle = [friendListTitles objectAtIndex:indexPath.section];
        NSArray *sectionFriends = [friendList objectForKey:sectionTitle];
        friend = [sectionFriends objectAtIndex:indexPath.row];
    }
    
    
    if(cell == nil) {
        cell = [[FriendTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = @"FCK";
        NSLog(@"fck");
    }
    
    cell.name.text = friend.name;
    [cell.avatar setImage:[UIImage imageNamed:@"ff.png"]];
	return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResultsTitles;
    }else{
        return friendListTitles;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResultsTitles indexOfObject:title];
    }else{
        return [friendListTitles indexOfObject:title];
    }
}

#pragma mark - Search bar methods -

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [self processFriendListToDictionary: [friendArray filteredArrayUsingPredicate:resultPredicate]];
    searchResultsTitles = [[searchResults allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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

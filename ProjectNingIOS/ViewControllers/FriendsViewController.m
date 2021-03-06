//
//  FriendsViewController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 6/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "FriendsViewController.h"

@implementation FriendsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = GRAY_BG_COLOR;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    
    //Set up search bar
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //self.searchController.searchBar.scopeButtonTitles = [[NSArray alloc]initWithObjects:@"scopeA", @"scopeB", nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //Set up pull refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor purpleColor];
    //self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadFriendList)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

#pragma mark - Section and list handling -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        if([searchResultsTitles count] == 0){
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
            noDataLabel.text             = @"No data available";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            self.tableView.backgroundView = noDataLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }else{
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.backgroundView = nil;
            return [searchResultsTitles count];
        }
    }else{
        return [friendListTitles count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [searchResultsTitles objectAtIndex:section];
    }else{
        return [friendListTitles objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        NSString *sectionTitle = [searchResultsTitles objectAtIndex:section];
        NSArray *sectionFriends = [searchResults objectForKey:sectionTitle];
        return [sectionFriends count];
    } else{
        NSString *sectionTitle = [friendListTitles objectAtIndex:section];
        NSArray *sectionFriends = [friendList objectForKey:sectionTitle];
        return [sectionFriends count];
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return searchResultsTitles;
    }else{
        return friendListTitles;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.searchController.active) {
        return [searchResultsTitles indexOfObject:title];
    }else{
        return [friendListTitles indexOfObject:title];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    PNUser *friend;
    NSString *sectionTitle;
    NSMutableArray *sectionFriends;
    if (self.searchController.active) {
        sectionTitle = [searchResultsTitles objectAtIndex:indexPath.section];
        sectionFriends = [searchResults objectForKey:sectionTitle];
        friend = [sectionFriends objectAtIndex:indexPath.row];
        //NSLog(@"search!");
    }else{
        sectionTitle = [friendListTitles objectAtIndex:indexPath.section];
        sectionFriends = [friendList objectForKey:sectionTitle];
        friend = [sectionFriends objectAtIndex:indexPath.row];
        //NSLog(@"load!");
    }
    
    
    if(cell == nil) {
        cell = [[FriendTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendCell"];
    }
    
    cell.name.text = friend.displayedName;
    cell.avatar.contentMode = UIViewContentModeScaleAspectFit;
    if(friend.avatar == nil){
        [PNImageManager getSingletonImgForUser:friend.userId withImgType:AVATAR
                         response:^(UIImage *img, NSError *err) {
                             if(err != nil){
                                 friend.avatar = [UIImage imageNamed:@"defaultAvatar.jpg"];
                             }else{
                                 friend.avatar = friend.avatar;
                             }
                             [cell.avatar setImage:img];
                         }];
    }else{
        [cell.avatar setImage:friend.avatar];
    }
    
    return cell;
}

#pragma mark - Search bar methods -

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = self.searchController.searchBar.text;
    //NSInteger scope = self.searchController.searchBar.selectedScopeButtonIndex;
    //if(scope == 0 ) {...}else{...}
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchString];
    if([searchString isEqualToString:@""]){
        searchResults = [self processFriendListToDictionary:friendArray];
    }else{
        searchResults = [self processFriendListToDictionary: [friendArray filteredArrayUsingPredicate:resultPredicate]];
    }
        searchResultsTitles = [[searchResults allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.tableView reloadData];
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
    
    for(PNUser *f in newFriendList){
        NSString *index = [f.displayedName substringToIndex:1];
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

#pragma mark - Pull refresh method -

- (void) reloadFriendList{
    [PNRelationship getDetailedFriendListWithResponse:^(NSArray *newFriendList, NSError *error) {
        if(error == nil){
            friendArray = newFriendList;
            friendList = [self processFriendListToDictionary:newFriendList];
            friendListTitles = [[friendList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }else{
            [self.refreshControl endRefreshing];
            [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];
        }
    }];
}

#pragma mark - Prepare for friend detail segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"friendDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PNUser *friend;
        NSString *sectionTitle;
        NSMutableArray *sectionFriends;
        if (self.searchController.active) {
            sectionTitle = [searchResultsTitles objectAtIndex:indexPath.section];
            sectionFriends = [searchResults objectForKey:sectionTitle];
            friend = [sectionFriends objectAtIndex:indexPath.row];
        }else{
            sectionTitle = [friendListTitles objectAtIndex:indexPath.section];
            sectionFriends = [friendList objectForKey:sectionTitle];
            friend = [sectionFriends objectAtIndex:indexPath.row];
        }
        FriendDetailController *destVC = segue.destinationViewController;
        destVC.userId = friend.userId;
        destVC.displayedName = friend.displayedName;
        destVC.avatar = friend.avatar;
    }
}

@end

//
//  FriendsViewController.h
//  SlideMenu
//
//  Created by Aryan Ghassemi on 12/31/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SlideNavigationController.h"
#import "FriendsDetailViewController.h"
#import "FriendTableCell.h"
#import "PNService.h"

@interface FriendsViewController : UITableViewController <SlideNavigationControllerDelegate, UISearchBarDelegate,UISearchResultsUpdating>{
    NSArray *friendArray;
    NSMutableDictionary *friendList;
    NSArray *friendListTitles;
    NSMutableDictionary *searchResults;
    NSArray *searchResultsTitles;
    
    NSMutableDictionary *imageCache;
}

@property (strong, nonatomic) UISearchController *searchController;

@end

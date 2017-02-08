//
//  FriendsViewController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 6/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SlideNavigationController.h"
#import "FriendDetailController.h"
#import "FriendTableCell.h"
#import "PNService.h"

@interface FriendsViewController : UITableViewController <SlideNavigationControllerDelegate, UISearchBarDelegate,UISearchResultsUpdating>{
    NSArray *friendArray;
    NSMutableDictionary *friendList;
    NSArray *friendListTitles;
    NSMutableDictionary *searchResults;
    NSArray *searchResultsTitles;
}

@property (strong, nonatomic) UISearchController *searchController;

@end

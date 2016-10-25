//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
	self.tableView.backgroundView = imageView;
    
    /*
     0 ... Home view controller
     1 ... Friend view controller
     */
    self.currentTab = 0;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
	
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"Home";
			break;
			
		case 1:
			cell.textLabel.text = @"Friends";
			break;
			
		case 2:
			cell.textLabel.text = @"Chat";
			break;
			
		case 3:
			cell.textLabel.text = @"Profile";
			break;
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	
	UIViewController *vc ;
	
    [self preserveVCState];
    
	switch (indexPath.row)
	{
		case 0:
            vc = [[VCHolder sharedInstance] getHomeVC];
			break;
			
		case 1:
            if([[VCHolder sharedInstance] getFriendVC] == nil){
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FriendsViewController"];
                [[VCHolder sharedInstance] setFriendVC:vc];
            }else{
                vc = [[VCHolder sharedInstance] getFriendVC];
            }
			break;
			
		case 2:
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            return;
			break;
			
		case 3:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
//			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//			[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
//			return;
			break;
	}
    
    self.currentTab = indexPath.row;
	
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

- (void) preserveVCState{
    
    switch (self.currentTab) {
        case 0:
            [[VCHolder sharedInstance] setHomeVC:[[SlideNavigationController sharedInstance] visibleViewController]];
            break;
            
        case 1:
            [[VCHolder sharedInstance] setFriendVC:[[SlideNavigationController sharedInstance] visibleViewController]];
            break;
    }
}

@end

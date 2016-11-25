//
//  FriendsDetailViewController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 11/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "FriendsDetailViewController.h"

@implementation FriendsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.friendDetails = [[NSMutableArray alloc] init];
    
    //self.tableView.backgroundColor = [UIColor lightTextColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [PNUser getDetailInfoForUser:self.userId
                        response:^(NSDictionary *details, NSError *err) {
                            if(err == nil){
                                if([[details objectForKey:@"nickname"] isEqualToString:@""]){
                                    self.nickname = @"";
                                }else{
                                    self.nickname = [@"Nickname : " stringByAppendingString:[details objectForKey:@"nickname"]];
                                }
                                self.gender = [details objectForKey:@"gender"];
                                if(![[details objectForKey:@"name"] isEqualToString:@""])
                                    [self.friendDetails addObject:[@"Name        " stringByAppendingString:[details objectForKey:@"name"]]];
                                if(![[details objectForKey:@"age"] isEqual:@0])
                                    [self.friendDetails addObject:[@"Age            " stringByAppendingString:[[details objectForKey:@"age"] stringValue]]];
                                if(![[details objectForKey:@"location"] isEqualToString:@""])
                                    [self.friendDetails addObject:[@"Location    " stringByAppendingString:[details objectForKey:@"location"]]];
                                if(![[details objectForKey:@"whatsUp"] isEqualToString:@""])
                                    [self.friendDetails addObject:[@"What's up  " stringByAppendingString:[details objectForKey:@"whatsUp"]]];
                                [self.tableView reloadData];
                            }else if([[err localizedDescription] isEqualToString:NO_DETAIL_ERR_MSG]){
                                NSLog(@"No details");
                            }else{
                                [UIAlertController showErrorAlertWithErrorMessage:[err localizedDescription] from:self];
                            }
                        }];
                         
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1 && indexPath.row == 0)
    {
        NSLog(@"1");
    }else if(indexPath.section ==1 && indexPath.row == 1){
        NSLog(@"2");
    }
}

#pragma make - Section and list handling -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2){
        return [self.friendDetails count];
    }else{
        return 1;
    }
    
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0 && indexPath.row == 0){
        FriendDetailTableCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"friendOverviewCell"];
        if(cell == nil) {
            cell = [[FriendDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendOverviewCell"];
        }
        [cell.friendDetailAvatar setImage:self.avatar];
        [cell.friendUserId setText:[@"ID : " stringByAppendingString:[self.userId stringValue]]];
        [cell.friendNickName setText:self.nickname];
        
        //Set up name field
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.bounds = CGRectMake(0, -1, 15, 15);
        if([self.gender isEqualToString:@"M"]){
            attachment.image = [UIImage imageNamed:@"male.png"];
        }else if([self.gender isEqualToString:@"F"]){
            attachment.image = [UIImage imageNamed:@"female.png"];
        }
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:self.displayedName];
        [myString appendAttributedString:attachmentString];
        
        cell.friendDisplayedName.attributedText = myString;
        
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentsCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentsCell"];
        }
        
        return cell;
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
        }
        
        //cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [self.friendDetails objectAtIndex:indexPath.row];
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatBtnCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatBtnCell"];
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }else if (indexPath.section == 1){
        return 70;
    }else{
        return 45;
    }
}

@end

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
    [super viewDidLoad];/*
    // Do any additional setup after loading the view.
    [self.friendUserId setText:[self.friendUserId.text stringByAppendingString:[self.userId stringValue]]];
    [self.friendDetailAvatar setImage: self.avatar];
    
    //Set up name field
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"male.png"];
    attachment.bounds = CGRectMake(0, -1, 15, 15);
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:self.name];
    [myString appendAttributedString:attachmentString];
    
    self.friendDisplayedName.attributedText = myString;*/
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"  ";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1){
        return 12;
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
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 0)
    {
        return 80;
    }else{
        return 45;
    }
}

@end

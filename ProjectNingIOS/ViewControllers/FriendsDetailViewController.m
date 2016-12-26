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
    
    self.tableView.backgroundColor = GRAY_COLOR;
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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section ==1 && indexPath.row == 0)
//    {
//        NSLog(@"1");
//    }else if(indexPath.section ==1 && indexPath.row == 1){
//        NSLog(@"2");
//    }
//}

#pragma make - Section and list handling -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
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
        FriendOverviewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"friendOverviewCell"];
        if(cell == nil) {
            cell = [[FriendOverviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendOverviewCell"];
        }
        [cell.friendDetailAvatar setImage:self.avatar];
        [cell.friendUserId setText:[@"ID : " stringByAppendingString:[self.userId stringValue]]];
        [cell.friendNickName setText:self.nickname];
        
        //Set up image view onclick event
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(zoomInAvatar:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.friendDetailAvatar setUserInteractionEnabled:YES];
        [cell.friendDetailAvatar addGestureRecognizer:singleTap];
        
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
        MomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentsCell"];
        
        if(cell == nil) {
            cell = [[MomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentsCell"];
        }
        
        [PNMomentManager getMomentPreviewImageIdListForUser:self.userId
                                                   response:^(NSError *err, NSArray *idList) {
                                                       if(err != nil){
                                                           [self loadMomentPreviewCell:cell
                                                                            atPosition:0
                                                                          withImageIds:idList];
                                                       }else{
                                                           NSLog(@"something wrong");
                                                       }
                                                   }];
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
        ChatBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatBtnCell"];
        
        if(cell == nil) {
            cell = [[ChatBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatBtnCell"];
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 10000.0f, 0.0f, 0.0f);
        cell.contentView.backgroundColor = GRAY_COLOR;
        cell.backgroundColor = GRAY_COLOR;
        [cell.chatBtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [cell.chatBtn addTarget:self action:@selector(chatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
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

#pragma mark - Table cell button events -

- (void)zoomInAvatar:(UIGestureRecognizer *)gestureRecognizer {
    tempAvatar = (UIImageView *)gestureRecognizer.view;
    
    fullScreenAvatar = [[UIImageView alloc]init];
    [fullScreenAvatar setContentMode:UIViewContentModeScaleAspectFit];
    [fullScreenAvatar setBackgroundColor:[UIColor blackColor]];
    fullScreenAvatar.image = [(UIImageView *)gestureRecognizer.view image];
    CGRect point=[self.view convertRect:gestureRecognizer.view.bounds fromView:gestureRecognizer.view];
    [fullScreenAvatar setFrame:point];
    
    [self.view addSubview:fullScreenAvatar];
    
    [UIView animateWithDuration:0.3 animations:^{
        [fullScreenAvatar setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutAvatar:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [fullScreenAvatar addGestureRecognizer:singleTap];
    [fullScreenAvatar setUserInteractionEnabled:YES];
}

- (void)zoomOutAvatar:(UIGestureRecognizer *)gestureRecognizer {
    CGRect point=[self.view convertRect:tempAvatar.bounds fromView:tempAvatar];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        gestureRecognizer.view.backgroundColor=[UIColor clearColor];
        [(UIImageView *)gestureRecognizer.view setFrame:point];
    } completion:^(BOOL finished) {
        [fullScreenAvatar removeFromSuperview];
        fullScreenAvatar=nil;
    }];
}

- (void)chatButtonClicked {
    NSLog(@"clicked");
}

#pragma  mark - Table cell helpers -

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)loadMomentPreviewCell:(MomentsCell *) cell atPosition:(NSInteger) index withImageIds:(NSArray *) imgIdList{
    if([imgIdList count] > index){
        [PNImageManager downloadImageWithId:[imgIdList objectAtIndex:index]
                                   response:^(UIImage *img, NSError *err) {
                                       if(err == nil){
                                           switch (index) {
                                               case 0:
                                                   [cell.preview1 setImage:img];
                                                   break;
                                               case 1:
                                                   [cell.preview2 setImage:img];
                                                   break;
                                               case 2:
                                                   [cell.preview3 setImage:img];
                                                   break;
                                               case 3:
                                                   [cell.preview4 setImage:img];
                                                   break;
                                               default:
                                                   break;
                                           }
                                           [self loadMomentPreviewCell:cell atPosition:index + 1 withImageIds:imgIdList];
                                       }
                                   }];
    }
}

#pragma mark - Prepare for friend detail segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"friendMomentSegue"]) {
        FriendMomentController *destVC = segue.destinationViewController;
        destVC.displayedName = self.displayedName;
        destVC.avatar = self.avatar;
        destVC.userId = self.userId;
    }
}

@end

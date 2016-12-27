//
//  FriendMomentController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 11/27/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "FriendMomentController.h"

@interface FriendMomentController ()

@end

@implementation FriendMomentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navBar setTitle:self.displayedName];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.momentList = [[NSMutableArray alloc] init];
    
    [PNImageManager getSingletonImgForUser:self.userId
                        withImgType:COVER_IMG
                           response:^(UIImage *img, NSError *err) {
                               if(err != nil){
                                   int randNum = arc4random_uniform(4);
                                   NSString *imgName = [@"coverImg"
                                                        stringByAppendingString:[NSString stringWithFormat:@"%d", randNum]];
                                   self.coverImg = [UIImage imageNamed:[imgName stringByAppendingString:@".png"]];
                               }else{
                                   self.coverImg = img;
                               }
                               [self.tableView reloadData];
                           }];
    [self loadMoreMoments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Section and list -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return [self.momentList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 240;
    }else{
        PNMoment *moment = [self.momentList objectAtIndex:indexPath.row];
        if(moment.hasCoverImg){
            if(moment.isLastMomentOfTheDay){
                return 84;
            }else{
                return 64;
            }
        }else{
            if(moment.isLastMomentOfTheDay){
                return 65;
            }else{
                return 45;
            }
        }
    }
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        MomentCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCoverCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentCoverCell"];
        }
        
        [cell.coverImage setImage:self.coverImg];
        [cell.coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.coverImage setClipsToBounds:YES];
        
        [cell.avatar setImage:self.avatar];
        [cell.avatar.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [cell.avatar.layer setBorderWidth:0.5];
        cell.displayedName.text = self.displayedName;      
        return cell;
    }else{
        PNMoment *moment = [self.momentList objectAtIndex:indexPath.row];
        
        //Process height indicator
        if(indexPath.row == [self.momentList count] - 1){
            moment.isLastMomentOfTheDay = YES;
        }else{
            NSDate *nextDate = [[self.momentList objectAtIndex:indexPath.row + 1] createdAt];
            if(![[NSCalendar currentCalendar] isDate:moment.createdAt inSameDayAsDate:nextDate]){
                moment.isLastMomentOfTheDay = YES;
            }
        }
        
        //Process moment date text
        if(indexPath.row == 0){
            moment.dateText = [self processDateToText:moment.createdAt];
        }else if([[self.momentList objectAtIndex:indexPath.row - 1] isLastMomentOfTheDay]){
            moment.dateText = [self processDateToText:moment.createdAt];
        }
        [[NSCalendar currentCalendar] isDate:moment.createdAt inSameDayAsDate:moment.createdAt];
        //Cell processing for text or image cell
        if(moment.hasCoverImg){
            MomentImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"momentImageCell" forIndexPath:indexPath];
            
            if(cell == nil) {
                cell = [[MomentImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentImageCell"];
            }
            cell.dateLabel.attributedText = moment.dateText;
            cell.momentBody.text = moment.momentBody;
            cell.momentBody.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [PNMomentManager getMomentCoverImgForUser:self.userId
                                             onMoment:moment.momentId
                                             response:^(NSError *err, UIImage *image) {
                                                 if(err == nil){
                                                     [cell.coverImg setImage:image];
                                                 }else{
                                                     //
                                                 }
                                             }];
            
            return cell;
        }else{
            MomentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextCell" forIndexPath:indexPath];
        
            if(cell == nil) {
                cell = [[MomentTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextCell"];
            }
            cell.dateLabel.attributedText = moment.dateText;
            cell.momentBody.text = moment.momentBody;
            cell.momentBody.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.backgroundView setBackgroundColor:GRAY_COLOR];
            cell.momentBody.contentInset = UIEdgeInsetsMake(-4,-2,0,0);
            
            return cell;
        }
    }
}

#pragma mark - moment helpers -

- (void) loadMoreMoments{
    [PNMomentManager getRecentMomentListForUser:self.userId
                                      beforeDte:[NSDate date]
                                      withLimit:[NSNumber numberWithInt:10]
                                       response:^(NSError *err, NSArray *momentList, NSDate *checkPoint) {
                                           if(err == nil){
                                               self.checkPoint = checkPoint;
                                               [self.momentList addObjectsFromArray:momentList];
                                               [self.tableView reloadData];
                                           }else{
                                               //NSLog([err localizedDescription]);
                                           }
                                       }];
}

- (NSMutableAttributedString *) processDateToText: (NSDate *) date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSString *month = [Utils monthToString:[components month]];
    NSString *day = [@([components day]) stringValue];
    UIFont *arialFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *dateText = [[NSMutableAttributedString alloc] initWithString:month attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *dayString = [[NSMutableAttributedString alloc]initWithString: day attributes:verdanaDict];
    [dateText appendAttributedString:dayString];
    return dateText;
}

#pragma mark - Prepare for friend detail segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"momentTextDetailSegue"]) {
        MomentTextController *destVC = segue.destinationViewController;
        NSString * a =  self.displayedName;
        destVC.displayedName = a;
        destVC.avatar = self.avatar;
        destVC.userId = self.userId;
        destVC.momentBody = ((MomentTextCell *)sender).momentBody.text;
    }
}

@end

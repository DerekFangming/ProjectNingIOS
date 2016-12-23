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
        return 80;
    }
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        MomentCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coverPageCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"coverPageCell"];
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
        
        //Date processing
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:moment.createdAt];
        NSString *month = [Utils monthToString:[components month]];
        NSString *day = [@([components day]) stringValue];
        UIFont *arialFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
        NSMutableAttributedString *dateText = [[NSMutableAttributedString alloc] initWithString:month attributes: arialDict];
        
        UIFont *VerdanaFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
        NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: day attributes:verdanaDict];
        [dateText appendAttributedString:vAttrString];
        
        //Cell processing for text or image cell
        if(moment.hasCoverImg){
            MomentImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"momentImageCell" forIndexPath:indexPath];
            
            if(cell == nil) {
                cell = [[MomentImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentImageCell"];
            }
            cell.dateLabel.attributedText = dateText;
            cell.momentBody.text = moment.momentBody;
            cell.momentBody.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [PNMomentManager getMomentCoverImgForUser:self.userId
                                             onMoment:moment.momentId
                                             response:^(NSError *err, UIImage *image) {
                                                 NSLog(@"loaded");
                                                 if(err == nil){
                                                     [cell.coverImg setImage:image];
                                                 }else{
                                                     NSLog([err localizedDescription]);
                                                 }
                                             }];
            
            return cell;
        }else{
            MomentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextCell" forIndexPath:indexPath];
        
            if(cell == nil) {
                cell = [[MomentTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextCell"];
            }
            cell.dateLabel.attributedText = dateText;
            cell.momentBody.text = moment.momentBody;
            cell.momentBody.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            
            return cell;
        }
    }
}

#pragma mark - moment helpers -

- (void) loadMoreMoments{
    [PNMomentManager getRecentMomentListForUser:self.userId
                                      beforeDte:[NSDate date]
                                      withLimit:[NSNumber numberWithInt:5]
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

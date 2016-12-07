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
        return 2;
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
        
        [cell.coverImage setImage:[UIImage imageNamed:@"coverImg1.png"]];
        [cell.coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.coverImage setClipsToBounds:YES];
        [cell.avatar setImage:self.avatar];
        [cell.avatar.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [cell.avatar.layer setBorderWidth:0.5];
        cell.displayedName.text = self.displayedName;      
        return cell;
    }else{
        MomentPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentCell"];
        }
        
        UIFont *arialFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"Jan" attributes: arialDict];
        
        UIFont *VerdanaFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
        NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: @"1st" attributes:verdanaDict];
        [aAttrString appendAttributedString:vAttrString];
        
        cell.dateLabel.attributedText = aAttrString;
        
        return cell;
    }
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

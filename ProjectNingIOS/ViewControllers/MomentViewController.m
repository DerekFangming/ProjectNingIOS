//
//  MomentViewController.m
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/15/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "MomentViewController.h"

@implementation MomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    row = 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCoverCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[MomentCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentCoverCell"];
    }
    /*
    [cell.coverImage setImage:self.coverImg];
    [cell.coverImage setContentMode:UIViewContentModeScaleAspectFill];
    [cell.coverImage setClipsToBounds:YES];
    
    [cell.avatar setImage:self.avatar];
    [cell.avatar.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [cell.avatar.layer setBorderWidth:0.5];*/
    cell.displayedName.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    if(indexPath.row == row - 1){
        NSLog(@"reload");
        row += 5;
        [self.tableView reloadData];
    }
    
    return cell;
    
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

@end

//
//  MomentTextController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 12/26/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "MomentTextController.h"

@interface MomentTextController ()

@end

@implementation MomentTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Section and list -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return headerCellHeight + 30;
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentTextHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextHeaderCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[MomentTextHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentImageCell"];
    }
    
    [cell.avatar setImage: self.avatar];
    cell.nameLabel.text = self.displayedName;
    cell.nameLabel.textColor = PURPLE_COLOR;
    cell.momentTextField.text = [self.momentBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    [cell.momentTextField sizeToFit];
    [cell.momentTextField layoutIfNeeded];
    CGSize size = [cell.momentTextField
                      sizeThatFits:CGSizeMake(cell.momentTextField.frame.size.width, CGFLOAT_MAX)];
    headerCellHeight = size.height;
    NSLog(@"%f",size.height);
    [cell.momentTextField setContentSize:size];
    
    return cell;
}



@end

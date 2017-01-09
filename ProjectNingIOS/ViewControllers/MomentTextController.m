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
    
    self.likeCellHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return headerCellHeight + 45;
    }else if(indexPath.row == 1){
        return self.likeCellHeight;
    }else{
        return 45;
    }
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        MomentTextHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextHeaderCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentTextHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentImageCell"];
        }
        //Remove seperator?
        //cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        
        [cell.avatar setImage: self.avatar];
        cell.nameLabel.text = self.displayedName;
        cell.nameLabel.textColor = PURPLE_COLOR;
        cell.momentTextField.text = [self.momentBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
        [cell.momentTextField sizeToFit];
        [cell.momentTextField layoutIfNeeded];
        CGSize size = [cell.momentTextField
                       sizeThatFits:CGSizeMake(cell.momentTextField.frame.size.width, CGFLOAT_MAX)];
        headerCellHeight = size.height;
        
        [cell.momentTextField setContentSize:size];
        cell.dateLabel.text = [self processDateToText:self.createdAt];
        
        if(self.likedByCurrentUser) [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        else [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
        
        [cell.likeBtn addTarget:self action:@selector(okButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextLikeCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextLikeCell"];
        }
        
        NSLog(@"%f", cell.bounds.size.width);
        NSLog(@"%f", cell.bounds.size.height);
        
        int commentCount = 7;
        
        int cellwidth = (int) roundf(cell.bounds.size.width);
        int picPerRow = (cellwidth - 75) / 35;
        
        int totalRows = ceil((float)commentCount / (float)picPerRow);
        for(int i = 0; i < picPerRow; i ++){
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(60 + i * 35, 7, 30, 30)];
            imv.image=[UIImage imageNamed:@"defaultAvatar.jpg"];
            [cell.contentView addSubview:imv];
        }
        
        
        
        [cell.contentView setBackgroundColor:GRAY_BG_COLOR];
        
        return cell;
        
    }else{
        return nil;
    }
}

#pragma mark - Like and comment button events -

- (void)okButtonTapped:(UIButton *)sender{
    if(self.likedByCurrentUser){
        [sender setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
        self.likedByCurrentUser = NO;
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        self.likedByCurrentUser = YES;
    }
    
}

#pragma mark - Helpers -

- (NSString *) processDateToText: (NSDate *) date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    NSString *month = [Utils monthToString:[components month] withAbbreviation:NO];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@, %@", month, [@([components day]) stringValue],
                         [@([components year]) stringValue]];
    dateStr = [NSString stringWithFormat:@"%@ %@:%@", dateStr, [@([components hour]) stringValue],
               [@([components minute]) stringValue]];
    return dateStr;
}

@end

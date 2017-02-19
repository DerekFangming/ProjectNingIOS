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
    if(indexPath.section == 0){
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
    }else{
        return nil;
    }
    
}

- (IBAction)createMomentTapped:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePic = [UIAlertAction
                             actionWithTitle:@"Take a picture"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                 {
                                     [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                                     [imagePickerController setDelegate:self];
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     [self presentViewController:imagePickerController animated:YES completion:nil];
                                 }else{
                                     [UIAlertController showErrorAlertWithErrorMessage:@"Camera not available on this devide"
                                                                                  from:self];
                                 }
                             
                             }];
    
    UIAlertAction* selectPic = [UIAlertAction
                               actionWithTitle:@"Select pictures from album"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                   [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                   [imagePickerController setDelegate:self];
                                   [view dismissViewControllerAnimated:YES completion:nil];
                                   [self presentViewController:imagePickerController animated:YES completion:nil];
                               }];
    
    UIAlertAction* enterText = [UIAlertAction
                                actionWithTitle:@"Enter text moment"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:takePic];
    [view addAction:selectPic];
    [view addAction:enterText];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil]; //Do this first!!
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image != nil){
        NSLog(@"1");
    }else{
        NSLog(@"2");
    }
    //image = [ImageHelpers imageWithImage:image scaledToSize:CGSizeMake(480, 640)];
    
    //[imageView setImage:image];
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

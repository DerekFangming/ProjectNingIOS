//
//  MomentInputController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 2/3/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "MomentInputController.h"

@implementation MomentInputController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.sendBtn setTintColor:GREEN_COLOR];
    [self.sendBtn setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    self.commentInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.commentInput.delegate = self;
    self.commentInput.text = self.unsentComment;
    [self.commentInput setReturnKeyType:UIReturnKeySend];
    [self.view addSubview:self.commentInput];
    
    [self.commentInput becomeFirstResponder];
    
}
- (IBAction)sendBtnTapped:(id)sender {
    [PNCommentManager createComment:self.commentInput.text
                     forCommentType:@"Feed"
                       andMappingId:self.momentId
                       mentionsUser:nil
                           response:^(NSError *error, NSNumber *commentId) {
                               if(error != nil){
                                   [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                from: self];
                               }else{
                                   self.commentInput.text = @"";
                                   [self performSegueWithIdentifier:@"commentInputUnwind" sender:nil];
                               }
                           }];
}

#pragma mark - Keyboard and text view delegate methods -

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    CGSize kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger textfieldHeight = self.view.frame.size.height - kbSize.height;
    CGRect currentFrame = self.commentInput.frame;
    currentFrame.size.height = textfieldHeight;
    self.commentInput.frame = currentFrame;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        [self.sendBtn setEnabled:NO];
    }else{
        [self.sendBtn setEnabled:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" "];
        NSString* trimmedStr = [self.commentInput.text stringByTrimmingCharactersInSet:charsToTrim];
        
        if([trimmedStr isEqualToString:@""]){
            [UIAlertController showErrorAlertWithErrorMessage:@"Cannot send an empty comment" from:self];
        }else{
            [PNCommentManager createComment:self.commentInput.text
                             forCommentType:@"Feed"
                               andMappingId:self.momentId
                               mentionsUser:nil
                                   response:^(NSError *error, NSNumber *commentId) {
                                       if(error != nil){
                                           [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                        from: self];
                                       }else{
                                           self.commentInput.text = @"";
                                           [self performSegueWithIdentifier:@"commentInputUnwind" sender:nil];
                                       }
                                   }];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
    [self.view addSubview:self.commentInput];
    
    [self.commentInput becomeFirstResponder];
    
}
- (IBAction)cancelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

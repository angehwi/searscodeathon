//
//  SEARSPostViewController.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSPostViewController.h"

@interface SEARSPostViewController ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;

@end

@implementation SEARSPostViewController{
    UIImage *imageToPost;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self callCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Post Button Event
- (IBAction)handlePost:(id)sender {
    NSLog(@"handlePost");
    
    NSLog(@"Title: %@", self.titleText.text);
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Camera Call

- (void)callCamera{
    NSLog(@"callCamera");
    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
    [cameraPicker setDelegate:(id)self];
    cameraPicker.allowsEditing = YES;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:cameraPicker animated:YES completion:^{
        
    }];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Info Dictionary: %@", info);
    self.postImageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.postImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.titleText.text = @"Test Photo Title";
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

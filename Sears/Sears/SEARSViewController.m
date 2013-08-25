//
//  SEARSViewController.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSViewController.h"
#import "SEARSCollectionViewController.h"
#import "SEARSPostViewController.h"

@interface SEARSViewController ()
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;


@end

@implementation SEARSViewController{
    SEARSCollectionViewController *collecionViewController;
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
    [self.navigationController.navigationBar setHidden:NO];
    [self initializeCollectinoView];
    [self setNavigationBar];
    [self setCameraButton];

}

-(void)setNavigationBar{
    CGFloat red = 0.1019;
    CGFloat green = 0.7372;
    CGFloat blue = 0.6117;
    UIColor *customColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.navigationController.navigationBar.tintColor = customColor;
    
}

-(void)setCameraButton{
    UIImage* cameraImage = [UIImage imageNamed:@"camera.png"];
    CGRect frameimg = CGRectMake(0, 0, cameraImage.size.width, cameraImage.size.height);
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:frameimg];
    [cameraButton setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(segueToPostViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *cameraBarButton =[[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    self.navigationItem.rightBarButtonItem=cameraBarButton;
    
}
-(void)segueToPostViewController{
    NSLog(@"segueToPostViewController");
    SEARSPostViewController *postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"POST_VC"];
    [self.navigationController pushViewController:postVC animated:YES];
    
}

-(void)initializeCollectinoView{
    collecionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COLLECION_VC"];
    [self addChildViewController:collecionViewController];
//    [self.view addSubview:collecionViewController.view];
    [collecionViewController didMoveToParentViewController:self];
//    mainCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MAIN_COLLECTION_VIEW"];
//    [self addChildViewController:mainCollectionViewController];
//    [self.view addSubview:mainCollectionViewController.view];
//    
//    [mainCollectionViewController didMoveToParentViewController:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

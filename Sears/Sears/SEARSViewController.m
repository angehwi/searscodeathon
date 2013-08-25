//
//  SEARSViewController.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSViewController.h"
#import "SEARSCollectionViewController.h"

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
    

}

-(void)initializeCollectinoView{
    collecionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COLLECION_VC"];
    [self addChildViewController:collecionViewController];
    [self.view addSubview:collecionViewController.view];
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

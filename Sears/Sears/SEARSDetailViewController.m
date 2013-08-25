//
//  SEARSDetailViewController.m
//  Sears
//
//  Created by Kwanghwi Kim on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSDetailViewController.h"
#import "SEARSCatalogueViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SEARSDetailViewController () <UIScrollViewDelegate>

@end

@implementation SEARSDetailViewController

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
    
    NSLog(@"Dictionary: %@", self.dict);
    
    [self.contentScrollView setDelegate:self]; 
    [self.contentScrollView setScrollEnabled:YES];
//    [self.contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.photoView.frame.size.height + self.addDetailButton.frame.size.height + self.detailInfoView.frame.size.height )];
//    NSLog(@"ContentSize: %@", NSStringFromCGSize(self.contentScrollView.contentSize));
    [self.detailInfoView setAlpha:0.0];
     // TODO: dict받은 뒤 주석 해제하기. 
//    [_photoView setImageWithURL:[NSURL URLWithString: [_dict objectForKey:@"id"]]
//                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [_photoView setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://talkloud.com/_sears/uploads/photo_%@.jpg", [self.dict objectForKey:@"prod_id"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}
-(void)viewDidLayoutSubviews{
    [self.contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.photoView.frame.size.height + self.addDetailButton.frame.size.height + self.detailInfoView.frame.size.height )];
    NSLog(@"ContentSize: %@", NSStringFromCGSize(self.contentScrollView.contentSize));    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"CATALOGUE_SEGUE" isEqualToString:segue.identifier]){
        SEARSCatalogueViewController *catalogueVC = (SEARSCatalogueViewController *)segue.destinationViewController;
        catalogueVC.delegate = self;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _photoView;
}

- (void)addDetailInformation:(NSDictionary *)info{
    
    
    
    self.productName.text = [[info objectForKey:@"Description"] objectForKey:@"Name"];
//    self.productImage =  [[info objectForKey:@"Description"] objectForKey:@"ImageURL"];
    self.productPrice.text  = [[info objectForKey:@"Price"] objectForKey:@"DisplayPrice"];
    self.store.text = [self.dict objectForKey:@"store_name"];
    self.likeDate.text = @"";
    [self.detailInfoView setAlpha:1.0];
}
-(NSDictionary *)extractProductInfo:(NSDictionary *)productDic{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    
//    newDictionary setObject:[productDic objectForKey:@"Id"] forKey:Sear
    
    return newDictionary;
    
}



@end

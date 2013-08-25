//
//  SEARSCatalogueViewController.m
//  Sears
//
//  Created by Kwanghwi Kim on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSCatalogueViewController.h"
#import "SEARSHTTPModel.h"
#import "SEARSProductCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SEARSCatalogueViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *products;
    SEARSHTTPModel *httpModel;
}

@end

@implementation SEARSCatalogueViewController

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
    httpModel = [SEARSHTTPModel sharedHTTPModel];
    [self.keywordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SEARSProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    
    NSDictionary *productDict = [products objectAtIndex:indexPath.row];
 
    NSString *imageUrl = [[productDict objectForKey:@"Description"] objectForKey:@"ImageURL"];
    NSString *name = [[productDict objectForKey:@"Description"] objectForKey:@"Name"];
    NSNumber *price = [[productDict objectForKey:@"Price"] objectForKey:@"DisplayPrice"];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [cell.productImage setImageWithURL:[NSURL URLWithString: imageUrl]];
    
    cell.productName.text = name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *productDict = [products objectAtIndex:indexPath.row];
    [_delegate addDetailInformation:productDict];
    [[self navigationController] popViewControllerAnimated:NO];
}

- (IBAction)searchButtonPressed:(id)sender {
    NSDictionary *searchResults = [httpModel getProductsWithKeyword:self.keywordTextField.text];
    products = [[searchResults objectForKey:@"SearchResults"] objectForKey:@"Products"];
    [self.keywordTextField resignFirstResponder];
    [self.productTableView reloadData];
    
}





@end

//
//  SEARSCollectionViewController.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSCollectionViewController.h"
#import "SEARSCollectionViewCell.h"
#import "SEARSCollectionViewFlowLayout.h"
#import "SEARSHTTPModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SEARSCollectionViewController ()

@end

@implementation SEARSCollectionViewController{
    NSArray *listArray;
    SEARSHTTPModel *httpModel;
}


#pragma mark - ViewController Life Cycle


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"ViewWillAppear");
    
    listArray = [httpModel getList:@"like"];
    [self.collectionView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
	// Do any additional setup after loading the view.
    httpModel = [SEARSHTTPModel sharedHTTPModel];   
    
    self.collectionView.dataSource = self;
    [self collectionViewStyle];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CollectionView Layout

-(void)collectionViewStyle{
    [self.collectionView setCollectionViewLayout:[[SEARSCollectionViewFlowLayout alloc] init] animated:NO];
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
    }
    
    return reusableview;
}


#pragma mark - CollectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSLog(@"numberOfSectionsInCollectionView");
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"numberOfItemsInSection");
    return [listArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SEARSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PHOTO_CELL" forIndexPath:indexPath];
    
    NSDictionary *cellDictionary = [listArray objectAtIndex:indexPath.row];
    NSString *photoID = [cellDictionary objectForKey:@"prod_id"];
    NSString *photoURLString = [NSString stringWithFormat: @"http://talkloud.com/_sears/uploads/photo_%@.jpg", photoID];

    [cell.productPhoto setImageWithURL:[NSURL URLWithString:photoURLString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [cell.productPhoto setContentMode:UIViewContentModeScaleAspectFit];
        
        cell.heart.hidden = NO;
        cell.likesLabel.text = [cellDictionary objectForKey:@"num_like"];
        cell.likesLabel.hidden = NO;
        
        [cell backGroundColor];
        cell.store_name.text  = [cellDictionary objectForKey:@"store_name"];
        cell.store_name.hidden = NO;
        
        if(5>indexPath.row){
            UIImage *medalImage = [UIImage imageNamed:[NSString stringWithFormat:@"medal_%d.png",indexPath.row+1]];
            cell.medalImageView = [[UIImageView alloc] initWithImage:medalImage];
            [cell.medalImageView setFrame:CGRectMake(5,5, 32, 42.5)];
            [cell addSubview:cell.medalImageView];
        }
    }];
 
    return cell;
}


@end

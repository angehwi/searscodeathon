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
@interface SEARSCollectionViewController ()

@end

@implementation SEARSCollectionViewController{
    NSArray *listArray;
    SEARSHTTPModel *httpModel;
    NSOperationQueue *photoQueue;
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
    //    listDictionary = [[NSDictionary alloc] initWithDictionary:[httpModel getList:@"like"] copyItems:YES];
    
    
    self.collectionView.dataSource = self;
    photoQueue = [NSOperationQueue new];
    
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
    
    cell.store_name.text  = [cellDictionary objectForKey:@"store_name"];
    
    [photoQueue addOperationWithBlock:^{
        NSString *photoID = [cellDictionary objectForKey:@"prod_id"];
        NSString *photoURLString = [NSString stringWithFormat: @"http://talkloud.com/_sears/uploads/photo_%@.jpg", photoID];
        NSURL *photoURL = [NSURL URLWithString:photoURLString];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        UIImage *photoImage = [UIImage imageWithData:photoData];
        cell.productPhoto.image = photoImage;
        [cell.productPhoto setContentMode:UIViewContentModeScaleAspectFit];

    }];

    return cell;
}

@end

//
//  SEARSCollectionViewController.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSCollectionViewController.h"
#import "SEARSCollectionViewCell.h"
#import "SEARSHTTPModel.h"
@interface SEARSCollectionViewController ()

@end

@implementation SEARSCollectionViewController{
    NSArray *listArray;
    SEARSHTTPModel *httpModel;
}




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
    cell.createdDate.text  = [cellDictionary objectForKey:@"create_date"];
    
    return cell;
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
    NSLog(@"ViewDidLoad");
	// Do any additional setup after loading the view.
    httpModel = [SEARSHTTPModel sharedHTTPModel];
//    listDictionary = [[NSDictionary alloc] initWithDictionary:[httpModel getList:@"like"] copyItems:YES];
    listArray = [httpModel getList:@"like"];
    
    self.collectionView.dataSource = self;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

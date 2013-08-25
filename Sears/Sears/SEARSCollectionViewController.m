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
    NSOperationQueue *photoQueue;
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"ViewWillAppear");
    
    listArray = [httpModel getList:@"like"];
    [self.collectionView reloadData];
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
    
    [photoQueue addOperationWithBlock:^{
        NSString *photoID = [cellDictionary objectForKey:@"prod_id"];
        NSString *photoURLString = [NSString stringWithFormat: @"http://talkloud.com/_sears/uploads/photo_%@.jpg", photoID];
        NSURL *photoURL = [NSURL URLWithString:photoURLString];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        UIImage *photoImage = [UIImage imageWithData:photoData];
        cell.productPhoto.image = photoImage;
        [cell.productPhoto setContentMode:UIViewContentModeScaleAspectFit];

    }];
//    http://talkloud.com/_sears/uploads/photo_1.jpg.
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

    
    self.collectionView.dataSource = self;
    photoQueue = [NSOperationQueue new];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SEARSDetailViewController.h
//  Sears
//
//  Created by Kwanghwi Kim on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEARSCatalogueViewController.h"

@interface SEARSDetailViewController : UIViewController <SEARSCatalogueViewControllerDelegate>

@property (nonatomic, retain) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addDetailButton;
//@property (weak, nonatomic) IBOutlet UILabel *productName;
//@property (weak, nonatomic) IBOutlet UILabel *likeDate;
//@property (weak, nonatomic) IBOutlet UILabel *productPrice;
//@property (weak, nonatomic) IBOutlet UILabel *store;
//@property (strong, nonatomic)  UILabel *productName;
//@property (strong, nonatomic)  UILabel *likeDate;
//@property (strong, nonatomic)  UILabel *productPrice;
//@property (strong, nonatomic)  UILabel *store;

@property (weak, nonatomic) IBOutlet UIImageView *searsPhotoView;

-(void) addDetailInformation:(NSDictionary *)info;

@end

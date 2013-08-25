//
//  SEARSCatalogueViewController.h
//  Sears
//
//  Created by Kwanghwi Kim on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SEARSCatalogueViewControllerDelegate <NSObject>
@optional
-(void) addDetailInformation:(NSDictionary *)info;
@end

@interface SEARSCatalogueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
}
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (nonatomic, retain) id<SEARSCatalogueViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end



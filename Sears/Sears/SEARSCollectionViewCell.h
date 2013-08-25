//
//  SEARSCollectionViewCell.h
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEARSCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *createdDate;
@property (weak, nonatomic) IBOutlet UIImageView *productPhoto;
@property (nonatomic, copy) NSString *displayString;
@end

//
//  SEARSCollectionViewCell.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSCollectionViewCell.h"

@implementation SEARSCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
-(void)prepareForReuse{
//    NSLog(@"prepareForReuse");
    self.productPhoto.image = nil;
    self.medalImageView.image = nil;
    
    self.heart.hidden = YES;
    self.likesLabel.hidden = YES;
    self.store_name.hidden = YES;
}
-(void)backGroundColor{
    self.store_name.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

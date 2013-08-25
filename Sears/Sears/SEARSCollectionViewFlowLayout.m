//
//  SEARSCollectionViewFlowLayout.m
//  Sears
//
//  Created by Leonljy on 13. 8. 25..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSCollectionViewFlowLayout.h"

@implementation SEARSCollectionViewFlowLayout

-(id)init
{
    self = [super init];
    
    self.itemSize = CGSizeMake(158.5, 158.5);
    self.sectionInset = UIEdgeInsetsMake(1,1,1,1);
    self.minimumInteritemSpacing = 1.0f;
    self.minimumLineSpacing = 1.0f;
    
    
    return self;
}

@end

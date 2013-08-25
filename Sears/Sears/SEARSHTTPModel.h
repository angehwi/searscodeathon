//
//  SEARSHTTPModel.h
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
@interface SEARSHTTPModel : UICollectionViewCell
+(SEARSHTTPModel *)sharedHTTPModel;
-(NSArray *)getList:(NSString *)order;
-(void)postPhoto:(UIImage *)image;
- (NSDictionary *)getProductsWithKeyword:(NSString *)keyword;
-(void)updateProduct:(NSDictionary *)productDic;
-(NSDictionary *)getProductWithProductID:(NSString *)productID;
@end

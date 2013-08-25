//
//  SEARSDetailViewController.m
//  Sears
//
//  Created by Kwanghwi Kim on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSDetailViewController.h"
#import "SEARSCatalogueViewController.h"
#import "SEARSHTTPModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SEARSDetailViewController () <UIScrollViewDelegate>

@end

@implementation SEARSDetailViewController{
    SEARSHTTPModel *httpModel;
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
    
    NSLog(@"Dictionary: %@", self.dict);
    httpModel = [SEARSHTTPModel sharedHTTPModel];
    [self.contentScrollView setDelegate:self]; 
    [self.contentScrollView setScrollEnabled:YES];
    
    
    
     // TODO: dict받은 뒤 주석 해제하기. 
    [_photoView setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://talkloud.com/_sears/uploads/photo_%@.jpg", [self.dict objectForKey:@"prod_id"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.dict =  [httpModel getProductWithProductID:[self.dict objectForKey:@"prod_id"]];
    if([@"" isEqualToString:[self.dict objectForKey:@"sears_id"]]){
        NSLog(@"Detail Infomation");
        [self.detailInfoView setAlpha:0.0];
    }else{
        [self showDetailInfos];
    }
}

-(void)showDetailInfos{
    NSString *titleString =[self.dict objectForKey:@"title"];
    titleString = [titleString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UILabel *productName = [[UILabel alloc]initWithFrame:CGRectMake(5,5, 300, 20)];
    productName.text = titleString;
    [self.detailInfoView addSubview:productName];
    
    NSString *urlString = [self.dict objectForKey:@"sears_photo"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URLString: %@", urlString);
    NSURL *searsPhotoURL = [NSURL URLWithString:urlString];
    [self.searsPhotoView setImageWithURL:searsPhotoURL];
    [self.searsPhotoView setContentMode:UIViewContentModeScaleAspectFit];

    UILabel *productPrice =[[UILabel alloc]initWithFrame:CGRectMake(5,30, 300, 20)];
    NSMutableString *priceString = [[NSMutableString alloc] initWithFormat:@"%@",[self.dict objectForKey:@"price"]];
    [priceString insertString:@"." atIndex:[priceString length]-2];
    productPrice.text  = [NSString stringWithFormat:@"Price: $ %@", priceString];
    [self.detailInfoView addSubview:productPrice];

    UILabel *store = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 300, 20)];
    store.text = [NSString stringWithFormat:@"Store: %@", [self.dict objectForKey:@"store_name"]];
    [self.detailInfoView addSubview:store];

    UILabel *shipping = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 300, 20)];
    shipping.text = @"Shipping: Free shipping";
    [self.detailInfoView addSubview:shipping];
    
    [self.detailInfoView setAlpha:1.0];
}
-(void)viewDidLayoutSubviews{
    [self.contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.photoView.frame.size.height + self.addDetailButton.frame.size.height + self.detailInfoView.frame.size.height )];
//    NSLog(@"ContentSize: %@", NSStringFromCGSize(self.contentScrollView.contentSize));    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"CATALOGUE_SEGUE" isEqualToString:segue.identifier]){
        SEARSCatalogueViewController *catalogueVC = (SEARSCatalogueViewController *)segue.destinationViewController;
        catalogueVC.delegate = self;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _photoView;
}
- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}
- (void)addDetailInformation:(NSDictionary *)info{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    
    //    newDictionary setObject:[productDic objectForKey:@"Id"] forKey:Sear
    
    [newDictionary setObject:[self.dict objectForKey:@"prod_id"] forKey:@"prod_id"];
    
    NSString *titleString = [self encodeURL:[[info objectForKey:@"Description"] objectForKey:@"Name"]];
    [newDictionary setObject:titleString forKey:@"title"];
    
    NSString *imageURLString = [self encodeURL:[[info objectForKey:@"Description"] objectForKey:@"ImageURL"]];
    imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    [newDictionary setObject:imageURLString forKey:@"sears_photo"];

    NSString *priceString = [[[info objectForKey:@"Price"] objectForKey:@"DisplayPrice"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [newDictionary setObject:priceString forKey:@"price"];
    
    [newDictionary setObject:[[info objectForKey:@"Id"] objectForKey:@"PartNumber"] forKey:@"sears_id"];

    NSLog(@"Dictionary: %@", newDictionary);
    
    [httpModel updateProduct:newDictionary];


}




@end

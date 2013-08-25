//
//  SEARSHTTPModel.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSHTTPModel.h"

@implementation SEARSHTTPModel

static SEARSHTTPModel *instance;

#pragma mark - Class Initialize Codes

+(SEARSHTTPModel *)sharedHTTPModel{
    if(nil == instance){
        instance = [[SEARSHTTPModel alloc] init];
        
    }
    
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(NSArray *)getList:(NSString *)order{
    NSData *data = [self getListFromServer:order];
    NSArray *result = [self parseJSONtoArray:data];
    
//    NSLog(@"List Info\n%@",result);
    return result;
}


-(NSData *)getListFromServer:(NSString *)order{
    order = @"like";
    NSString *urlString = [NSString stringWithFormat:@"http://talkloud.com/_sears/app.php?action=list&order=%@", order];
    
//    NSLog(@"URLString: %@", urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data= [NSData dataWithContentsOfURL:url];
    


    return data;
}


#pragma mark - JSON Parsing

-(NSArray *)parseJSONtoArray:(NSData *)data{
//    __autoreleasing
//    NSError *error;
//    NSArray *ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    jsonString = [jsonString substringFromIndex:5];
//    NSLog(@"JSonString: %@", jsonString);
    NSArray *dictionary = [jsonString objectFromJSONString];

    return dictionary;
}

-(NSDictionary *)parseJSONtoDictionary:(NSData *)APIData{
    NSData *data = APIData;
    
    __autoreleasing
    NSError *error;
    NSDictionary *ret= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return ret;
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

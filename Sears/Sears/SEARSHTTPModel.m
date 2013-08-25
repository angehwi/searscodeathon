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
#pragma mark - getters

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

-(NSString *)getLocation:(CGFloat)latitude Lng:(CGFloat)longitude{
    NSData *data = [self getLocationFromMomentFeedWithLat:latitude Lng:longitude];
    NSDictionary *result = [self parseJSONtoDictionary:data];
    
//    NSLog(@"Location Info\n%@",result);
    NSArray *locations = [result objectForKey:@"locations"];
    
    if(0 == [locations count]){
        return nil;
    }
    NSDictionary *location = [locations objectAtIndex:0];
    NSString *address = [location objectForKey:@"address"];
    
    return address;
}


-(NSData *)getLocationFromMomentFeedWithLat:(CGFloat)latitude Lng:(CGFloat)longitude{

    NSString *urlString = [NSString stringWithFormat:@"http://api.momentfeed.com/location/search?q={\"geo\":{\"lat\":\"%f\",\"lng\":\"%f\", \"radius\":\"10\"}}&api_token=sears", latitude, longitude];

    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data= [NSData dataWithContentsOfURL:url];
    return data;
}


//

#pragma mark - setters

-(void)postPhoto:(UIImage *)image{
    NSLog(@"PostPhoto");
    NSString *result = [self postPhotoToServer:image];
    
    NSLog(@"List Info\n%@",result);
//    return result;
}
-(NSString *)saveImageWithUIImage:(UIImage *)image{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	// If you go to the folder below, you will find those pictures
//	NSLog(@"%@",docDir);
    
//	NSLog(@"saving jpeg");
	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/uploadImage.jpeg",docDir];
	NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5f)];//1.0f = 100% quality
	[data writeToFile:jpegFilePath atomically:YES];
//    NSLog(@"saving image done");    
    return jpegFilePath;
}

-(NSString *)postPhotoToServer:(UIImage *)image{
    NSLog(@"postPhotoToServer");
    
    if(nil==image){
        NSLog(@"Image == nil");
    }
    
    NSString *jpegFilePath = [self saveImageWithUIImage:image];
    //latitude and longitude
    CGFloat latitude =  37.64775;
	CGFloat longitude = -122.45247;
    
    NSString *store_name = [self getLocation:latitude Lng:longitude];
    NSLog(@"StoreName: %@", store_name);
//    [imageData writeToFile:@"uploadImage.jpeg" atomically:NO];
	// setting up the URL to post to
	NSString *urlString = @"http://talkloud.com/_sears/app.php";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

	[request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];

	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\nadd\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"latitude\"\r\n\r\n%f\r\n", latitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"longitude\"\r\n\r\n%f\r\n", longitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"store_name\"\r\n\r\n%@\r\n", store_name] dataUsingEncoding:NSUTF8StringEncoding]];
    
//    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"add"] dataUsingEncoding:NSUTF8StringEncoding]];

	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n", jpegFilePath] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:jpegFilePath];
//    NSLog(@"ImageData: %@", imageData);
    [body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    [request setURL:[NSURL URLWithString:urlString]];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
//	NSLog(@"Return: %@", returnString);
    return returnString;
}

#pragma mark - JSON Parsing

-(NSArray *)parseJSONtoArray:(NSData *)data{
//    __autoreleasing
//    NSError *error;
//    NSArray *ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

//    jsonString = [jsonString substringFromIndex:5];
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
- (NSDictionary *)getProductsWithKeyword:(NSString *)keyword{
    NSLog(@"getProductWithKeyword");
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.developer.sears.com/v2.1/products/search/Sears/json/keyword/%@?apikey=fMhZALfk7X96r8oas9AUr1l52tVyctyg", keyword];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data= [NSData dataWithContentsOfURL:url];
    
    NSDictionary *result = [self parseJSONtoDictionary:data];
    NSLog(@"%@", result);
    return result;
}
@end

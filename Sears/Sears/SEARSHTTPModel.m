//
//  SEARSHTTPModel.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSHTTPModel.h"
#import "NSDataAdditions.h"

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

#pragma mark - setters

-(void)postPhoto:(UIImage *)image{
    NSLog(@"PostPhoto");
    NSData *data = [self postPhotoToServer:image];
    NSArray *result = [self parseJSONtoArray:data];
    
    NSLog(@"List Info\n%@",result);
//    return result;
}

-(NSData *)postPhotoToServer:(UIImage *)image{
    NSLog(@"postPhotoToServer");
    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
     */
    if(nil==image){
        NSLog(@"Image == nil");
    }
//	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    
    // Let's save the file into Document folder.
	// You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
	// NSString *deskTopDir = @"/Users/kiichi/Desktop";
    
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	// If you go to the folder below, you will find those pictures
	NSLog(@"%@",docDir);
    
	NSLog(@"saving jpeg");
	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/uploadImage.jpeg",docDir];
	NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5f)];//1.0f = 100% quality
	[data writeToFile:jpegFilePath atomically:YES];
    
	NSLog(@"saving image done");
    
//    [imageData writeToFile:@"uploadImage.jpeg" atomically:NO];
	// setting up the URL to post to
	NSString *urlString = @"http://talkloud.com/_sears/app.php";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

	[request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];

	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\nadd\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
	
	NSLog(@"Return: %@", returnString);
    return nil;
//
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
//    NSString *imageString = [data base64Encoding];
//    NSString *urlString = [NSString stringWithFormat:@"http://talkloud.com/_sears/app.php?action=add&photo=%@", imageString];
////    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"URLString \n%@", urlString);
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSData *result= [NSData dataWithContentsOfURL:url];
//    NSLog(@"End:: postPhotoToServer");
//    return result;
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

@end

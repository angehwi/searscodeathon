//
//  SEARSAppDelegate.m
//  Sears
//
//  Created by Leonljy on 13. 8. 24..
//  Copyright (c) 2013년 SEARS. All rights reserved.
//

#import "SEARSAppDelegate.h"
#import "SEARSViewController.h"

#import <ApigeeiOSSDK/ApigeeClient.h>
#import <ApigeeiOSSDK/ApigeeDataClient.h>
#import <ApigeeiOSSDK/ApigeeClientResponse.h>


@implementation SEARSAppDelegate

ApigeeDataClient * usergridClient;

// The following values must be changed to the organization, application, and notifier
// to match the names that you've created on the App Services platform. Be sure that
// the application you use allows Guest access (eg. sandbox) - or that you have the device
// log in to App Services.
// Also ensure that you update the Bundle Identifier and Provisioning Profile in the project Build Settings.
// You will need to set the "Code Signing Identity" options for "Debug" to your Provisioning Profile.


NSString * orgName = @"kwanghwi";
NSString * appName = @"sandbox";
NSString * notifier = @"sears";

NSString * baseURL = @"https://api.usergrid.com";

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIStoryboard *iphoneStoryBoard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard"
                                                             bundle: nil];
    NSLog(@"Stroyboard: %@", iphoneStoryBoard);
    SEARSViewController *mainViewController = [iphoneStoryBoard instantiateViewControllerWithIdentifier:@"MAIN_VC"];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    
    self.window.rootViewController = self.navigationController;
    
    NSLog(@"setting up app services connection");
    // connect and login to App Services
    ApigeeClient *apigeeClient =
    [[ApigeeClient alloc] initWithOrganizationId:orgName
                                   applicationId:appName
                                         baseURL:baseURL];
    usergridClient = [apigeeClient dataClient];
    [usergridClient setLogging:true]; //comment out to remove debug output from the console window
    
    // it's not necessary to explicitly login to App Services if the Guest role allows access
    //    NSLog(@"logging in user");
    //    [usergridClient logInUser: userName password: password];
    
    // Register for Push Notifications with Apple
    NSLog(@"registering for remove notifications");
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    NSLog(@"done launching");
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // register device token with App Services (will create the Device entity if it doesn't exist)
    NSLog(@"registering token with app services");
    ApigeeClientResponse *response = [usergridClient setDevicePushToken: newDeviceToken forNotifier: notifier];
    
    // you could use this if you log in as an app services user to associate the Device to your User
    //    if (response.transactionState == kUGClientResponseSuccess) {
    //        response = [self connectEntities: @"users" connectorID: @"me" type: @"devices" connecteeID: deviceId];
    //    }
    
    if ( ! [response completedSuccessfully]) {
        [self alert: response.rawResponse title: @"Error"];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [self alert: error.localizedDescription title: @"Error"];
}

- (void)sendMyselfAPushNotification:(NSString *)message
{
    NSString *deviceId = [ApigeeDataClient getUniqueDeviceID];
    NSString *thisDevice = [@"devices/" stringByAppendingString: deviceId];
    
    ApigeeClientResponse *response = [usergridClient pushAlert: message
                                                     withSound: @"chime"
                                                            to: thisDevice
                                                 usingNotifier: notifier];
    if ( ! [response completedSuccessfully]) {
        [self alert: response.rawResponse title: @"Error"];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Received a push notification from the server
    // Only pop alert if applicationState is active (if not, the user already saw the alert)
    if (application.applicationState == UIApplicationStateActive)
    {
        NSString * message = [NSString stringWithFormat:@"Text:\n%@",
                              [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        [self alert: message title: @"Remote Notification"];
    }
}

- (void)alert:(NSString *)message title:(NSString *)title
{
    NSLog(@"displaying alert. title: %@, message: %@", title, message);
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle: title
                              message: message
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
    [alertView show];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Sears" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Sears.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

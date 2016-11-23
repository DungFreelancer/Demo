//
//  AppDelegate.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkHelper.h"
#import "Constant.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"
#import <Firebase.h>

@interface AppDelegate ()

@end

@implementation AppDelegate {
    int countSended;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Push notification.
    [FIRApp configure];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // Override point for customization after application launch.
    
    // Push offline data to service.
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
//        [NSTimer scheduledTimerWithTimeInterval:3600 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//            
//            reach.reachableBlock = ^(Reachability*reach)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    CheckInViewModel *ciViewModel = [[CheckInViewModel alloc] init];
//                    [ciViewModel loadCheckIns];
//                    for (CheckInModel *ci in ciViewModel.arrCheckIn) {
//                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//                        [params setObject:ci.store forKey:PARAM_NAME];
//                        [params setObject:ci.content forKey:PARAM_CONTENT];
//                        [params setObject:ci.sender forKey:PARAM_User];
//                        
//                        [[NetworkHelper sharedInstance] requestPost:API_CHECK_IN paramaters:params image:[UIImage imageWithData:ci.image] completion:nil];
//                    }
//                    [ciViewModel clearCheckIns];
//                });
//            };
//            
//            [reach startNotifier];
//        }];
//    } else {
        [[NetworkHelper sharedInstance] connectionChange:^(BOOL connected) {
            DLOG(@"%d", connected);
            CheckInViewModel *ciViewModel = [[CheckInViewModel alloc] init];
            
            if (connected && ciViewModel.arrCheckIn.count > 0) {
                
                countSended = 0;
                int numberOfUnsended = [ciViewModel numberOfUnsended];
                for (CheckInModel *ci in ciViewModel.arrCheckIn) {
                    if (ci.isSended == NO) {
                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                        [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
                        [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
                        [params setObject:ci.extension forKey:PARAM_EXTENSION];
                        
                        [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.window];
                        [[NetworkHelper sharedInstance] requestPost:API_UPLOAD_IMAGE paramaters:params image:[UIImage imageWithData:ci.image] completion:^(id response, NSError *error) {
                            
                            [[HUDHelper sharedInstance] hideLoading];
                            if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                                DLOG(@"%@", response);
                                [params setObject:[response valueForKey:RESPONSE_MESSAGE] forKey:PARAM_IMAGE];
                                [params setObject:ci.comment forKey:PARAM_COMMENT];
                                [params setObject:ci.date forKey:PARAM_DATE];
                                [params setObject:ci.latitude forKey:PARAM_LATITUDE];
                                [params setObject:ci.longtitude forKey:PARAM_LONGTITUDE];
                                
                                [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.window];
                                [[NetworkHelper sharedInstance] requestPost:API_CHECK_IN paramaters:params completion:^(id response, NSError *error) {
                                    
                                    [[HUDHelper sharedInstance] hideLoading];
                                    if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                                        DLOG(@"%@", response);
                                        ++countSended;
                                        ci.isSended = YES;
                                        [ciViewModel saveCheckIns];
                                        
                                        if(countSended == numberOfUnsended) {
                                            UINavigationController *nv =  (UINavigationController *)self.window.rootViewController;
                                            [[UtilityClass sharedInstance] showAlertOnViewController:nv.visibleViewController
                                                                                           withTitle:nil
                                                                                          andMessage:NSLocalizedString(@"CHECKIN_DONE_OFFLINE", nil)
                                                                                           andButton:NSLocalizedString(@"OK", nil)];
                                        }
                                    } else {
                                        ELOG(@"%@", response);
                                    }
                                }];
                            } else {
                                ELOG(@"%@", response);
                            }
                        }];
                    }
                }
            }
        }];
//    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DLOG(@"%@", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Demo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Directory Path Methods

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}

@end

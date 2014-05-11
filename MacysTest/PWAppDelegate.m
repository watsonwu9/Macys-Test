//
//  PWAppDelegate.m
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWAppDelegate.h"

@interface PWAppDelegate()

@property (nonatomic) NSString *databaseName;
@property (nonatomic) NSString *databasePath;

@end

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PWSQLiteManager sharedInstance] checkAndCreateDatabase];
    
    return YES;
}

/*
- (void)store:(UIImage *)image
{
    // store image link as the content of a new comment and store image as a file in the classic image storing folder
    
    Comment *comment = nil;
    comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    
    comment.commentId = [NSNumber numberWithInt:[AppStat nextItemId]];
    
    comment.content = [comment photoPath];
    
    NSDate *date = [NSDate date];
    comment.date = date;
    
    comment.isPhoto = [NSNumber numberWithBool:YES];
    self.itemToEdit.lastCommentAsPhotoId = comment.commentId;
    self.itemToEdit.updateDate = date;
    self.itemToEdit.organizeDateStr = [self.itemToEdit.updateDate getDateStringMonthCommaYear];
    
    [comment setValue:self.itemToEdit forKey:@"belongToPrayer"];
    
    // save the special "photo"-type comment into Core Data!
    [self saveToDB];
    
    // save the image to DocumentsDirectory (two copies, resized and original)
    
    UIImage *resizedImage;
    if (image.size.width >= 280) {
        resizedImage = [image resizedImage:CGSizeMake(280, 280 * image.size.height / image.size.width)];
    } else {
        resizedImage = [image resizedImage:CGSizeMake(image.size.width, image.size.height)];
    }
    
    NSData *resizedData = UIImagePNGRepresentation(resizedImage);
    NSError *error1;
    if (![resizedData writeToFile:[comment photoPath] options:NSDataWritingAtomic error:&error1]) {
        NSLog(@"Error saving resized photo: %@", error1);
    }
    
    // save the thumb image :) don't block the main thread...  :)
    UIImage *thumbImage = [[[resizedImage fixOrientation] squareCroppedImage] resizedImage:CGSizeMake(100, 100)];
    NSData *thumbData = UIImagePNGRepresentation(thumbImage);
    NSError *error2;
    if (![thumbData writeToFile:[comment thumbPhotoPath] options:NSDataWritingAtomic error:&error2]) {
        NSLog(@"Error saving thumb photo: %@", error2);
    }
    
    // make the storage of original image asynchronous!
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        // this original one can be large, should be processed asynchronously...
        NSData *originalData = UIImagePNGRepresentation([image fixOrientation]);
        // fix the orientation of UIImage before saving   :)
        // works like charm!
        
        NSError *error3;
        if (![originalData writeToFile:[comment originalPhotoPath] options:NSDataWritingAtomic error:&error3]) {
            NSLog(@"Error saving original photo: %@", error3);
        }
        
    });
    
}
 
 */

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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

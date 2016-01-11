//
//  CLChatCoreDataManager.m
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatCoreDataManager.h"
#import "CLChatMessage.h"

#define TableName @"CLChatMessage"

static CLChatCoreDataManager *shareCoreDataManager=nil;

@implementation CLChatCoreDataManager

+ (CLChatCoreDataManager *)shareCoreDataManager
{
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce, ^{
        shareCoreDataManager = [[CLChatCoreDataManager alloc] init];
    });
    return shareCoreDataManager;
}

//插入数据
- (void)insertCoreData:(CLMessage *)msg
{
    if (!msg || msg.msgIdentifier.length < 1) {
        return;
    }
    CLChatMessage *chatMsg = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:self.managedObjectContext];
    chatMsg.msgIdentifier = msg.msgIdentifier;
    chatMsg.userID = msg.from.userID;
    chatMsg.userName = msg.from.username;
    chatMsg.userAvatarURL = msg.from.avatarURL;
    chatMsg.msgDate = msg.date.timeIntervalSince1970;
    chatMsg.msgType = msg.messageType;
    chatMsg.msgOwnerType = msg.ownerTyper;
    chatMsg.readState = msg.readState;
    chatMsg.sendState = msg.sendState;
    chatMsg.text = msg.text;
    chatMsg.imagePath = msg.imagePath;
    chatMsg.webImageUrl = msg.imageURL;
    chatMsg.webImageWidth = msg.webImageSize.width;
    chatMsg.webImageHeight = msg.webImageSize.height;
    chatMsg.voiceSeconds = msg.voiceSeconds;
    chatMsg.voiceUrl = msg.voiceUrl;
    chatMsg.voicePath = msg.voicePath;
    chatMsg.customIdentifier = msg.customIdentifier;
    chatMsg.otherStr = msg.otherStr;
        
    [self saveContext];
}

//查询
- (NSMutableArray*)fetchDataByUserId:(NSString *)msgIdentifier
{
    if (msgIdentifier.length < 1) {
        return nil;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"msgIdentifier like[cd] %@",msgIdentifier];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (CLChatMessage *info in fetchedObjects) {
        CLMessage *msg = [[CLMessage alloc] init];
        CLUser *user = [[CLUser alloc] init];
        user.userID = info.userID;
        user.username = info.userName;
        user.avatarURL = info.userAvatarURL;
        msg.from = user;
        msg.msgIdentifier = info.msgIdentifier;
        msg.date = [NSDate dateWithTimeIntervalSince1970:info.msgDate];
        msg.messageType = info.msgType;
        msg.ownerTyper = info.msgOwnerType;
        msg.readState = info.readState;
        msg.sendState = info.sendState;
        msg.text = info.text;
        msg.imagePath = info.imagePath;
        msg.imageURL = info.webImageUrl;
        msg.webImageSize = CGSizeMake(info.webImageWidth, info.webImageHeight);
        msg.voiceSeconds = info.voiceSeconds;
        msg.voiceUrl = info.voiceUrl;
        msg.voicePath = info.voicePath;
        msg.customIdentifier = info.customIdentifier;
        msg.otherStr = info.otherStr;
        
        [resultArray addObject:msg];
    }
    return resultArray;
}

//删除全部
-(void)deleteAllData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

//通过msgIdentifier删除
-(void)deleteDataByUserId:(NSString *)msgIdentifier
{
    if (msgIdentifier.length < 1) {
        return;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"msgIdentifier like[cd] %@",msgIdentifier];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

//更新
- (void)updateDataByUserId:(NSString *)msgIdentifier index:(NSUInteger)index message:(CLMessage *)msg
{
    if (msgIdentifier.length < 1 || !msg) {
        return;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"msgIdentifier like[cd] %@",msgIdentifier];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (result.count > index) {
        CLChatMessage *chatMsg = result[index];
        chatMsg.msgIdentifier = msg.msgIdentifier;
        chatMsg.userID = msg.from.userID;
        chatMsg.userName = msg.from.username;
        chatMsg.userAvatarURL = msg.from.avatarURL;
        chatMsg.msgDate = msg.date.timeIntervalSince1970;
        chatMsg.msgType = msg.messageType;
        chatMsg.msgOwnerType = msg.ownerTyper;
        chatMsg.readState = msg.readState;
        chatMsg.sendState = msg.sendState;
        chatMsg.text = msg.text;
        chatMsg.imagePath = msg.imagePath;
        chatMsg.webImageUrl = msg.imageURL;
        chatMsg.webImageWidth = msg.webImageSize.width;
        chatMsg.webImageHeight = msg.webImageSize.height;
        chatMsg.voiceSeconds = msg.voiceSeconds;
        chatMsg.voiceUrl = msg.voiceUrl;
        chatMsg.voicePath = msg.voicePath;
        chatMsg.customIdentifier = msg.customIdentifier;
        chatMsg.otherStr = msg.otherStr;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.clark.CLChatModel" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CLChatModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CLChatModel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

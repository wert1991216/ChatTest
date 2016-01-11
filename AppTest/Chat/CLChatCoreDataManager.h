//
//  CLChatCoreDataManager.h
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CLMessage.h"

@interface CLChatCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (CLChatCoreDataManager *)shareCoreDataManager;

//插入数据
- (void)insertCoreData:(CLMessage *)msg;
//查询
- (NSMutableArray*)fetchDataByUserId:(NSString *)msgIdentifier;
//删除全部
-(void)deleteAllData;
//通过msgIdentifier删除
-(void)deleteDataByUserId:(NSString *)msgIdentifier;
//更新
- (void)updateDataByUserId:(NSString *)msgIdentifier index:(NSUInteger)index message:(CLMessage *)msg;

@end

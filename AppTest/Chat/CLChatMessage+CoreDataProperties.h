//
//  CLChatMessage+CoreDataProperties.h
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CLChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLChatMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userID;
@property (nonatomic) NSTimeInterval msgDate;
@property (nonatomic) int16_t msgType;
@property (nonatomic) int16_t msgOwnerType;
@property (nonatomic) int16_t readState;
@property (nonatomic) int16_t sendState;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSString *webImageUrl;
@property (nonatomic) float webImageWidth;
@property (nonatomic) float webImageHeight;
@property (nonatomic) int16_t voiceSeconds;
@property (nullable, nonatomic, retain) NSString *voiceUrl;
@property (nullable, nonatomic, retain) NSString *voicePath;
@property (nullable, nonatomic, retain) NSString *customIdentifier;
@property (nullable, nonatomic, retain) NSString *otherStr;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *userAvatarURL;
@property (nullable, nonatomic, retain) NSString *msgIdentifier;

@end

NS_ASSUME_NONNULL_END

//
//  CLChatMessage+CoreDataProperties.m
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CLChatMessage+CoreDataProperties.h"

@implementation CLChatMessage (CoreDataProperties)

@dynamic userID;
@dynamic msgDate;
@dynamic msgType;
@dynamic msgOwnerType;
@dynamic readState;
@dynamic sendState;
@dynamic text;
@dynamic imagePath;
@dynamic webImageUrl;
@dynamic webImageWidth;
@dynamic webImageHeight;
@dynamic voiceSeconds;
@dynamic voiceUrl;
@dynamic voicePath;
@dynamic customIdentifier;
@dynamic otherStr;
@dynamic userName;
@dynamic userAvatarURL;
@dynamic msgIdentifier;

@end

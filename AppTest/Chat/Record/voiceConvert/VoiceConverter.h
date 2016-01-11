//
//  VoiceConverter.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VoiceConverter : NSObject

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath;

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath;
+ (int) changeStu;
+(void)mixMusic:(NSString*)wavPath1 andPath:(NSString*)wavePath2 toPath:(NSString *)outpath;
+(void)mixAmr:(NSString *)amrPath1 andPath:(NSString *)amrPath2;
@end

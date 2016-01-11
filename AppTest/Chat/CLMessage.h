//
//  CLMessage.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CLUser.h"

/**
 *  消息拥有者
 */
typedef NS_ENUM(NSUInteger, CLMessageOwnerType){
    CLMessageOwnerTypeUnknown,  // 未知的消息拥有者
    CLMessageOwnerTypeSystem,   // 系统消息(时间)
    CLMessageOwnerTypeSelf,     // 自己发送的消息
    CLMessageOwnerTypeOther,    // 接收到的他人消息
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, CLMessageType){
    CLMessageTypeUnknown,       // 未知
    CLMessageTypeSystem,        // 系统
    CLMessageTypeText,          // 文字
    CLMessageTypeImage,         // 图片
    CLMessageTypeVoice,         // 语音
    CLMessageTypeVideo,         // 视频
    CLMessageTypeFile,          // 文件
    CLMessageTypeLocation,      // 位置
    CLMessageTypeShake,         // 抖动
    CLMessageTypeCustom,        // 自定义视图
};

/**
 *  消息发送状态
 */
typedef NS_ENUM(NSUInteger, CLMessageSendState){
    CLMessageSendSuccess,       // 消息发送成功
    CLMessageSendFail,          // 消息发送失败
};

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSUInteger, CLMessageReadState) {
    CLMessageUnRead,            // 消息未读
    CLMessageReaded,            // 消息已读
};

@interface CLMessage : NSObject

@property (nonatomic, strong) NSString *msgIdentifier;              //传otherUser的UserId,必须传
@property (nonatomic, strong) CLUser *from;                         // 发送者信息
@property (nonatomic, strong) NSDate *date;                         // 发送时间
@property (nonatomic, strong) NSString *dateString;                 // 格式化的发送时间
@property (nonatomic, assign) CLMessageType messageType;            // 消息类型
@property (nonatomic, assign) CLMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) CLMessageReadState readState;         // 读取状态
@property (nonatomic, assign) CLMessageSendState sendState;         // 发送状态

@property (nonatomic, assign) CGSize messageSize;                   // 消息大小
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSString *cellIndentify;

#pragma mark - 文字消息
@property (nonatomic, strong) NSString *text;                       // 文字信息
@property (nonatomic, strong) NSAttributedString *attrText;         // 格式化的文字信息

#pragma mark - 图片消息
@property (nonatomic, strong) NSString *imagePath;                  // 本地图片Path
@property (nonatomic, strong) UIImage *image;                       // 图片缓存
@property (nonatomic, strong) NSString *imageURL;                   // 网络图片URL
@property (nonatomic, assign) CGSize webImageSize;//网络图片大小

#pragma mark - 位置消息
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;    // 经纬度
@property (nonatomic, strong) NSString *address;                    // 地址

#pragma mark - 语音消息
@property (nonatomic, assign) NSUInteger voiceSeconds;              // 语音时间
@property (nonatomic, strong) NSString *voiceUrl;                   // 网络语音URL,为本人时存放amr本地路径，用于发送网络，为他人时，需下载并转换为wav存放到voicePath
@property (nonatomic, strong) NSString *voicePath;                  // 本地语音Path

#pragma mark - 系统消息（时间显示）
@property (nonatomic, strong) NSString *sysText;                    // 时间标签

#pragma mark - 自定义视图
@property (nonatomic, strong) NSString *customIdentifier;           //自定义视图标记，用于区不同自定义视图
@property (nonatomic, strong) NSString *otherStr;               //自定义视图参数，参数不足时可使用上面的同类型属性代替

@end

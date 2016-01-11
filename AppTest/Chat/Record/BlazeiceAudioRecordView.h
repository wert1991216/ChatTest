//
//  BlazeiceAudioRecordView.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlazeiceAudioRecordAndTransCoding.h"

@protocol audioRecordDelegate <NSObject>
-(void)recodeComplete:(NSString *)vedioPathString;
@end

@interface BlazeiceAudioRecordView : UIView<BlazeiceAudioRecordAndTransCodingDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>{}
@property (nonatomic,strong)id<audioRecordDelegate>delegate;

-(void)loadView;

-(void)beginToRecordAudio;

- (void)endRecord;
- (void)cancleRecord;
- (void)showCancelView;
- (void)showRecordView;

@end

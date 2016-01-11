//
//  BlazeiceAudioRecordView.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "BlazeiceAudioRecordView.h"
#import "BlazeicePublicMethod.h"
#import "macros.h"
#import "UIView+CL.h"
@interface BlazeiceAudioRecordView (){
    NSString *vedioPath;
    NSString *lastVedio;
    BlazeiceAudioRecordAndTransCoding *audioRecord;
    
    BOOL vedioing;//正在录音
    BOOL waitMixAmr;
    NSTimer *timer;
    
    BOOL isWantOut;
    
}

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *micImageView;
@property (nonatomic, strong) UIImageView *volumeImageView;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UIImageView *cancelImageView;
@property (nonatomic, strong) UIImageView *tooLongImageView;

@end

@implementation BlazeiceAudioRecordView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self loadView];
    }
    return self;
}

- (void)loadView {
    self.backView.frame = CGRectMake((self.frameWidth - 156)/2.0, (self.frameHeight - 160)/2.0, 156, 160);
    [self addSubview:self.backView];
    
    self.micImageView.frame = CGRectMake(40, 25, 35, 70);
    self.volumeImageView.frame = CGRectMake(self.backView.frameWidth - 40 - 12, 45, 12, 42);
    [self.backView addSubview:self.micImageView];
    [self.backView addSubview:self.volumeImageView];
    
    self.markLabel.frame = CGRectMake((self.backView.frameWidth - 126)/2.0, self.backView.frameHeight - 15 - 30, 126, 30);
    [self.backView addSubview:self.markLabel];
    
    self.cancelImageView.frame = CGRectMake((self.backView.frameWidth - 70)/2.0, 25, 70, 70);
    [self.backView addSubview:self.cancelImageView];
    
    self.tooLongImageView.frame = CGRectMake((self.frameWidth - 120)/2.0, (self.frameHeight - 120)/2.0, 120, 120);
    [self addSubview:self.tooLongImageView];
}

- (void)endRecord {
    [self endToRecordAudio];
    [self recordComplete];
}

- (void)showCancelView {
    self.micImageView.hidden = YES;
    self.volumeImageView.hidden = YES;
    self.cancelImageView.hidden = NO;
    self.markLabel.backgroundColor = [UIColor redColor];
}

- (void)showRecordView {
    self.micImageView.hidden = NO;
    self.volumeImageView.hidden = NO;
    self.cancelImageView.hidden = YES;
    self.markLabel.backgroundColor = [UIColor clearColor];
}

// 用户录制中途取消录音处理
- (void)cancleRecord {
    [audioRecord endRecord];
    if (lastVedio) {
        NSString *lastAmr=[BlazeicePublicMethod getPathByFileName:[lastVedio stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
        [self deleteVedioNamed:lastAmr];
        NSString *lastWav=[BlazeicePublicMethod getPathByFileName:lastVedio ofType:@"wav"];
        [self deleteVedioNamed:lastWav];
        lastVedio = nil;
    }
    if (vedioPath) {
        NSString *vedioAmr=[BlazeicePublicMethod getPathByFileName:[vedioPath stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
        [self deleteVedioNamed:vedioAmr];
        NSString *vedioWav=[BlazeicePublicMethod getPathByFileName:vedioPath ofType:@"wav"];
        [self deleteVedioNamed:vedioWav];
        lastVedio = nil;
    }
    [self recordComplete];
}

//录音结束，返回最终音频地址
- (void)recordComplete {
    if (self.delegate) {
        if (lastVedio) {
            int length=[BlazeicePublicMethod getVedioLength:lastVedio];
            if (length > 60) {
                [self deleteVedioNamed:lastVedio];
                lastVedio = nil;
                self.tooLongImageView.hidden = NO;
                self.backView.hidden = YES;
            }
        }
        [audioRecord endRecord];
        audioRecord.delegate = nil;
        audioRecord = nil;
        [self.delegate recodeComplete:lastVedio];
        
    }
    [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.5];
}

- (void)removeSelf {
    [self removeFromSuperview];
}

//混合音频
- (void)mixAmr {
    NSString *newName=[NSString stringWithFormat:@"%@_new",vedioPath];
    //两个amr的位置
    NSString *vedioAmr=[BlazeicePublicMethod getPathByFileName:[vedioPath stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
    NSString *lastAmr=[BlazeicePublicMethod getPathByFileName:[lastVedio stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
    
    [audioRecord mixAmr:lastAmr andPath:vedioAmr];
    NSString *newPath=[BlazeicePublicMethod getPathByFileName:[newName stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
    [[NSFileManager defaultManager] copyItemAtPath:lastAmr toPath:newPath error:nil];
    //将拼接的两个录音的音频和转码后amr文件都删除
    [self deleteVedioNamed:lastVedio];
    [self deleteVedioNamed:vedioPath];
    lastVedio = newName;
    waitMixAmr = NO;
}

//删除音频
- (void)deleteVedioNamed:(NSString *)name {
    NSString *pathString=[BlazeicePublicMethod getPathByFileName:name ofType:@"wav"];
    NSString *vedioAmr=[BlazeicePublicMethod getPathByFileName:[name stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
    [BlazeicePublicMethod deleteFileAtPath:pathString];
    [BlazeicePublicMethod deleteFileAtPath:vedioAmr];
}

- (void)beginToRecordAudio {
    vedioing = YES;
    
    vedioPath= [NSString stringWithFormat:@"%@",[BlazeicePublicMethod getCurrentTimeString]];
    if (!audioRecord) {
        audioRecord = [[BlazeiceAudioRecordAndTransCoding alloc]init];
        audioRecord.recorder.delegate=self;
        audioRecord.delegate = self;
    }
    [audioRecord beginRecordByFileName:vedioPath];
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(levelTimerCallBack) userInfo:nil repeats:YES];
}

- (void)endToRecordAudio {
    if (vedioing) {
        vedioing = NO;
        if (timer) {
            [timer invalidate];
        }
        
        //UIView *bg = (UIView *)[self viewWithTag:10086];
        //[bg removeFromSuperview];
        
        if (audioRecord&&[audioRecord.recorder isRecording]) {
            [audioRecord endRecord];
        }
        if (vedioPath.length>0) {
            // 显示语音长度
            int length=[BlazeicePublicMethod getVedioLength:vedioPath];
            if (length<1) {
                //                [self deleteVedioNamed:vedioPath];
                vedioPath=nil;
                lastVedio=nil;
                return;
            }else{
                lastVedio = vedioPath;
//                if (lastVedio.length == 0) {
//                    lastVedio = vedioPath;
//                }else{
//                    if (![lastVedio isEqualToString:vedioPath]) {
//                        int length = [BlazeicePublicMethod getVedioLength:vedioPath];
//                        if (length!=0) {
//                            waitMixAmr = YES;
//                            NSString *lastString = [BlazeicePublicMethod getPathByFileName:lastVedio ofType:@"wav"];
//                            NSString *pathString = [BlazeicePublicMethod getPathByFileName:vedioPath ofType:@"wav"];
//                            NSString *newName = [NSString stringWithFormat:@"%@_new",vedioPath];
//                            [audioRecord mixAudio:pathString andPath:lastString toPath:[BlazeicePublicMethod getPathByFileName:newName ofType:@"wav"]];
//                        }
//                    }
//                }
            }
        }
    }
}

// 通过音量更新录制界面
- (void)levelTimerCallBack {
    if (vedioing) {
        [audioRecord.recorder updateMeters];
        double lowPassResults = pow(10, (0.05 * [audioRecord.recorder peakPowerForChannel:0]));
        NSLog(@"%lf",lowPassResults);
        //最大50  0
        //图片 小-》大
        if (0<lowPassResults<=0.06) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal001"]];
        }else if (0.06<lowPassResults<=0.13) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal002"]];
        }else if (0.13<lowPassResults<=0.20) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal003"]];
        }else if (0.20<lowPassResults<=0.27) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal004"]];
        }else if (0.27<lowPassResults<=0.34) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal005"]];
        }else if (0.34<lowPassResults<=0.41) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal006"]];
        }else if (0.41<lowPassResults<=0.48) {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal007"]];
        }else {
            [self.volumeImageView setImage:[UIImage imageNamed:@"RecordingSignal008"]];
        }
    }
}

- (void)wavToAmrComplete {
    if (waitMixAmr && lastVedio) {
        [self mixAmr];
    }else{
        
    }
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.layer.cornerRadius = 4;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)micImageView {
    if (_micImageView == nil) {
        _micImageView = [[UIImageView alloc] init];
        _micImageView.image = [UIImage imageNamed:@"RecordingBkg"];//50*100
    }
    return _micImageView;
}

- (UIImageView *)volumeImageView {
    if (_volumeImageView == nil) {
        _volumeImageView = [[UIImageView alloc] init];//18*60
    }
    return _volumeImageView;
}

- (UIImageView *)cancelImageView {
    if (_cancelImageView == nil) {
        _cancelImageView = [[UIImageView alloc] init];
        _cancelImageView.image = [UIImage imageNamed:@"RecordCancel"];//100*100
        _cancelImageView.hidden = YES;
    }
    return _cancelImageView;
}

- (UIImageView *)tooLongImageView {
    if (_tooLongImageView == nil) {
        _tooLongImageView = [[UIImageView alloc] init];
        _tooLongImageView.image = [UIImage imageNamed:@"Record_overlong"];//90*90
        _tooLongImageView.hidden = YES;
    }
    return _tooLongImageView;
}

- (UILabel *)markLabel {
    if (_markLabel == nil) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.text = @"手指上滑,取消发送";
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.font = [UIFont boldSystemFontOfSize:14];
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.backgroundColor = [UIColor clearColor];
        _markLabel.layer.cornerRadius = 3;
        _markLabel.layer.masksToBounds = YES;
    }
    return _markLabel;
}

@end

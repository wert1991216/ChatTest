//
//  CLChatBoxViewController.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatBoxViewController.h"
#import "CLChatBox.h"
#import "CLChatBoxMoreView.h"
#import "CLChatBoxFaceView.h"
#import "macros.h"
#import "UIView+CL.h"
#import "UIImage+CL.h"

@interface CLChatBoxViewController () <CLChatBoxDelegate, CLChatBoxFaceViewDelegate, CLChatBoxMoreViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;

@property (nonatomic, strong) CLChatBox *chatBox;
@property (nonatomic, strong) CLChatBoxMoreView *chatBoxMoreView;
@property (nonatomic, strong) CLChatBoxFaceView *chatBoxFaceView;

@end

@implementation CLChatBoxViewController

#pragma mark - LifeCycle
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.chatBox];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resignFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Public Methods
- (BOOL) resignFirstResponder
{
    if (self.chatBox.status != CLChatBoxStatusNothing && self.chatBox.status != CLChatBoxStatusShowVoice) {
        [self.chatBox resignFirstResponder];
        self.chatBox.status = (self.chatBox.status == CLChatBoxStatusShowVoice ? self.chatBox.status : CLChatBoxStatusNothing);
        if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
            }];
        }
    }
    return [super resignFirstResponder];
}

- (void)addMoreItems:(NSArray<CLChatBoxMoreItem *> *)items {
    NSMutableArray *moreItems = [[NSMutableArray alloc] init];
    [moreItems addObjectsFromArray:self.chatBoxMoreView.items];
    [moreItems addObjectsFromArray:items];
    [self.chatBoxMoreView setItems:moreItems];
}

#pragma mark - CLChatBoxDelegate
- (void) chatBox:(CLChatBox *)chatBox sendTextMessage:(NSString *)textMessage
{
    CLMessage *message = [[CLMessage alloc] init];
    message.messageType = CLMessageTypeText;
    message.ownerTyper = CLMessageOwnerTypeSelf;
    message.text = textMessage;
    message.date = [NSDate date];
    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController: sendMessage:)]) {
        [_insideDelegate chatBoxViewController:self sendMessage:message];
    }
}

- (void)chatBox:(CLChatBox *)chatBox changeChatBoxHeight:(CGFloat)height
{
    self.chatBoxFaceView.originY = height;
    self.chatBoxMoreView.originY = height;
    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        float h = (self.chatBox.status == CLChatBoxStatusShowFace ? HEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height ) + height;
        [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight: h];
    }
}

- (void) chatBox:(CLChatBox *)chatBox changeStatusForm:(CLChatBoxStatus)fromStatus to:(CLChatBoxStatus)toStatus
{
    if (toStatus == CLChatBoxStatusShowKeyboard) {      // 显示键盘
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatBoxFaceView removeFromSuperview];
            [self.chatBoxMoreView removeFromSuperview];
        });
        return;
    }
    else if (toStatus == CLChatBoxStatusShowVoice) {    // 显示语音输入按钮
        // 从显示更多或表情状态 到 显示语音状态需要动画
        if (fromStatus == CLChatBoxStatusShowMore || fromStatus == CLChatBoxStatusShowFace) {
            [UIView animateWithDuration:0.3 animations:^{
                if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                }
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
            }];
        }
        else {
            [UIView animateWithDuration:0.1 animations:^{
                if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                }
            }];
        }
    }
    else if (toStatus == CLChatBoxStatusShowFace) {     // 显示表情面板
        if (fromStatus == CLChatBoxStatusShowVoice || fromStatus == CLChatBoxStatusNothing) {
            [self.chatBoxFaceView setOriginY:self.chatBox.curHeight];
            [self.view addSubview:self.chatBoxFaceView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                }
            }];
        }
        else {
            // 表情高度变化
            self.chatBoxFaceView.originY = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.chatBoxFaceView];
            [UIView animateWithDuration:0.3 animations:^{
                self.chatBoxFaceView.originY = self.chatBox.curHeight;
            } completion:^(BOOL finished) {
                [self.chatBoxMoreView removeFromSuperview];
            }];
            // 整个界面高度变化
            if (fromStatus != CLChatBoxStatusShowMore) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
        }
    }
    else if (toStatus == CLChatBoxStatusShowMore) {     // 显示更多面板
        if (fromStatus == CLChatBoxStatusShowVoice || fromStatus == CLChatBoxStatusNothing) {
            [self.chatBoxMoreView setOriginY:self.chatBox.curHeight];
            [self.view addSubview:self.chatBoxMoreView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                }
            }];
        }
        else {
            self.chatBoxMoreView.originY = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.chatBoxMoreView];
            [UIView animateWithDuration:0.3 animations:^{
                self.chatBoxMoreView.originY = self.chatBox.curHeight;
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
            }];
            
            if (fromStatus != CLChatBoxStatusShowFace) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
        }
    }
}

#pragma mark - CLChatBoxFaceViewDelegate
- (void) chatBoxFaceViewDidSelectedFace:(CLFace *)face type:(CLFaceType)type
{
    if (type == CLFaceTypeEmoji) {
        [self.chatBox addEmojiFace:face];
    }
}

- (void) chatBoxFaceViewDeleteButtonDown
{
    [self.chatBox deleteButtonDown];
}

- (void) chatBoxFaceViewSendButtonDown
{
    [self.chatBox sendCurrentMessage];
}

#pragma mark - CLChatBoxMoreViewDelegate
- (void) chatBoxMoreView:(CLChatBoxMoreView *)chatBoxMoreView didSelectItem:(CLChatBoxItem)itemType
{
    if (itemType == CLChatBoxItemAlbum) {            // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.navigationBar.barTintColor = DEFAULT_NAVBAR_COLOR;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
    else if (itemType == CLChatBoxItemCamera) {       // 拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];//初始化
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker setDelegate:self];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前设备不支持拍照。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"Did Selected Index Of ChatBoxMoreView: %d", (int)itemType] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxMoreViewItem:index:)] && chatBoxMoreView.items.count > (int)itemType) {
        CLChatBoxMoreItem *moreItem = chatBoxMoreView.items[(int)itemType];
        [_delegate chatBoxMoreViewItem:moreItem index:(int)itemType];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(600, 600*image.size.height/image.size.width)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imageName = [NSString stringWithFormat:@"%lf", [[NSDate date]timeIntervalSince1970]];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", PATH_CHATREC_IMAGE, imageName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:PATH_CHATREC_IMAGE]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:PATH_CHATREC_IMAGE withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSData *imageData = (UIImagePNGRepresentation(image) == nil ? UIImageJPEGRepresentation(image, 1) : UIImagePNGRepresentation(image));
        [imageData writeToFile:imagePath atomically:YES];
        
        CLMessage *message = [[CLMessage alloc] init];
        message.messageType = CLMessageTypeImage;
        message.ownerTyper = CLMessageOwnerTypeSelf;
        message.date = [NSDate date];
        message.imagePath = imageName;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:sendMessage:)]) {
                [_insideDelegate chatBoxViewController:self sendMessage:message];
            }
        });
    });
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - Private Methods
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    if (_chatBox.status == CLChatBoxStatusShowFace || _chatBox.status == CLChatBoxStatusShowMore) {
        return;
    }
    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_chatBox.status == CLChatBoxStatusShowKeyboard && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        return;
    }
    else if ((_chatBox.status == CLChatBoxStatusShowFace || _chatBox.status == CLChatBoxStatusShowMore) && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        return;
    }
    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        [_insideDelegate chatBoxViewController:self didChangeChatBoxHeight: self.keyboardFrame.size.height + self.chatBox.curHeight];
    }
}

#pragma mark - Getter
- (CLChatBox *) chatBox
{
    if (_chatBox == nil) {
        _chatBox = [[CLChatBox alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_TABBAR)];
        [_chatBox setDelegate:self];
    }
    return _chatBox;
}

- (CLChatBoxMoreView *) chatBoxMoreView
{
    if (_chatBoxMoreView == nil) {
        _chatBoxMoreView = [[CLChatBoxMoreView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_CHATBOXVIEW)];
        [_chatBoxMoreView setDelegate:self];
        
        CLChatBoxMoreItem *photosItem = [CLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"照片"
                                                                                imageName:@"sharemore_pic"];
        CLChatBoxMoreItem *takePictureItem = [CLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"拍摄"
                                                                                     imageName:@"sharemore_video"];
        
        [_chatBoxMoreView setItems:[[NSMutableArray alloc] initWithObjects:photosItem, takePictureItem, nil]];
    }
    return _chatBoxMoreView;
}

- (CLChatBoxFaceView *) chatBoxFaceView
{
    if (_chatBoxFaceView == nil) {
        _chatBoxFaceView = [[CLChatBoxFaceView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_CHATBOXVIEW)];
        [_chatBoxFaceView setDelegate:self];
    }
    return _chatBoxFaceView;
}

@end

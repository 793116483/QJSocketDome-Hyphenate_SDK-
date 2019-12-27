//
//  QJImageChatModel.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/10.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJImageChatModel.h"

@implementation QJImageChatModel
-(void)setImage:(UIImage *)image{
    _image = image ;
    
    NSString * name = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970] * 1000];
    EMImageMessageBody * body = [[EMImageMessageBody alloc] initWithData:UIImagePNGRepresentation(image) displayName:name];
    
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
    NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)]];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
    body.thumbnailLocalPath = imageFilePath ;
    
    self.message.body = body ;
}

-(void)setMessage:(EMMessage *)message {
    [super setMessage:message];
    
    EMImageMessageBody * body = (EMImageMessageBody *)message.body ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:body.thumbnailLocalPath]) {
        _image = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath] ;
    } else {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:body.thumbnailRemotePath]];
        _image = [UIImage imageWithData:data];
        [UIImageJPEGRepresentation(_image, 0.5) writeToFile:body.thumbnailLocalPath  atomically:YES];
    }
}
@end

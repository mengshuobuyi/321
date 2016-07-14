

#import "QWJSAudioExt.h"
 #import <AVFoundation/AVFoundation.h>
 #import "QWWebViewController.h"

#import "HttpClient.h"
#define UNKNOWN_ERROR 1
#define NO_FILE_ERROR 2
#define PLAY_FAIL_ERROR 3
#define PAUSE_FAIL_ERROR 4
#define RESUME_FAIL_ERROR 5
#define STOP_FAIL_ERROR 6
#define GET_VOLUME_FAIL_ERROR 7
#define SET_VOLUME_FAIL_ERROR 8

@implementation QWJSAudioExt
@synthesize jsCallbackId_;
 

- (void)load:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>2) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *src = [arguments objectAtIndex:1];
        NSString *audioId = [arguments objectAtIndex:2];
     __block   NSURL *url = nil;
        NSError *error = nil;
   __block     BOOL needRemoveFile = NO;
        if ([src hasPrefix:@"/"]) {
            
            // initWithContentsOfURL 这个方法不能加载远程文件
            NSString *serverURL = BASE_URL_V2;
            
            [HttpClientMgr get:[NSString stringWithFormat:@"%@%@", serverURL, src] params:nil success:^(id responseObj) {
                NSData *audioData = responseObj;
                /*
                 //将音频数据写入文件，通过initWithContentsOfURL读取文件
                 //这里不采用initWithData，由于initWithData方法对数据要求比较严格。
                 */
                NSString *docPath = [NSTemporaryDirectory() stringByStandardizingPath];
                NSString *name = [src lastPathComponent];
                NSString *path = [docPath stringByAppendingPathComponent:name];
                
                BOOL success = [audioData writeToFile:path atomically:YES];
                if (success) {
                    needRemoveFile = YES;
                    url = [NSURL fileURLWithPath:path];
                }
            } failure:^(HttpException *e) {
                
            }];
         

        } else {
            
            NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [arrayPaths objectAtIndex:0];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            /*
             先检测插件包，然后离线资源包，write接口写的文件包，最后安装包
             */
            BOOL needCheckSHA1 = NO;
            NSString *resourcePath = [docDir stringByAppendingPathComponent:PLUG_IN_RESOURCES];
            NSString *path = [resourcePath stringByAppendingPathComponent:src];
            NSString *finalPath = nil;
            if ([fileManager fileExistsAtPath:path]) {
                needCheckSHA1 = YES;
                finalPath = path;
            }
            if (finalPath == nil) {
                resourcePath = [docDir stringByAppendingPathComponent:OFFLINE_RESOURCES];
                path = [resourcePath stringByAppendingPathComponent:src];
                if ([fileManager fileExistsAtPath:path]) {
                    needCheckSHA1 = YES;
                    finalPath = path;
                }
            }
            if (finalPath == nil) {
                resourcePath = [docDir stringByAppendingPathComponent:WRITE_RESOURCES];
                path = [resourcePath stringByAppendingPathComponent:src];
                if ([fileManager fileExistsAtPath:path]) {
                    needCheckSHA1 = YES;
                    finalPath = path;
                }
            }
            if (finalPath == nil) {
                path = [[NSBundle mainBundle] pathForResource:src ofType:nil];
                if ([fileManager fileExistsAtPath:path]) {
                    needCheckSHA1 = NO;
                    finalPath = path;
                }
            }
            
            
            if (finalPath) {
                NSData *data = [NSData dataWithContentsOfFile:finalPath];
                if (data) {
                    if (needCheckSHA1) {
                      
                    }
                    url = [NSURL fileURLWithPath:finalPath];
                }
            }
            
        }
        if (url) {
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (error) {
                [self writeScript:self.jsCallbackId_ messageString:error.description state:NO_FILE_ERROR keepCallback:NO];
            }
            if (soundCache == nil) {
                soundCache = [[NSMutableDictionary alloc] initWithCapacity:0];
            }
            if (player) {
                [soundCache setObject:player forKey:audioId];
                [(QWWebViewController *)(self.webView.delegate) addObserver:self forKeyPath:@"audioCache" options:0 context:(void *)player];

                [(QWWebViewController *)(self.webView.delegate) addAudioRef:player];

            }
     
            
            //音频文件加载结束，删除文件
            if (needRemoveFile) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *tempPath = url.path;
                if ([fileManager fileExistsAtPath:tempPath]) {
                    [fileManager removeItemAtPath:tempPath error:&error];
                }
            }
 
        }else{
            [self writeScript:self.jsCallbackId_ messageString:@"no file" state:NO_FILE_ERROR keepCallback:NO];
            
        }
    }
}



- (void)dispose:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        if (player) {
            [player stop];
            [soundCache removeObjectForKey:audioId];
            [(QWWebViewController *)(self.webView.delegate) removeAudioRef:player];
            [self writeScript:self.jsCallbackId_ messageString:@"player has been dispose success" state:0 keepCallback:NO];
        }else{
            [self writeScript:self.jsCallbackId_ messageString:@"no found player pointer" state:UNKNOWN_ERROR keepCallback:NO];
        }
    }
}
- (void)play:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>2) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        int number = [(NSNumber *)[arguments objectAtIndex:2] intValue];
        if (player) {
            if (number >= 1) {
                number = number -1;
            }
            player.numberOfLoops = number;
            BOOL success = [player play];
            if (success) {
                [self writeScript:self.jsCallbackId_ messageString:@"play success" state:0 keepCallback:NO];
                return;
            }
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"play fail" state:UNKNOWN_ERROR keepCallback:NO];

}
- (void)stop:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        if (player) {
            [player stop];
            [self writeScript:self.jsCallbackId_ messageString:@"stop success" state:0 keepCallback:NO];
            return;
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"stop fail" state:UNKNOWN_ERROR keepCallback:NO];

}
- (void)pause:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        if (player) {
            [player pause];
            [self writeScript:self.jsCallbackId_ messageString:@"pause success" state:0 keepCallback:NO];
            return;
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"pause fail" state:UNKNOWN_ERROR keepCallback:NO];

}
- (void)resume:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        if (player) {
            BOOL success = [player play];
            if (success) {
                [self writeScript:self.jsCallbackId_ messageString:@"resume success" state:0 keepCallback:NO];
                return;
            }
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"resume fail" state:UNKNOWN_ERROR keepCallback:NO];
}
- (void)getMaxVolume:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *message = [NSString stringWithFormat:@"%f",1.0];
        [self writeScript:self.jsCallbackId_ message:message state:0 keepCallback:NO];
    }
}
- (void)getMinVolume:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *message = [NSString stringWithFormat:@"%f",0.0];
        [self writeScript:self.jsCallbackId_ message:message state:0 keepCallback:NO];
    }
}
- (void)getVolume:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        float volume = player.volume;
        NSString *message = [NSString stringWithFormat:@"%f",volume];
        [self writeScript:self.jsCallbackId_ messageString:message state:0 keepCallback:NO];
    }
}
- (void)setVolume:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>2) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *audioId = [arguments objectAtIndex:1];
        AVAudioPlayer *player = (AVAudioPlayer *)[soundCache objectForKey:audioId];
        float volume = [(NSNumber *)[arguments objectAtIndex:2] floatValue];
        if (player) {
            player.volume = volume;
        }
    }
}

#pragma mark Other

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (context) {
        AVAudioPlayer *player = (__bridge AVAudioPlayer *)context;
        
        [self stopAndFreePlay:player];
        
        [(QWWebViewController *)(self.webView.delegate) removeObserver:self forKeyPath:@"audioCache"];
    }
}

- (void)stopAndFreePlay:(id)player{
    if (player){
       NSArray *keys = [soundCache allKeysForObject:player];
        if (keys && [keys count]>0){
            for(NSString *key in keys){
                AVAudioPlayer *player_ = (AVAudioPlayer *)[soundCache objectForKey:key];
                if(player_){
                    [player_ stop];
                    [soundCache removeObjectForKey:key];
                }
            }
        }
    }
}

@end



#import "QWJSVideoExt.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QWWebViewController.h"
#import "HttpClient.h"

#define UNKNOWN_ERROR 1
#define NO_FILE_ERROR 2
#define PLAY_FAIL_ERROR 3
#define PAUSE_FAIL_ERROR 4
#define RESUME_FAIL_ERROR 5
#define STOP_FAIL_ERROR 6

@implementation QWJSVideoExt
@synthesize jsCallbackId_;
//这里需要把video返回给html
 
- (void)load:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>2) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
            NSString *src = [arguments objectAtIndex:1];
            NSString *videoId = [arguments objectAtIndex:2];
          __block  NSURL *url = nil;
      __block  BOOL needRemoveFile = NO;
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
                 NSString *resourcePath = [docDir stringByAppendingPathComponent:PLUG_IN_RESOURCES];
                NSString *path = [resourcePath stringByAppendingPathComponent:src];
                NSString *finalPath = nil;
                if ([fileManager fileExistsAtPath:path]) {
                     finalPath = path;
                }
                if (finalPath == nil) {
                    resourcePath = [docDir stringByAppendingPathComponent:OFFLINE_RESOURCES];
                    path = [resourcePath stringByAppendingPathComponent:src];
                    if ([fileManager fileExistsAtPath:path]) {
                         finalPath = path;
                    }
                }
                if (finalPath == nil) {
                    resourcePath = [docDir stringByAppendingPathComponent:WRITE_RESOURCES];
                    path = [resourcePath stringByAppendingPathComponent:src];
                    if ([fileManager fileExistsAtPath:path]) {
                         finalPath = path;
                    }
                }
                if (finalPath == nil) {
                    path = [[NSBundle mainBundle] pathForResource:src ofType:nil];
                    if ([fileManager fileExistsAtPath:path]) {
                         finalPath = path;
                    }
                }
                
                if (finalPath) {
                    NSData *data = [NSData dataWithContentsOfFile:finalPath];
                    if (data) {
                        url = [NSURL fileURLWithPath:finalPath];
                    }
                    
                }
            }
            
            if (url) {
                MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
                player.view.backgroundColor = [UIColor clearColor];
                player.useApplicationAudioSession = NO;
                player.scalingMode = MPMovieScalingModeFill;
                player.controlStyle = MPMovieControlStyleDefault;
                
                if (soundCache == nil) {
                    soundCache = [[NSMutableDictionary alloc] initWithCapacity:0];
                }
                if (player) {
                    [soundCache setObject:player forKey:videoId];
                    [(QWWebViewController *)(self.webView.delegate) addObserver:self forKeyPath:@"videoCache" options:0 context:(void *)player];
                    [(QWWebViewController *)(self.webView.delegate) addVideoRef:player];

                }
                // Register for the playback finished notification.
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(moviePlayBackDidFinish:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:player];
              
                
                //音频文件加载结束，删除文件
                if (needRemoveFile) {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *tempPath = url.path;
                    if ([fileManager fileExistsAtPath:tempPath]) {
                        [fileManager removeItemAtPath:tempPath error:NULL];
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
        NSString *videoId = [arguments objectAtIndex:1];
        MPMoviePlayerController *player = (MPMoviePlayerController *)[soundCache objectForKey:videoId];
        if (player) {
            [player.view removeFromSuperview];
            [player stop];
            [soundCache removeObjectForKey:videoId];
            [(QWWebViewController *)(self.webView.delegate) removeVideoRef:player];

            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                                          object:player];
            [self writeScript:self.jsCallbackId_ messageString:@"dispose success" state:0 keepCallback:NO];
            return;
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"dispose fail" state:UNKNOWN_ERROR keepCallback:NO];

}
- (void)play:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        NSString *videoId = [arguments objectAtIndex:1];
        CGRect videoFrame = CGRectZero;
        if (options) {
            float x = [[options objectForKey:@"x"] floatValue];
            float y = [[options objectForKey:@"y"] floatValue];
            float width = [[options objectForKey:@"width"] floatValue];
            float height = [[options objectForKey:@"height"] floatValue];
            videoFrame = CGRectMake(x,y,width,height);
        }
        MPMoviePlayerController *player = (MPMoviePlayerController *)[soundCache objectForKey:videoId];
        UIView *backBroundView = [[UIView alloc] initWithFrame:CGRectMake(APP_H/2, APP_W/2, 0.0, 0.0)];
        backBroundView.tag = 541;
        backBroundView.backgroundColor = [UIColor blackColor];
        backBroundView.transform = CGAffineTransformMakeRotation(M_PI_2);
        id del = [[UIApplication sharedApplication] delegate];
        UIWindow *window = nil;
        if ([del respondsToSelector:@selector(window)]) {
            window = [del window];
            
            [window.rootViewController.view addSubview:backBroundView];
      
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            if (!CGRectEqualToRect(videoFrame, CGRectZero)) {
                backBroundView.frame = videoFrame;
            }else{
                backBroundView.frame = CGRectMake(0.0, 0.0, APP_H, APP_W);
            }
            [UIView commitAnimations];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:player forKey:@"player"];
            if (!CGRectEqualToRect(videoFrame, CGRectZero)) {
                [params setObject:options forKey:@"frame"];
            }
            [self performSelector:@selector(playVideo:) withObject:params afterDelay:0.3];
        }
        
    }
    
}
- (void)stop:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *videoId = [arguments objectAtIndex:1];
        MPMoviePlayerController *player = (MPMoviePlayerController *)[soundCache objectForKey:videoId];
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
        NSString *videoId = [arguments objectAtIndex:1];
        MPMoviePlayerController *player = (MPMoviePlayerController *)[soundCache objectForKey:videoId];
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
        NSString *videoId = [arguments objectAtIndex:1];
        MPMoviePlayerController *player = (MPMoviePlayerController *)[soundCache objectForKey:videoId];
        if (player) {
            [player play];
            [self writeScript:self.jsCallbackId_ messageString:@"resume success" state:0 keepCallback:NO];
            return;
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"resume fail" state:UNKNOWN_ERROR keepCallback:NO];

}
- (void)playVideo:(NSDictionary *)dic{
    id del = [[UIApplication sharedApplication] delegate];
    UIWindow *window = nil;
    if ([del respondsToSelector:@selector(window)]) {
        window = [del window];
        
        UIView *subView = [window.rootViewController.view viewWithTag:541];
        if(subView){
            [subView removeFromSuperview];
        }
        
        MPMoviePlayerController *player = (MPMoviePlayerController *)([dic objectForKey:@"player"]);
        CGRect videoFrame = CGRectZero;
        NSDictionary *frame = (NSDictionary *)[dic objectForKey:@"frame"];
        if (frame) {
            float x = [[frame objectForKey:@"x"] floatValue];
            float y = [[frame objectForKey:@"y"] floatValue];
            float width = [[frame objectForKey:@"width"] floatValue];
            float height = [[frame objectForKey:@"height"] floatValue];
            videoFrame = CGRectMake(x,y,width,height);
        }
        if (player) {
            id del = [[UIApplication sharedApplication] delegate];
            UIWindow *window = nil;
            if ([del respondsToSelector:@selector(window)]) {
                window = [del window];
                
                if (!CGRectEqualToRect(videoFrame, CGRectZero)) {
                    player.view.frame = videoFrame;
                    [player setFullscreen:NO animated:NO];

                }else{
                    [player setFullscreen:YES];
                }
                
                [window.rootViewController.view addSubview:player.view];
                [player play];
                [self writeScript:self.jsCallbackId_ messageString:@"play success" state:0 keepCallback:NO];
                return;
            }
            
        }
    }
    [self writeScript:self.jsCallbackId_ messageString:@"play fail" state:UNKNOWN_ERROR keepCallback:NO];

}

- (void)moviePlayBackDidFinish:(NSNotification*)aNotification {

    
}
#pragma mark Other

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if (context) {
        MPMoviePlayerController *player = (__bridge MPMoviePlayerController *)context;
        
        [self stopAndFreePlay:player];
        [(QWWebViewController *)(self.webView.delegate) removeObserver:self forKeyPath:@"videoCache"];

    }

}

- (void)stopAndFreePlay:(id)player{
    if (player){
        NSArray *keys = [soundCache allKeysForObject:player];
        if (keys && [keys count]>0){
            for(NSString *key in keys){
                MPMoviePlayerController *player_ = (MPMoviePlayerController *)[soundCache objectForKey:key];
                if(player_){
                    [player_.view removeFromSuperview];
                    [player_ stop];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                                  object:player_];
                    [soundCache removeObjectForKey:key];

                }
            }
        }
    }
}
@end

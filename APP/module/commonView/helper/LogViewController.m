//
//  LogViewController.m
//  APP
//
//  Created by carret on 15/2/14.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#if !(TARGET_IPHONE_SIMULATOR) && (DEBUG)
    if ([GLOBALMANAGER console]) {
        
        NSString *tempPath = NSTemporaryDirectory();
        NSString *nslogPath = [tempPath stringByAppendingPathComponent:@"nslog.log"];
        NSString *printfPath = [tempPath stringByAppendingPathComponent:@"printf.log"];
        remove([nslogPath cStringUsingEncoding:NSASCIIStringEncoding]);
        remove([printfPath cStringUsingEncoding:NSASCIIStringEncoding]);
        
        
        CGRect consoleFrame = CGRectZero;
        if ([ GLOBALMANAGER iPhone]) {
            consoleFrame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
        } else  {
            consoleFrame = CGRectMake(0.0, 0.0, 600.0, 800.0);
        }
        
        UITextView *logview =  [[UITextView alloc] initWithFrame:CGRectZero]  ;
        CGRect rect = CGRectMake(0.0, 33.0, consoleFrame.size.width, consoleFrame.size.height - 33.0);
        logview.frame = rect;
        logview.tag = 11;
        logview.editable = NO;
        
        consoleView_ = [[UIView alloc] initWithFrame:consoleFrame];
        consoleView_.backgroundColor = [UIColor grayColor];
        UIButton *clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [clear setTitle:@"清 空" forState:UIControlStateNormal];
        clear.frame = CGRectMake(consoleFrame.size.width - 55 - 55, 3, 50, 25);
        [clear addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancel setTitle:@"取 消" forState:UIControlStateNormal];
        cancel.frame = CGRectMake(consoleFrame.size.width - 55, 3, 50, 25);
        [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *switchlog = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [switchlog setTitle:@"Lua Log" forState:UIControlStateNormal];
        switchlog.frame = CGRectMake(5, 3, 80, 25);
        [switchlog addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        consoleView_.tag = 1;
        [consoleView_ addSubview:logview];
        [consoleView_ addSubview:clear];
        [consoleView_ addSubview:cancel];
        [consoleView_ addSubview:switchlog];
        
        
        
        consoleLock_ = [[NSLock alloc] init];
        
        
        UIButton *show = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [show addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        show.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 45, [[UIScreen mainScreen] bounds].size.height - STATUS_BAR_HEIGHT - 45, 40, 40);
        
        
        [window.rootViewController.view addSubview:show];
        [window.rootViewController.view bringSubviewToFront:show];
        
        
        
        [self redirectlog];
        
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerun) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
    }
#endif

    // Do any additional setup after loading the view from its nib.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
#if !(TARGET_IPHONE_SIMULATOR) && (DEBUG)
    fclose(stderr);
    fclose(stdout);
    NSString *tempPath = NSTemporaryDirectory();
    NSString *nslogPath = [tempPath stringByAppendingPathComponent:@"nslog.log"];
    NSString *printfPath = [tempPath stringByAppendingPathComponent:@"printf.log"];
    remove([nslogPath cStringUsingEncoding:NSASCIIStringEncoding]);
    remove([printfPath cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#if !(TARGET_IPHONE_SIMULATOR) && (DEBUG)
- (void)timerun {
    if ([consoleLock_ tryLock]) {
        
        // 必须调用刷新，不让printf打印的内容会保存在缓存中，不知道何时系统才能刷新
        fflush(stdout);
        
        NSString *tempPath = NSTemporaryDirectory();
        NSString *nslogPath = [tempPath stringByAppendingPathComponent:@"nslog.log"];
        NSString *printfPath = [tempPath stringByAppendingPathComponent:@"printf.log"];
        NSString *logPath = nil;
        if (consoleView_.tag == 1) {
            logPath = nslogPath;
        } else {
            logPath = printfPath;
        }
        
        UIView *logview = [consoleView_ viewWithTag:11];
        if ([logview isKindOfClass:[UITextView class]]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
                NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:logPath error:nil];
                NSNumber *theFileSize;
                if (theFileSize = [attributes objectForKey:NSFileSize]) {
                    if ([theFileSize intValue] > 512000) { // 超过500K删除
                        remove([logPath cStringUsingEncoding:NSASCIIStringEncoding]);
                        if (consoleView_.tag == 1) {
                            freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stderr);
                        } else {
                            freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stdout);
                        }
                    }
                }
                NSString *logcontent = [NSString stringWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:nil];
                
                ((UITextView *)logview).text = logcontent;
                
                [((UITextView *)logview) scrollRangeToVisible:NSMakeRange([logcontent length] - 1, 1)];
            }
        }
    }
    [consoleLock_ unlock];
}

- (void)showAction:(id)sender {
    
    if ([ GLOBALMANAGER iPad]) {
        popver_ = [[UIPopoverController alloc] initWithContentViewController:window.rootViewController];
        popver_.contentViewController =[[UIViewController alloc] init] ;
        [popver_ setPopoverContentSize:consoleView_.frame.size];
        popver_.contentViewController.view = consoleView_;
        [popver_ presentPopoverFromRect:CGRectMake([[UIScreen mainScreen] bounds].size.width - 45, [[UIScreen mainScreen] bounds].size.height - STATUS_BAR_HEIGHT - 45, 40, 40) inView:window.rootViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [window.rootViewController.view addSubview:consoleView_];
        [window.rootViewController.view bringSubviewToFront:consoleView_];
    }
    
}

- (void)clearAction:(id)sender {
    if ([consoleLock_ tryLock]) {
        NSString *tempPath = NSTemporaryDirectory();
        NSString *nslogPath = [tempPath stringByAppendingPathComponent:@"nslog.log"];
        NSString *printfPath = [tempPath stringByAppendingPathComponent:@"printf.log"];
        if (consoleView_.tag == 1) {
            remove([nslogPath cStringUsingEncoding:NSASCIIStringEncoding]);
            freopen([nslogPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stderr);
        } else {
            remove([printfPath cStringUsingEncoding:NSASCIIStringEncoding]);
            freopen([printfPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stdout);
        }
        UIView *logview = [consoleView_ viewWithTag:11];
        if ([logview isKindOfClass:[UITextView class]]) {
            ((UITextView *)logview).text = @"";
        }
    }
    [consoleLock_ unlock];
}

- (void)cancelAction:(id)sender {
    if ([consoleLock_ tryLock]) {
        if ([ GLOBALMANAGER iPad]) {
            [popver_ dismissPopoverAnimated:YES];
        } else {
            [consoleView_ removeFromSuperview];
        }
    }
    [consoleLock_ unlock];
}

- (void)switchAction:(id)sender {
    if ([consoleLock_ tryLock]) {
        if ([((UIButton *)sender).currentTitle isEqualToString:@"Lua Log"]) {
            [((UIButton *)sender) setTitle:@"EWP Log" forState:UIControlStateNormal];
            consoleView_.tag = 2;
            UIView *logview = [consoleView_ viewWithTag:11];
            if ([logview isKindOfClass:[UITextView class]]) {
                NSString *tempPath = NSTemporaryDirectory();
                NSString *printfPath = [tempPath stringByAppendingPathComponent:@"printf.log"];
                NSString *logcontent = [NSString stringWithContentsOfFile:printfPath encoding:NSUTF8StringEncoding error:nil];
                ((UITextView *)logview).text = logcontent;
            }
        } else if ([((UIButton *)sender).currentTitle isEqualToString:@"EWP Log"]) {
            [((UIButton *)sender) setTitle:@"Lua Log" forState:UIControlStateNormal];
            consoleView_.tag = 1;
            UIView *logview = [consoleView_ viewWithTag:11];
            if ([logview isKindOfClass:[UITextView class]]) {
                NSString *tempPath = NSTemporaryDirectory();
                NSString *nslogPath = [tempPath stringByAppendingPathComponent:@"nslog.log"];
                NSString *logcontent = [NSString stringWithContentsOfFile:nslogPath encoding:NSUTF8StringEncoding error:nil];
                ((UITextView *)logview).text = logcontent;
            }
        }
    }
    [consoleLock_ unlock];
}

- (void)redirectlog {
    NSString *tempPath = NSTemporaryDirectory();
    NSString *nslogPath = [tempPath stringByAppendingPathComponent:@"nslog.log"];
    NSString *printfPath = [tempPath stringByAppendingPathComponent:@"printf.log"];
    freopen([nslogPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stderr);
    freopen([printfPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stdout);
}


#endif



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

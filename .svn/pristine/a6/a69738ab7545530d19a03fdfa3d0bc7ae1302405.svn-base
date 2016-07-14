
#import "QWJSFileExt.h"

#define UNKNOWN_ERROR  1
#define WRITE_FAIL_ERROR  2
#define READ_FAIL_ERROR 3
#define REMOVE_FAIL_ERROR 4
#define GET_FAIL_ERROR 5

@implementation QWJSFileExt
@synthesize jsCallbackId_;
- (void)write:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>2) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        
        NSString *name = (NSString *)[arguments objectAtIndex:1];
        NSString *content = [arguments objectAtIndex:2];
        NSError *error = nil;
        if (name && content) {
            NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [arrayPaths objectAtIndex:0];
            NSString *resourcePath = nil;
            if (docDir) {
                resourcePath = [docDir stringByAppendingPathComponent:WRITE_RESOURCES];
                if (![[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:resourcePath withIntermediateDirectories:YES attributes:nil error:&error];
                    if (error) {
                         [self writeScript:self.jsCallbackId_ messageString:error.description state:WRITE_FAIL_ERROR keepCallback:NO];
                        return;
                    }
                }
            }
            NSString *newFilePath = [resourcePath stringByAppendingPathComponent:name];
            BOOL succ = [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:&error];
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
//            [[FileManager sharedFileManager] addResourceProversion:name data:data];
            succ = [content writeToFile:newFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!succ) {
                [self writeScript:self.jsCallbackId_ messageString:error.description state:WRITE_FAIL_ERROR keepCallback:NO];
                
            }else{
                [self writeScript:self.jsCallbackId_ messageString:@"write success" state:0 keepCallback:NO];
            }
        }
    }
}

//如何把数据返回给webview？
- (void)read:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    if ([arguments count]>2) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *name = (NSString *)[arguments objectAtIndex:1];
        NSString *type = [arguments objectAtIndex:2];
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [arrayPaths objectAtIndex:0];
        if (docDir && name && type) {
            if (name && type) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                /*
                 先检测插件包，然后离线资源包，write接口写的文件包，最后安装包
                 */
                 NSString *resourcePath = [docDir stringByAppendingPathComponent:PLUG_IN_RESOURCES];
                NSString *path = [resourcePath stringByAppendingPathComponent:name];
                NSString *finalPath = nil;
                if ([fileManager fileExistsAtPath:path]) {
                     finalPath = path;
                }
                if (finalPath == nil) {
                    resourcePath = [docDir stringByAppendingPathComponent:OFFLINE_RESOURCES];
                    path = [resourcePath stringByAppendingPathComponent:name];
                    if ([fileManager fileExistsAtPath:path]) {
                         finalPath = path;
                    }
                }
                if (finalPath == nil) {
                    resourcePath = [docDir stringByAppendingPathComponent:WRITE_RESOURCES];
                    path = [resourcePath stringByAppendingPathComponent:name];
                    if ([fileManager fileExistsAtPath:path]) {
                         finalPath = path;
                    }
                }
                if (finalPath == nil) {
                    path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
                    if ([fileManager fileExistsAtPath:path]) {
                         finalPath = path;
                    }
                }
                
                if (finalPath) {
                    NSData *data = [NSData dataWithContentsOfFile:finalPath];
                    
                    if (data) {
                   
                        
                        if ([type isEqualToString:@"text"]) {
                            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            [self writeScript:self.jsCallbackId_ messageString:content state:0 keepCallback:NO];
                         } else if ([type isEqualToString:@"image"]) {
                            
                        } else if ([type isEqualToString:@"stream"]) {
                            
                        }else{
                            [self writeScript:self.jsCallbackId_ messageString:@"bad args" state:READ_FAIL_ERROR keepCallback:NO];
                        }
                    }
                    
                }
            }
        }
    }else{
        [self writeScript:self.jsCallbackId_ messageString:@"bad args" state:READ_FAIL_ERROR keepCallback:NO];
    }
}
- (void)remove:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    if ([arguments count]>0) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *name = (NSString *)[arguments objectAtIndex:1];
        
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [arrayPaths objectAtIndex:0];
        
        if (docDir && name) {
            NSString *resourcePath = [docDir stringByAppendingPathComponent:WRITE_RESOURCES];
            NSString *path = [resourcePath stringByAppendingPathComponent:name];
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (error) {
                [self writeScript:self.jsCallbackId_ messageString:error.description state:REMOVE_FAIL_ERROR keepCallback:NO];
            }else{
                [self writeScript:self.jsCallbackId_ messageString:@"remove success"  state:0 keepCallback:NO];
            
            }
        }
    }
}
- (void)isExist:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    if ([arguments count]>1) {
        
        {   self.jsCallbackId_ = [arguments objectAtIndex:0];
            NSString *name = [arguments objectAtIndex:1];
            if (name) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                /*
                 先检测插件包，然后离线资源包，write接口写的文件包，最后安装包
                 */
                NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:PLUG_IN_RESOURCES];
                NSString *path = [resourcePath stringByAppendingPathComponent:name];
                
                BOOL find = [fileManager fileExistsAtPath:path];
                if (!find) {
                    resourcePath = [documentsDirectory stringByAppendingPathComponent:OFFLINE_RESOURCES];
                    path = [resourcePath stringByAppendingPathComponent:name];
                    find = [fileManager fileExistsAtPath:path];
                    if (!find) {
                        resourcePath = [documentsDirectory stringByAppendingPathComponent:WRITE_RESOURCES];
                        path = [resourcePath stringByAppendingPathComponent:name];
                        find = [fileManager fileExistsAtPath:path];
                        if (!find) {
                            path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:name];
                            find = [fileManager fileExistsAtPath:path];
                        }
                    }
                }
                [self writeScript:self.jsCallbackId_ message:find?@"true":@"false" state:0 keepCallback:NO];
                
            }
        }
        
    }
}
- (void)getFile:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        
        {
            self.jsCallbackId_ = [arguments objectAtIndex:0];
            NSString *name = [arguments objectAtIndex:1];
            if (name) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                /*
                 先检测插件包，然后离线资源包，write接口写的文件包，最后安装包
                 */
                NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:PLUG_IN_RESOURCES];
                NSString *path = [resourcePath stringByAppendingPathComponent:name];
                
                BOOL find = [fileManager fileExistsAtPath:path];
                if (!find) {
                    resourcePath = [documentsDirectory stringByAppendingPathComponent:OFFLINE_RESOURCES];
                    path = [resourcePath stringByAppendingPathComponent:name];
                    find = [fileManager fileExistsAtPath:path];
                    if (!find) {
                        resourcePath = [documentsDirectory stringByAppendingPathComponent:WRITE_RESOURCES];
                        path = [resourcePath stringByAppendingPathComponent:name];
                        find = [fileManager fileExistsAtPath:path];
                        if (!find) {
                            path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:name];
                            find = [fileManager fileExistsAtPath:path];
                        }
                    }
                }
                if (find && path) {
                    NSString *message = [NSString stringWithFormat:@"new FileEntry(\"%@\",\"%@\")",name,path];
                    [self writeScript:self.jsCallbackId_ message:message state:0 keepCallback:NO];
                }else{
                    [self writeScript:self.jsCallbackId_ messageString:@"get file error"  state:GET_FAIL_ERROR keepCallback:NO];
                }
            }
        }
        
    }
}
@end

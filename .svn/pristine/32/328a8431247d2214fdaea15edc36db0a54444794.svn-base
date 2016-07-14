

#import "QWJSCameraExt.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Base64.h"
#define UNKNOWN_ERROR 1
#define NOT_SUPPORT_ERROR 2

@implementation QWJSCameraExt

@synthesize  jsCallbackId_;


- (void)open:(NSArray *)arguments withDict:(NSDictionary *)options {
    
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    
    // 暂时先不定义参数
    NSString* sourceTypeString = [options valueForKey:@"sourceType"];
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera; // default
	if (sourceTypeString != nil)
	{
		sourceType = (UIImagePickerControllerSourceType)[sourceTypeString intValue];
	}
    
    
	bool hasCamera = [UIImagePickerController isSourceTypeAvailable:sourceType];
	if (!hasCamera) {
        
        // 这里应该回调JS中提供的回调函数并将想要展示的信息回传，类PluginResult（Phonegap）我们暂时不实现
        //PluginResult* result = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString: @"no camera available"];
        //[self writeJavascript:[result toErrorCallbackString:callbackId]];
        NSString *massage = @"no camera available";
        [self writeScript:self.jsCallbackId_ messageString:massage state:NOT_SUPPORT_ERROR keepCallback:NO];
	} else {
        if (imagePickerController_ == nil) {
            imagePickerController_ = [[UIImagePickerController alloc] init];
            imagePickerController_.delegate = self;
            imagePickerController_.sourceType = sourceType;
            imagePickerController_.allowsEditing = YES;
        }
        
        
        id del = [[UIApplication sharedApplication] delegate];
        UIWindow *window = nil;
        if ([del respondsToSelector:@selector(window)]) {
            window = [del window];
            [window.rootViewController presentModalViewController:imagePickerController_ animated:YES];
        }
        
//        [window.rootViewController.view addSubview:imagePickerController_.view];
        
    }
    
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSDictionary* imageInfo = [NSDictionary dictionaryWithObject:image forKey:UIImagePickerControllerOriginalImage];
	[self imagePickerController:picker didFinishPickingMediaWithInfo: imageInfo];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
				
		// get the image
		UIImage* image = nil;
		if ([info objectForKey:UIImagePickerControllerEditedImage]) {
			image = [info objectForKey:UIImagePickerControllerEditedImage];
		} else {
			image = [info objectForKey:UIImagePickerControllerOriginalImage];
		}
        
        
        NSData* data = UIImagePNGRepresentation(image);
		
        {
			
			// write to temp directory and reutrn URI
			// get the temp directory path
			NSString* docsPath = [NSTemporaryDirectory() stringByStandardizingPath];
			NSError* err = nil;
			NSFileManager* fileMgr = [[NSFileManager alloc] init]; //recommended by apple (vs [NSFileManager defaultManager]) to be theadsafe
			
			// generate unique file name
			NSString *filePath;
			int i=1;
			do {
				filePath = [NSString stringWithFormat:@"%@/photo_%03d.%@", docsPath, i++, @"png"];
			} while([fileMgr fileExistsAtPath: filePath]);
            
			// save file
			if (![data writeToFile: filePath options: NSAtomicWrite error: &err]){
                [self writeScript:self.jsCallbackId_ messageString:[err localizedDescription] state:UNKNOWN_ERROR keepCallback:NO];

			} else {
                NSString *base64Data = [Base64 encode:data];
                NSString *messageString = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",base64Data];
                [self writeScript:self.jsCallbackId_ messageString:messageString state:0 keepCallback:NO];
                
//                NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
//                NSString *urlStr = [fileUrl absoluteString];
                
//                [self writeScript:self.jsCallbackId_ messageString:urlStr state:0 keepCallback:NO];
			}
 			
		}

	}
    
    [picker dismissViewControllerAnimated:YES completion:nil];

//    [imagePickerController_.view removeFromSuperview];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 这里应该回调JS中提供的回调函数并将想要展示的信息回传，类PluginResult（Phonegap）我们暂时不实现
    //PluginResult* result = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString: @"no image selected"]; // error callback expects string ATM
	//[self writeJavascript:[result toErrorCallbackString:]];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [imagePickerController_.view removeFromSuperview];
    
}
 
@end



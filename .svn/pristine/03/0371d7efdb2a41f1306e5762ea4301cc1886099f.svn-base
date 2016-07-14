

#import "QWJSExtensionsList.h"

@implementation QWJSExtensionsList

@synthesize plist;

static QWJSExtensionsList *sharedRYTJSExtensionsList = nil;

+ (QWJSExtensionsList *)sharedRYTJSExtensionsList {
    @synchronized ([QWJSExtensionsList class]) {
        if (sharedRYTJSExtensionsList == nil) {
        sharedRYTJSExtensionsList =    [[QWJSExtensionsList alloc] init];
            
            NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"QWJSExtensions" ofType:@"plist"];
            sharedRYTJSExtensionsList.plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
            
            return sharedRYTJSExtensionsList;
        }
    }
    return sharedRYTJSExtensionsList;
}


+ (id)alloc {
    @synchronized ([QWJSExtensionsList class]) {
        sharedRYTJSExtensionsList = [super alloc];
        return sharedRYTJSExtensionsList;
    }
    return nil;
}

- (NSString *)classNameByService:(NSString *)service {
    NSString *classname = (NSString *)[plist objectForKey:service];
    return classname;
}

@end

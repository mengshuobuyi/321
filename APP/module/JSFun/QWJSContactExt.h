

#import "QWJSExtension.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@interface QWJSContactExt : QWJSExtension <ABPeoplePickerNavigationControllerDelegate>
{
        NSString                    *jsCallbackId_;
    ABPeoplePickerNavigationController *pickerNavigationController;

}
@property (nonatomic, copy) NSString *jsCallbackId_;

- (void)open:(NSArray *)arguments withDict:(id)options;
- (void)add:(NSArray *)arguments withDict:(id)options;
- (void)delete:(NSArray *)arguments withDict:(id)options;
@end


#import "QWJSContactExt.h"
#import <AddressBook/AddressBook.h>

#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define ADD_FAIL_ERROR 2
#define OPEN_FAIL_ERROR 3
#define DELETE_FAIL_ERROR 4

#define FIRST_NAME @"firstName"
#define LAST_NAME @"lastName"
#define MIDDLE_NAME @"middleName"
#define PHONE_NUMBER @"phoneNumber"
#define ADDRESS @"address"
#define EMAIL @"email"

@implementation QWJSContactExt
@synthesize jsCallbackId_;

- (void)open:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>0) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        pickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
        pickerNavigationController.peoplePickerDelegate = self;
        
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
         [rootViewController presentViewController:rootViewController animated:NO completion:^{
            
        }];
        [self writeScript:self.jsCallbackId_ message:@"null" state:SUCCESS keepCallback:NO];

    }
}
- (void)add:(NSArray *)arguments withDict:(id)options{
    NSInteger count = [arguments count];
    if (count > 1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        if (options && [options isKindOfClass:[NSArray class]] && [(NSArray *)options count]>0) {
            @try{
                ABAddressBookRef addressBook = ABAddressBookCreate();
                CFErrorRef error = NULL;
                for (int i = 0; i < [(NSArray *)options count]; i++) {
                    NSDictionary *person = [options objectAtIndex:0];
                    NSString *firstName = [person objectForKey:FIRST_NAME];
                    NSString *lastName = [person objectForKey:LAST_NAME];
                    NSString *middleName = [person objectForKey:MIDDLE_NAME];
                    NSString *phoneNum = [person objectForKey:PHONE_NUMBER];
                    NSString *address = [person objectForKey:ADDRESS];
                    NSString *email = [person objectForKey:EMAIL];
                    
                    ABRecordRef newPerson = ABPersonCreate();
                    //name
                    if (firstName && ![middleName isKindOfClass:[NSNull class]]) {
                        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), &error);
                    }
                    if (lastName && ![lastName isKindOfClass:[NSNull class]]) {
                        ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), &error);
                    }
                    if (middleName && ![middleName isKindOfClass:[NSNull class]]) {
                        ABRecordSetValue(newPerson, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(middleName), &error);
                    }
                    //phone
                    if (phoneNum && ![phoneNum isKindOfClass:[NSNull class]]) {
                        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phoneNum), kABPersonPhoneMainLabel, NULL);
                        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
                        CFRelease(multiPhone);
                    }
                    
                    //address
                    if (address && ![address isKindOfClass:[NSNull class]]) {
                        
                        ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABDictionaryPropertyType);
                        
                        static int  homeLableValueCount = 5;
                        
                        // Set up keys and values for the dictionary.
                        CFStringRef keys[homeLableValueCount];
                        CFStringRef values[homeLableValueCount];
                        keys[0]      = kABPersonAddressStreetKey;
                        keys[1]      = kABPersonAddressCityKey;
                        keys[2]      = kABPersonAddressStateKey;
                        keys[3]      = kABPersonAddressZIPKey;
                        keys[4]      = kABPersonAddressCountryKey;
                        values[0]    = (CFStringRef)CFBridgingRetain(address);
                        values[1]    = CFSTR("");
                        values[2]    = CFSTR("");
                        values[3]    = CFSTR("");
                        values[4]    = CFSTR("");
                        CFDictionaryRef aDict = CFDictionaryCreate(kCFAllocatorDefault, (const void**)keys, (const void**)values, homeLableValueCount, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
                        
                        // Add the street address to the person record.
                        ABMultiValueIdentifier identifier;
                        
                        ABMultiValueAddValueAndLabel(multiAddress, aDict, kABHomeLabel, &identifier);
                        
                        ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress, &error);
                        
                        CFRelease(aDict);
                        CFRelease(multiAddress);
                        
                    }
                    
                    //email
                    if (email && ![email isKindOfClass:[NSNull class]]) {
                        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                        ABMultiValueAddValueAndLabel(multiEmail, CFBridgingRetain(email), kABWorkLabel, NULL);
                        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
                        CFRelease(multiEmail);
                    }
                    ABAddressBookAddRecord(addressBook, newPerson, &error);
                    CFRelease(newPerson);
                }
                ABAddressBookSave(addressBook, &error);
                
                if (error) {
                    
                    [self writeScript:self.jsCallbackId_ messageString:[NSString stringWithFormat:@"%@",error] state:ADD_FAIL_ERROR keepCallback:NO];
                    
                }else{
                    [self writeScript:self.jsCallbackId_ messageString:@"add successful" state:SUCCESS keepCallback:NO];
                }
                
                CFRelease(addressBook);
            }@catch (NSException *e) {
             }
        }
    }
}
- (void)delete:(NSArray *)arguments withDict:(id)options{
    int count = [arguments count];
    if (count > 1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        
        CFErrorRef error = NULL;
        
        if (options && [options isKindOfClass:[NSArray class]] && [(NSArray *)options count]>0) {
            ABAddressBookRef addressBook = ABAddressBookCreate();
            CFArrayRef personArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
            NSArray *persons = (NSArray *)options;
            for (int i = 0; i < [(NSArray *)options count]; i++) {
                
                NSDictionary *person = [persons objectAtIndex:0];
                
                NSString *firstName = [person objectForKey:FIRST_NAME];
                NSString *lastName = [person objectForKey:LAST_NAME];
                NSString *middleName = [person objectForKey:MIDDLE_NAME];
                NSString *phoneNum = [person objectForKey:PHONE_NUMBER];
                //NSString *address = [person objectForKey:ADDRESS];
                NSString *email = [person objectForKey:EMAIL];
                
                for (int i = 0; i < personCount; i++) {
                    ABRecordRef _person = CFArrayGetValueAtIndex(personArray, i);
                    BOOL match = NO;
                    if (firstName && ![firstName isKindOfClass:[NSNull class]]){
                    NSString *_firstName = (__bridge NSString *)ABRecordCopyValue(_person, kABPersonFirstNameProperty);
                        if([firstName isEqualToString:_firstName]){
                            match = YES;
                        }else{
                            match = NO;
                        }
                     }
                    
                    if (match == YES && lastName && ![lastName isKindOfClass:[NSNull class]]){
                        NSString *_lastName = (__bridge NSString *)ABRecordCopyValue(_person, kABPersonLastNameProperty);
                        if([lastName isEqualToString:_lastName]){
                            match = YES;
                        }else{
                            match = NO;
                        }
                     }
                    if (match == YES && middleName && ![middleName isKindOfClass:[NSNull class]]){
                        NSString *_middleName = (__bridge NSString *)ABRecordCopyValue(_person, kABPersonMiddleNameProperty);
                        if([middleName isEqualToString:_middleName]){
                            match = YES;
                        }else{
                            match = NO;
                        }
                     }
                    if (match == YES && phoneNum && ![phoneNum isKindOfClass:[NSNull class]]){
                        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(_person, kABPersonPhoneProperty);
                        NSInteger count = ABMultiValueGetCount(phoneMulti);
                        for (int index = 0;index<count; index++){
                            NSString *_prePhoneNum = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti,index);
                            NSString *_phoneNum = [_prePhoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
                             if([phoneNum isEqualToString:_phoneNum]){
                                match = YES;
                                break;
                            }else{
                                match = NO;
                            }
                        }
                        CFRelease(phoneMulti);
                    }
                    //暂时不通过address来判断删除
                    /*
                     if (match == YES && address && ![address isKindOfClass:[NSNull class]]){
                     ABMutableMultiValueRef addressMulti = ABRecordCopyValue(_person, kABPersonAddressProperty);
                     int count = ABMultiValueGetCount(addressMulti);
                     for (int index = 0;index<count; i++){
                     NSString *_address = (NSString *)ABMultiValueCopyValueAtIndex(addressMulti,index);
                     if([address isEqualToString:_address]){
                     match = YES;
                     break;
                     }else{
                     match = NO;
                     }
                     }
                     }
                     */

                    
                    
                    if (match == YES && email && ![email isKindOfClass:[NSNull class]]){
                        ABMutableMultiValueRef emailMulti = ABRecordCopyValue(_person, kABPersonEmailProperty);
                        NSInteger count = ABMultiValueGetCount(emailMulti);
                        for (int index = 0;index<count; index++){
                            NSString *_email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailMulti,index);
                            if([email isEqualToString:_email]){
                                match = YES;
                                 break;
                            }else{
                                match = NO;
                             }
                        }
                        CFRelease(emailMulti);
                    }

                    if (match){
                        ABAddressBookRemoveRecord(addressBook, _person, &error);
                        break;
                    }
                }
            }
            
            ABAddressBookSave(addressBook, &error);
            
            if (error) {
                 [self writeScript:self.jsCallbackId_ messageString:[NSString stringWithFormat:@"%@",error] state:DELETE_FAIL_ERROR keepCallback:NO];
                
            }else{
                [self writeScript:self.jsCallbackId_ messageString:@"delete successful" state:SUCCESS keepCallback:NO];
            }
            
            CFRelease(personArray);
            CFRelease(addressBook);
        }

    }
}
 
#pragma mark ==== ABPeoplePickerNavigationControllerDelegate ====
// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{

    [self writeScript:self.jsCallbackId_ messageString:@"cancel"  state:0 keepCallback:NO];

     [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];

}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    NSString *firstName = @"";
    NSString *lastName = @"";
    NSString *middleName = @"";
    
    NSString *tempName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (tempName && [tempName length]>0) {
        firstName = tempName;
    }
    
    tempName = nil;
    tempName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (tempName && [tempName length]>0) {
        lastName = tempName;
    }
    
    tempName = nil;
    tempName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    if (tempName && [tempName length]>0) {
        middleName = tempName;
    }
    
    NSString *phoneNum = @"";
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSInteger count = ABMultiValueGetCount(phoneMulti);
    for (int index = 0;index<count; index++){
        phoneNum = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti,index));
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        break;
    }
    
    CFRelease(phoneMulti);
    
    NSString *address = @"";
    ABMutableMultiValueRef addressMulti = ABRecordCopyValue(person, kABPersonAddressProperty);
    count = ABMultiValueGetCount(addressMulti);
    for (NSInteger index = 0;index<count; index++){
        address = (__bridge NSString *)ABMultiValueCopyValueAtIndex(addressMulti,index);
        break;
    }
    
    CFRelease(addressMulti);

    NSString *email = @"";
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(person, kABPersonEmailProperty);
    count = ABMultiValueGetCount(emailMulti);
    for (NSInteger index = 0;index<count; index++){
        email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailMulti,index);
        break;
    }
    
    CFRelease(emailMulti);

    NSString *message = [NSString stringWithFormat:@"new Person(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",firstName,middleName,lastName,phoneNum,address,email];
    [self writeScript:self.jsCallbackId_ message:message state:0 keepCallback:NO];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    return NO;
}
// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    return NO;
}

@end

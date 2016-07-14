//
//  QWBaseCell.m
//  APP
//
//  Created by Yan Qingyang on 15/3/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseCell.h"


static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

//static const char *getPropertyValueByAttributeType(objc_property_t property, const char *attributeType){
//    if (attributeType==nil) {
//        return nil;
//    }
//    NSString *at=[attributeType uppercaseString];
//    
//    const char *attributes = property_getAttributes(property);
//    NSString *atts=[NSString stringWithUTF8String:attributes];
//    NSArray *arr=[atts componentsSeparatedByString:@","];
//    for (NSString *ss in arr) {
//        NSString *attName=[ss substringToIndex:1];
//        if ([attName isEqualToString:at]) {
//            return [ss substringFromIndex:1];
//        }
//    }
//    return nil;
//}

#pragma mark basecell
@interface QWBaseCell ()
{
    UIColor *colorSelected;
    UIView *vBGSelected;
}
@end

@implementation QWBaseCell

+ (CGFloat)getCellHeight:(id)obj{
    return 40;
}

- (void)setCell:(id)data{
    [self assignByModel:data];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setHighlighted:NO animated:NO];
    [self UIGlobal];
}

#pragma mark - 选择背景颜色
- (void)setSelectedBGColor:(UIColor*)aColor{
    colorSelected=aColor;
    self.selectedBackgroundView = nil;
    //    self.selectedBackgroundView = [[UIView alloc]init];
    //    self.selectedBackgroundView.backgroundColor = aColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    //    DebugLog(@"%i %i",highlighted,animated);
    if (highlighted && colorSelected) {
        vBGSelected=[[UIView alloc]initWithFrame:self.contentView.bounds];
        vBGSelected.backgroundColor=colorSelected;
        [self.contentView addSubview:vBGSelected];
        [self.contentView sendSubviewToBack:vBGSelected];
    }
    else {
        [vBGSelected removeFromSuperview];
        vBGSelected = nil;
    }
}

-  (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

#pragma mark - 全局UI
- (void)UIGlobal{
    CGRect frm=self.bounds;
    //    NSLog(@"%@",NSStringFromCGRect(frm));
    if (_separatorLine==nil) {
        _separatorLine=[[UIView alloc]init];
    }
    
    frm.origin.y=CGRectGetHeight(self.bounds)-0.5f;
    frm.size.height=.5f;
    _separatorLine.frame=frm;
    
    [self.contentView addSubview:_separatorLine];
    [self.contentView bringSubviewToFront:_separatorLine];
    _separatorLine.hidden=self.separatorHidden;
    
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = YES;
    
    
}

- (void)setSeparatorMargin:(CGFloat)margin edge:(Enum_Edge)edge{
    [GLOBALMANAGER setObject:_separatorLine margin:margin edge:edge];
}

#pragma mark - mod传值
- (void)assignByModel:(id)mod{
    if (![mod isKindOfClass:[BaseModel class]]) {
        return;
    }
    
    Class clazz = [self class];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &propertyCount);
    
    for (int i = 0; i < propertyCount; i++)
    {
        //get property
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        const char* propertyType = getPropertyType(property);
        
        NSString *name=[NSString stringWithUTF8String:propertyName];
        NSString *type=[NSString stringWithUTF8String:propertyType];
//        DebugLog(@"property: \n%s ### %@ \n%s \n%@",propertyName,name,property_getAttributes(property),[self getProperty:property attributeType:@"V"]);
        if ([type length] != 1) {
            NSString *nameInstance=[self getProperty:property attributeType:@"V"];
            if (nameInstance==nil) {
                nameInstance=name;
            }
            
            Ivar ivar= class_getInstanceVariable(clazz, [nameInstance UTF8String]);
            id obj = object_getIvar(self, ivar);
            
            NSString *value =[mod valueForKey:name];//[self getValue:name model:mod];
            
            if ([type isEqualToString:@"QWImageView"]) {
                if ([obj respondsToSelector:@selector(setImageURL:)]) {
                    [obj setImageURL:value];
                }
            }
            if ([type isEqualToString:@"QWLabel"]) {
                if ([obj respondsToSelector:@selector(setLabelValue:)]) {
                    [obj setLabelValue:value];
                }
            }
            if ([type isEqualToString:@"QWButton"]) {
                
            }
        }
    }
    free(properties);
    
}

- (NSString*)getValue:(NSString*)key model:(id)mod{
    NSDictionary *dd=[mod dictionaryModel];
    return [dd objectForKey:key];
}


- (NSString *)getProperty:(objc_property_t)property attributeType:(NSString*)attributeType{
    if (attributeType==nil) {
        return nil;
    }
    NSString *at=[attributeType uppercaseString];
    
    const char *attributes = property_getAttributes(property);
    NSString *atts=[NSString stringWithUTF8String:attributes];
    NSArray *arr=[atts componentsSeparatedByString:@","];
    for (NSString *ss in arr) {
        NSString *attName=[ss substringToIndex:1];
        if ([attName isEqualToString:at]) {
            return [ss substringFromIndex:1];
        }
    }
    return nil;
}

@end

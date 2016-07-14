
#ifndef kScreenOnePixelSize
#define kScreenOnePixelSize  1.0f/[[UIScreen mainScreen] scale]
#endif

#define MA_CONSTRAINT_NAME_ONEPIXELHEIGHT @"One Pixel Size"

#define MA_INSTALL_ONEPIXHEIGHT_INTOVIEWS(...) MA_INSTALL_ONEPIXHEIGHT_CONSTRAINTS_INTOVIEWS(1000, MA_CONSTRAINT_NAME_ONEPIXELHEIGHT, __VA_ARGS__)

// Install constraint which height is one pix into a list of views
#define MA_INSTALL_ONEPIXHEIGHT_CONSTRAINTS_INTOVIEWS(PRIORITY, NAME, ...) \
{\
    NSArray* _tmpArray = __VA_ARGS__; \
    for (VIEW_CLASS* VIEW in _tmpArray) \
    {\
        if ([VIEW isKindOfClass:[VIEW_CLASS class]]) \
        { \
            NSLayoutConstraint* constraint; \
            NSLayoutConstraint* tmpConstraint = CONSTRAINT_SETTING_HEIGHT(VIEW, kScreenOnePixelSize); \
            if ((constraint = [VIEW constraintMatchingConstraintWithIgnoreConstant:tmpConstraint])) \
            { \
                constraint.constant = kScreenOnePixelSize; \
            } \
            else \
            { \
                INSTALL_CONSTRAINTS(PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_HEIGHT(VIEW, kScreenOnePixelSize)); \
            } \
        } \
    }\
}


#define MA_INSTALL_ONEPIXWIDTH_INTOVIEWS(...) MA_INSTALL_ONEPIXWIDTH_CONSTRAINTS_INTOVIEWS(1000, MA_CONSTRAINT_NAME_ONEPIXELHEIGHT, __VA_ARGS__)

// Install constraint which width is one pix into a list of views
#define MA_INSTALL_ONEPIXWIDTH_CONSTRAINTS_INTOVIEWS(PRIORITY, NAME, ...) \
{\
    NSArray* _tmpArray = __VA_ARGS__; \
    for (VIEW_CLASS* VIEW in _tmpArray) \
    {\
        if ([VIEW isKindOfClass:[VIEW_CLASS class]]) \
        { \
            NSLayoutConstraint* constraint; \
            NSLayoutConstraint* tmpConstraint = CONSTRAINT_SETTING_WIDTH(VIEW, kScreenOnePixelSize); \
            if ((constraint = [VIEW constraintMatchingConstraintWithIgnoreConstant:tmpConstraint])) \
            { \
                constraint.constant = kScreenOnePixelSize; \
            } \
            else \
            { \
                INSTALL_CONSTRAINTS(PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_WIDTH(VIEW, kScreenOnePixelSize)); \
            } \
        } \
    }\
}






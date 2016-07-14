 

#import <UIKit/UIKit.h>
#import "QWScrollView.h"


@interface QWScrollView_detailView : UIView
{
   __weak QWScrollView * m_superScrollView;
    
//    BOOL isSingleTap;
}

@property (nonatomic , weak) QWScrollView * m_superScrollView;

- (id)initWithFrame:(CGRect)frame scrollView:(QWScrollView *)scrollView;

@end

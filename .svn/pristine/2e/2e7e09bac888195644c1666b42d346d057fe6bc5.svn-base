//
//  QWSearchBaseVC.m
//  APP
//
//  Created by 李坚 on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "QWSearchBaseVC.h"

@interface QWSearchBaseVC ()<UISearchBarDelegate>

@end

@implementation QWSearchBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UISearchBar初始化
    self.searchBarView = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, APP_W - 55, 44)];
    self.searchBarView.tintColor = [UIColor blueColor];
    self.searchBarView.backgroundColor = RGBHex(qwColor1);
    self.searchBarView.placeholder = @"搜索药/病/症/问答";
    self.searchBarView.delegate = self;
    
    //m_searchField获取
    if (iOSv7) {
        UIView* barView = [self.searchBarView.subviews objectAtIndex:0];
        [[barView.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [barView.subviews objectAtIndex:0];
        searchField.font = [UIFont systemFontOfSize:13.0f];
        [searchField setReturnKeyType:UIReturnKeySearch];
        _m_searchField = searchField;
    } else {
        [[self.searchBarView.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [self.searchBarView.subviews objectAtIndex:0];
        searchField.delegate = self;
        searchField.font = [UIFont systemFontOfSize:13.0f];
        [searchField setReturnKeyType:UIReturnKeySearch];
        _m_searchField = searchField;
    }
    
    //取消按钮初始化
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(APP_W - 46, 0, 46, 44)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelButton.titleLabel.font = fontSystem(kFontS1);
    [_cancelButton addTarget:self action:@selector(popVCAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIView初始化
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 44)];
    [_searchView addSubview:_searchBarView];
    [_searchView addSubview:_cancelButton];
    
    _scanBtn = [[UIButton alloc]initWithFrame:CGRectMake(_searchBarView.frame.size.width - 65, 0, 44, 44)];
    [_scanBtn setImage:[UIImage imageNamed:@"ic_btn_scancode"] forState:UIControlStateNormal];
    [_searchBarView addSubview:_scanBtn];
    
    _scanBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:self.searchView];
    //搜索输入框置为焦点
    [_searchBarView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //搜索输入框取消焦点，
    [_searchBarView resignFirstResponder];
    //从NavBar上移除
    [_searchView removeFromSuperview];
    
}

#pragma mark - SearchBarView代理，判断placeHolder词汇是否可以被搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    
    searchBarTextField.enablesReturnKeyAutomatically = YES;
}

#pragma mark - 用户点击键盘搜索，主要用于搜索默认词汇
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarView resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_searchBarView resignFirstResponder];
}

- (void)popVCAction:(id)sender{
    [super popVCAction:sender];  
}


@end

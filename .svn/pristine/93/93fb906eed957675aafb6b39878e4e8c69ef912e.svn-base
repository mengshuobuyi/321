//
//  QWSearchBaseVC.h
//  APP
//
//  Created by 李坚 on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface QWSearchBaseVC : QWBaseVC

//searchBar搜索输入框
@property (strong, nonatomic) UISearchBar *searchBarView;

//取消按钮，调popVCAction方法
@property (strong, nonatomic) UIButton *cancelButton;

//searchBar和取消按钮的容器，用于addSubView到NavBar上
@property (strong, nonatomic) UIView *searchView;

//searchBar上的TextField用于操作字体颜色等属性
@property (strong, nonatomic) UITextField *m_searchField;

//扫码按钮，默认隐藏
@property (strong, nonatomic) UIButton *scanBtn;

- (void)popAction:(id)sender;
#pragma mark - SearchBarView代理，判断placeHolder词汇是否可以被搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar;
#pragma mark - 用户点击键盘搜索，主要用于搜索默认词汇
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
@end

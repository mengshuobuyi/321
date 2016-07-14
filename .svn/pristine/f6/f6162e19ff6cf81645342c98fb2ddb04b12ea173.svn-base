//
//  QW_HelperViewController.m
//  APP
//
//  Created by carret on 15/2/12.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QW_HelperViewController.h"

@interface QW_HelperViewController ()

@end

@implementation QW_HelperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tabled.delegate =self;
    _tabled.dataSource = self;
    [_offOrOn addTarget:self action:@selector(setLOG:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _setCell.textLabel.text = @"是否打开日志";
    return _setCell;
}
-(IBAction)setLOG:(id)sender
{
 
    if (_offOrOn.on == YES) {
        
    }else
    {
        
    }
   
}
@end

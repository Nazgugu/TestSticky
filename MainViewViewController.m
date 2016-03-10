
//
//  MainViewViewController.m
//  TestSticky
//
//  Created by Zhe Liu on 3/9/16.
//  Copyright © 2016 Zhe Liu. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import "MainViewViewController.h"
#import "HMSegmentedControl.h"
#import "Masonry.h"

@interface MainViewViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainScrollViewHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfHeaderConstant;
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableViewScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewScrollViewHeightConstant;
@property (strong, nonatomic) HMSegmentedControl *sectionSegmentedControl;

@property (nonatomic, strong) UITableView *table1;

@property (nonatomic, strong) UITableView *table2;

@property (nonatomic, assign) CGFloat originMainHeight;

@property (nonatomic, assign) CGFloat originTableHeight;

@property (nonatomic, assign) CGRect table1OriginRect;

@property (nonatomic, assign) CGRect table2OriginRect;

@property (nonatomic, assign) CGFloat originHeaderHeight;

@property (nonatomic, assign) CGFloat originContentOffsetTable1;

@property (nonatomic, assign) CGFloat originContentOffsetTable2;

@property (weak, nonatomic) IBOutlet UIImageView *header;

@property (nonatomic, assign) CGFloat table1ContentHeight;

@property (nonatomic, assign) CGFloat table2ContentHeight;

@property (nonatomic, assign) NSInteger table1Ratio;

@property (nonatomic, assign) NSInteger table2Ratio;

@end

@implementation MainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _MainScrollView.tag = 0;
    _tableViewScroll.tag = 1;
    _originMainHeight = self.mainScrollViewHeight.constant;
    _originTableHeight = self.tableViewScrollViewHeightConstant.constant;
    _originHeaderHeight = SCREEN_HEIGHT - self.originMainHeight;
    _originContentOffsetTable1 = 0.0f;
    _originContentOffsetTable2 = 0.0f;
    _table1Ratio = 0;
    _table2Ratio = 0;
    [self setUpViews];
}

- (void)setUpViews
{
    self.MainScrollView.backgroundColor = [UIColor blackColor];
    [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.tableViewScrollViewHeightConstant.constant + 50.0f)];
    [self.tableViewScroll setContentSize:CGSizeMake(SCREEN_WIDTH * 2, self.tableViewScrollViewHeightConstant.constant)];
    self.MainScrollView.delegate = self;
    self.tableViewScroll.delegate = self;
    self.tableViewScroll.pagingEnabled = YES;
    self.tableViewScroll.showsHorizontalScrollIndicator = NO;
//    self.tableViewScroll.layer.borderWidth =  1.0f;
//    self.tableViewScroll.layer.borderColor = [UIColor redColor].CGColor;
//    [self.tableViewScroll scrollRectToVisible:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, self.tableViewScrollViewHeightConstant.constant) animated:NO];
    //segment control
    _sectionSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 50.0f)];
    self.sectionSegmentedControl.sectionTitles = @[@"Now",@"Week"];
    self.sectionSegmentedControl.selectedSegmentIndex = 0;
    self.sectionSegmentedControl.backgroundColor = [UIColor clearColor];
//    if (IOS8)
//    {
//        self.sectionSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.612f green:0.612f blue:0.612f alpha:1.00f], NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
//        self.sectionSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
//    }
//    else
//    {
        self.sectionSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.612f green:0.612f blue:0.612f alpha:1.00f], NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15.0f]};
        self.sectionSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15.0f]};
//    }
    self.sectionSegmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.498f green:0.227f blue:0.780f alpha:1.00f];
    self.sectionSegmentedControl.userDraggable = YES;
    self.sectionSegmentedControl.selectionStyle  = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.sectionSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.sectionSegmentedControl.selectionIndicatorHeight = 3.0f;
    __weak typeof(self) weakSelf = self;
    [self.sectionSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.tableViewScroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, weakSelf.tableViewScrollViewHeightConstant.constant) animated:YES];
    }];
    [self.MainScrollView addSubview:self.sectionSegmentedControl];
    
    //initialize uitableview
    //tableview scroll
    
    _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, self.tableViewScrollViewHeightConstant.constant) style:UITableViewStylePlain];
    _table1 .tag = 3;
    _table1.dataSource = self;
    _table1.delegate = self;
//    [self.table1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.mas_equalTo(0.0f);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//    }];
    
    _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, self.tableViewScrollViewHeightConstant.constant) style:UITableViewStylePlain];
    _table2.tag = 4;
    _table2.dataSource = self;
    _table2.delegate = self;
//    [self.table2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SCREEN_WIDTH);
//        make.top.bottom.mas_equalTo(0.0f);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//    }];
//    _table1.clipsToBounds = YES;
//    _table2.clipsToBounds = YES;
    
    _table1OriginRect = _table1.frame;
    _table2OriginRect = _table2.frame;
    
    [self.tableViewScroll addSubview:self.table1];
    [self.tableViewScroll addSubview:self.table2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getContentSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"table1"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table1"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"table 1: %ld",indexPath.row];
    }
    else if (tableView.tag == 4)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"table2"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table2"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"table 2: %ld",indexPath.row];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getContentSize
{
    self.table1ContentHeight = self.table1.contentSize.height;
    self.table2ContentHeight = self.table2.contentSize.height;
    NSLog(@"table 1 content height: %lf, table scroll height constant: %lf", self.table1ContentHeight, self.tableViewScrollViewHeightConstant.constant);
    if ((self.originHeaderHeight - (self.table1ContentHeight - self.tableViewScrollViewHeightConstant.constant) / 2.0f) >= 64.0f)
    {
        NSLog(@"ration will be two");
        self.table1Ratio = 2;
    }
    if ((self.originHeaderHeight - (self.table1ContentHeight - self.tableViewScrollViewHeightConstant.constant) / 2.0f) >= 64.0f)
    {
        self.table2Ratio = 2;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 3)
    {
//        NSLog(@"table 1");
        NSLog(@"table1 content height: %lf, table2 content heigh: %lf",self.table1ContentHeight, self.table2ContentHeight);
        ////
        ///
        ////
        //need to add condition to check before setting new frame!!!
        ///
        ////
        ///
        ///
        self.originContentOffsetTable1 = scrollView.contentOffset.y;
        CGFloat ratio = 1;
        if (self.table1Ratio != 0)
        {
            ratio = (CGFloat)self.table1Ratio;
        }
        if (scrollView.contentOffset.y != self.originContentOffsetTable2)
        {
            if (scrollView.contentOffset.y > 0.0f && ((self.originHeaderHeight - scrollView.contentOffset.y * ratio) >= 64.0f))
            {
                
                NSLog(@"original height: %lf, table 1 offset y: %lf, difference: %lf",self.originHeaderHeight ,scrollView.contentOffset.y, self.originHeaderHeight - scrollView.contentOffset.y);
                self.mainScrollViewHeight.constant = self.originMainHeight + scrollView.contentOffset.y * ratio;
                self.tableViewScrollViewHeightConstant.constant = self.originTableHeight + scrollView.contentOffset.y * ratio;
                [self.table1 setFrame:CGRectMake(0.0f, 0.0f, self.table1OriginRect.size.width, self.table1OriginRect.size.height + scrollView.contentOffset.y * ratio)];
                [self.table2 setFrame:CGRectMake(SCREEN_WIDTH, 0.0f, self.table2OriginRect.size.width, self.table1OriginRect.size.height + scrollView.contentOffset.y * ratio)];
                
                //            [self.table2 setContentOffset:CGPointMake(0.0f, self.originContentOffsetTable2)];
            }
        }
    }
    else if (scrollView.tag == 4)
    {
        //table 2
        CGFloat ratio = 1;
        if (self.table2Ratio != 0)
        {
            ratio = (CGFloat)self.table2Ratio;
        }
        ////
        ///
        ////
        //need to add condition to check before setting new frame!!!
        ///
        ////
        ///
        ///
        self.originContentOffsetTable2 = scrollView.contentOffset.y;
        if (scrollView.contentOffset.y != self.originContentOffsetTable1)
        {
            if (scrollView.contentOffset.y > 0.0f && ((self.originHeaderHeight - scrollView.contentOffset.y * ratio) >= 64.0f))
            {
                self.mainScrollViewHeight.constant = self.originMainHeight + scrollView.contentOffset.y * ratio;
                self.tableViewScrollViewHeightConstant.constant = self.originTableHeight + scrollView.contentOffset.y * ratio;
                [self.table1 setFrame:CGRectMake(0.0f, 0.0f, self.table1OriginRect.size.width, self.table1OriginRect.size.height + scrollView.contentOffset.y * ratio)];
                [self.table2 setFrame:CGRectMake(SCREEN_WIDTH, 0.0f, self.table2OriginRect.size.width, self.table1OriginRect.size.height + scrollView.contentOffset.y * ratio)];
                //            [self.table1 setContentOffset:CGPointMake(0.0f, self.originContentOffsetTable1)];
                //            NSLog(@"table 2 offset y: %lf",scrollView.contentOffset.y * ratio);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [self.sectionSegmentedControl setSelectedSegmentIndex:page animated:YES];
    }
    else if (scrollView.tag == 0)
    {
        NSLog(@"scrollview 2, offset: %lf", scrollView.contentOffset.y);
    }
}

@end

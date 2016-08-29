//
//  ViewController.m
//  CustomMultipleSelect-master
//
//  Created by 黄海燕 on 16/8/29.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "HYModel.h"
#import "HYCustomCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_selectArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"自定义多选";
    [self creatDataSource];
    [self creatTableView];
    [self creatNavigationBarItem];
    
    _selectArray = [[NSMutableArray alloc]init];
}

-(void)creatDataSource
{
    //先实例化数据源
    _dataArray = [[NSMutableArray alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int z = 0; z<20; z++) {
        
        NSString *string = [NSString stringWithFormat:@"title第%d行",z];
        NSString *subString = [NSString stringWithFormat:@"subTitlt第%d行",z];
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict = @{@"title":string,@"subTitle":subString};
        
        [array addObject:dict];
        //NSLog(@"%@",array);
    }
    
    for (NSDictionary *dict in array) {
        HYModel *model = [[HYModel alloc]init];
        model.titleStr = dict[@"title"];
        model.subTitleStr = dict[@"subTitle"];
        [_dataArray addObject:model];
    }
    //NSLog(@"%@",_dataArray);
}

-(void)creatNavigationBarItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 10, 30, 20);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(addSelectAarray) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)addSelectAarray{
    [_selectArray removeAllObjects];
    NSArray *array1 = [[NSMutableArray alloc]initWithArray:[_tableView indexPathsForSelectedRows]];
    //给这个数组按照倒序排序
    [array1 sortedArrayUsingSelector:@selector(compare:)];
//    //逆向遍历
//    NSEnumerator *enumerator = [array1 reverseObjectEnumerator];
//    array1 = (NSMutableArray*)[enumerator allObjects];
//
//    NSLog(@"%@",array1);
    
    //遍历这个数组
    for (NSInteger b = array1.count - 1; b >= 0; b--) {
        //根据b在数组里面的位置 定位到到底是哪一行
        NSIndexPath *indexPath = array1[b];
        HYModel *model = _dataArray[indexPath.row];
        [_selectArray addObject:model.titleStr];
    }
    NSLog(@"%@",_selectArray);

}

-(void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    //分割线的样式
    _tableView.allowsMultipleSelection = YES;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
}

//应该让这个tableview 每组显示多少行数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"HYCustomCell"];
    if (customCell == nil) {
        customCell = [[[NSBundle mainBundle] loadNibNamed:@"HYCustomCell" owner:self options:nil] firstObject];
    }
    customCell.selectionStyle = UITableViewCellSelectionStyleNone;//这个设置使点击cell的时候没有点击效果了
    HYModel *model = _dataArray[indexPath.row];
    customCell.title.text = model.titleStr;
    customCell.subtitle.text = model.subTitleStr;
    
    if (model.selected) {
        
        customCell.image.hidden = NO;
    }else{
        customCell.image.hidden = YES;
    }

    return customCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYModel *model = _dataArray[indexPath.row];
    HYCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    model.selected = !model.selected;
    
    if (model.selected) {
        
        cell.image.hidden = NO;
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYModel *model = _dataArray[indexPath.row];
    HYCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    model.selected = !model.selected;
    if (!model.selected) {
        cell.image.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MainViewController.m
//  KSTableView
//
//  Created by xiaoshi on 2017/2/17.
//  Copyright © 2017年 xiaoshi. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewCell.h"

#import "KSTableViewController.h"

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;
@end

static CGFloat lineSpace = 10;
static CGFloat itemSpace = 15;
static NSString *identifier = @"MainViewCell";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //命名遵守，名字后加上Controller为类名，数组里面是前面的部分
    self.dataArray = @[@"KSTableView", @"KSTableView", @"KSTableView", @"KSTableView"];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MainViewCell alloc] init];
    }
    cell.imageView.image = [self getImage:self.dataArray[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.frame.size.width - lineSpace*3)/2;
    
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [NSString stringWithFormat:@"%@Controller", self.dataArray[indexPath.item]];
    Class class = NSClassFromString(className);
    UIViewController *vc = [class new];
    vc.navigationItem.title = className;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = lineSpace;
        //layout.minimumInteritemSpacing = itemSpace;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [_collectionView registerClass:[MainViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UIImage *)getImage:(NSString *)name
{
    CGFloat width = (self.view.frame.size.width - itemSpace)/2 - itemSpace;
    UIColor *color = [self randomColor];  //获取随机颜色
    CGRect rect = CGRectMake(0.0f, 0.0f, width, width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //NSString *headerName = nil;
    NSString *headerName = name;
    /*if (name.length < 3) {
        headerName = name;
    }else{
        headerName = [name substringFromIndex:name.length-2];
    }*/
    UIImage *headerimg = [self imageToAddText:img withText:headerName];
    return headerimg;
}

//随机颜色
- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

//把文字绘制到图片上
- (UIImage *)imageToAddText:(UIImage *)img withText:(NSString *)text
{
    //1.获取上下文
    UIGraphicsBeginImageContext(img.size);
    //2.绘制图片
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //3.绘制文字
    CGRect rect = CGRectMake(0,(img.size.height-45)/2, img.size.width, 25);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor whiteColor]};
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    //4.获取绘制到得图片
    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImg;
}

@end

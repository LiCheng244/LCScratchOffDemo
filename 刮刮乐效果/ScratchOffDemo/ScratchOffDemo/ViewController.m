//
//  ViewController.m
//  ScratchOffDemo
//
//  Created by LiCheng on 16/7/6.
//  Copyright © 2016年 Li_Cheng. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
}

#pragma mark - 创建子视图
- (void)createSubViews {
    
    /**
            注意:
        1. 这两个控件的位置要相同
        2. 一定要先创建下面的label, 再创建图片
     */
    
    // 展示刮出来的效果的view
    UILabel *labelL        = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 200)];
    labelL.text            = @"刮刮乐效果展示";
    labelL.numberOfLines   = 0;
    labelL.backgroundColor = [UIColor brownColor];
    labelL.font            = [UIFont systemFontOfSize:30];
    labelL.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:labelL];
    
    // 被刮的图片
    self.imageView       = [[UIImageView alloc] initWithFrame:labelL.frame];
    self.imageView.image = [UIImage imageNamed:@"222.jpg"];
    [self.view addSubview:self.imageView];
    
    

    //图片添加文字水印
    self.imageView.image = [self image:_imageView.image addText:@"文字水印" msakRect:CGRectMake(10, 55, 130, 80)];
    //图片添加图片水印
    self.imageView.image = [self image:_imageView.image addMsakImage:[UIImage imageNamed:@"222.jpg"] msakRect:CGRectMake(0, 0, 130, 80)];
}

#pragma mark - 刮刮乐效果
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 触摸任意位置
    UITouch *touch = touches.anyObject;
    // 触摸位置在图片上的坐标
    CGPoint cententPoint = [touch locationInView:self.imageView];
    // 设置清除点的大小
    CGRect  rect = CGRectMake(cententPoint.x, cententPoint.y, 20, 20);
    // 默认是去创建一个透明的视图
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
    // 获取上下文(画板)
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 把imageView的layer映射到上下文中
    [self.imageView.layer renderInContext:ref];
    // 清除划过的区域
    CGContextClearRect(ref, rect);
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图片的画板, (意味着图片在上下文中消失)
    UIGraphicsEndImageContext();
    
    self.imageView.image = image;
    
}

#pragma mark - 给图片添加文字水印
- (UIImage *)image:(UIImage *)image addText:(NSString *)mark msakRect:(CGRect)rect{
    
    int w = image.size.width;
    int h = image.size.height;
    UIGraphicsBeginImageContext(image.size);
    [[UIColor redColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    NSMutableDictionary *dict            = [NSMutableDictionary dictionary];//改写字体属性
    dict[NSFontAttributeName]            = [UIFont systemFontOfSize:30];//字号
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];//颜色
    dict[NSStrokeWidthAttributeName]     = @5;//空心
    [mark drawInRect:rect withAttributes:dict];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 为图片添加图片水印
- (UIImage *)image:(UIImage *)image addMsakImage:(UIImage *)maskImage msakRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //四个参数为水印图片的位置
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end

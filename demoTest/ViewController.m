//
//  ViewController.m
//  demoTest
//
//  Created by 张艳楠 on 2017/2/25.
//  Copyright © 2017年 zhang yannan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#define angleToRadion(angle) (angle / 180.0 * M_PI)
#define screenWidth self.view
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) IBOutlet UITextField *textFiled;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIButton *animateButton;
@property(assign,nonatomic) CGPoint startPoint;
@property(assign,nonatomic) CGPoint touchPoint;
@property(strong,nonatomic) CAReplicatorLayer *repeatLayer;
@property(strong,nonatomic)CABasicAnimation *scaleAnimation;
@property(nonatomic,assign) int imagesCount;
@end

@implementation ViewController
-(CABasicAnimation *)scaleAnimation{
    if (_scaleAnimation==nil) {
        _scaleAnimation=[CABasicAnimation animation];
    }
    return _scaleAnimation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置图层的宽高为正方形
//    self.view
//    [self.view addSubview:self.grayView];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_width);
    }];
    
    
    [self.button addTarget:self action:@selector(drawImageView) forControlEvents:UIControlEventTouchUpInside];
    [self.animateButton addTarget:self action:@selector(rotationAnimation) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 设置每个图案的位置
-(void)drawImageView{
    //在绘制之前先把复制图层删除，用到的时候在创建
    [self.repeatLayer removeFromSuperlayer];
    [self.view endEditing:YES];
    [self.grayView endEditing:YES];
    self.imagesCount=[self.textFiled.text intValue];
    //（再次）创建复制图层
    self.repeatLayer=[CAReplicatorLayer layer];
    self.repeatLayer.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    
    [self.grayView.layer addSublayer:self.repeatLayer];
    //创建UIImageView对象
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"多啦a梦-电影票"];
    imageView.layer.position=CGPointMake(self.grayView.bounds.size.width/2, 60);
    //确定图层大小
    imageView.layer.bounds=CGRectMake(0, 0, 30, 30);
    [self.repeatLayer addSublayer:imageView.layer];
    CGFloat angle=M_PI * 2 / self.imagesCount;
    //设置子层个数
    self.repeatLayer.instanceCount=self.imagesCount;
    self.repeatLayer.instanceTransform=CATransform3DMakeRotation(angle, 0, 0, 1);
}
#pragma mark 设置旋转动画
-(void)rotationAnimation{
    //移除所有动画
    [self.repeatLayer removeAllAnimations];
    //设置旋转动画让复制图层绕着自己的中心点旋转
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animation];
    animation.keyPath=@"transform.rotation";
    animation.duration=5;
    animation.values=@[@(angleToRadion(0)),@(angleToRadion(360))];
    animation.repeatCount=MAXFLOAT;
    [self.repeatLayer addAnimation:animation forKey:nil];
}
#pragma mark 开始触摸
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    //获取手势的触摸点
    CGPoint point=[touch locationInView:self.view];
//    NSLog(@"%f---%f",point.x,point.y);
    self.startPoint=point;
    
}
#pragma mark 移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    //获取手势的触摸点
    self.touchPoint=[touch locationInView:self.view];
//    NSLog(@"%f---%f",point.x,point.y);
    /*
        以self.view的中心点横坐标为基准与拖动的坐标点相减，如果差值>0,进行放大，小于0，缩小
     */
    //计算屏幕宽度的一半
    CGFloat halfWidth=self.view.frame.size.width/2;
    //手指在屏幕上移动的距离
    double difference=self.touchPoint.x-self.startPoint.x;
    //要缩放的比例
    CGFloat per=difference/halfWidth;
    NSLog(@"缩放比例为：%f",per);
        //此时手势向右滑动
//        CABasicAnimation *animaition=[CABasicAnimation animation];
        self.scaleAnimation.keyPath=@"transform.scale";
//        self.scaleAnimation.fromValue=@1;
        self.scaleAnimation.toValue=@(per+1);
        //动画完成之后不要移除动画
        self.scaleAnimation.removedOnCompletion=NO;
        //动画执行完毕显示最新的效果
        self.scaleAnimation.repeatCount=0;
        self.scaleAnimation.fillMode=kCAFillModeForwards;
        [self.grayView.layer addAnimation:self.scaleAnimation forKey:nil];
}
#pragma mark 触摸结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获得触摸结束的时候的坐标点
    
}
#pragma mark 触摸取消
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

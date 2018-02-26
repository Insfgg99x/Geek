
//
//  UINavigationController+Push.m
//  LCCar
//
//  Created by xia on 2017/11/4.
//

#import "UINavigationController+Push.h"
#import <objc/runtime.h>

@implementation UINavigationController (Push)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1=class_getInstanceMethod([self class], @selector(pushViewController:animated:));
        Method m2=class_getInstanceMethod(self, @selector(lc_pushViewController:animated:));
        method_exchangeImplementations(m1, m2);
    });
}
//automatic hide tabbar when pushed
-(void) lc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *controllers=self.viewControllers;
    if(controllers.count>0){
        if(controllers.count==1){
            UIViewController *current=controllers.firstObject;
            current.hidesBottomBarWhenPushed=YES;
            [self lc_pushViewController:viewController animated:animated];
            current.hidesBottomBarWhenPushed=NO;
        }else{
            UIViewController *current=controllers.lastObject;
            current.hidesBottomBarWhenPushed=YES;
            [self lc_pushViewController:viewController animated:animated];
        }
    }else{        
        [self lc_pushViewController:viewController animated:animated];
    }
}


@end

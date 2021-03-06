
#import <UIKit/UIKit.h>

/**
 显示时动画弹框样式
 */
//  @{@"title" : @"卡片式掉落动画(从左侧)", @"style" : @6},
//@{@"title" : @"卡片式掉落动画(从右侧)", @"style" : @7},
//@{@"title" : @"卡片式掉落动画(往顶部平滑消失)", @"style" : @8},
//@{@"title" : @"从顶部掉落晃动动画", @"style" : @2},
//@{@"title" : @"从底部掉落晃动动画", @"style" : @3},
//@{@"title" : @"从左侧掉落晃动动画", @"style" : @4},
//@{@"title" : @"从右侧掉落晃动动画", @"style" : @5},
//@{@"title" : @"缩放动画", @"style" : @1},
//@{@"title" : @"无动画", @"style" : @0}
typedef NS_ENUM(NSInteger, ZJAnimationPopStyle) {
    ZJAnimationPopStyleNO = 0,               ///< 无动画
    ZJAnimationPopStyleScale,                ///< 缩放动画，先放大，后恢复至原大小
    ZJAnimationPopStyleShakeFromTop,         ///< 从顶部掉下到中间晃动动画
    ZJAnimationPopStyleShakeFromBottom,      ///< 从底部往上到中间晃动动画
    ZJAnimationPopStyleShakeFromLeft,        ///< 从左侧往右到中间晃动动画
    ZJAnimationPopStyleShakeFromRight,       ///< 从右侧往左到中间晃动动画
    ZJAnimationPopStyleCardDropFromLeft,     ///< 卡片从顶部左侧开始掉落动画
    ZJAnimationPopStyleCardDropFromRight,    ///< 卡片从顶部右侧开始掉落动画
};

/**
 移除时动画弹框样式
 */
typedef NS_ENUM(NSInteger, ZJAnimationDismissStyle) {
    ZJAnimationDismissStyleNO = 0,               ///< 无动画
    ZJAnimationDismissStyleScale,                ///< 缩放动画
    ZJAnimationDismissStyleDropToTop,            ///< 从中间直接掉落到顶部
    ZJAnimationDismissStyleDropToBottom,         ///< 从中间直接掉落到底部
    ZJAnimationDismissStyleDropToLeft,           ///< 从中间直接掉落到左侧
    ZJAnimationDismissStyleDropToRight,          ///< 从中间直接掉落到右侧
    ZJAnimationDismissStyleCardDropToLeft,       ///< 卡片从中间往左侧掉落
    ZJAnimationDismissStyleCardDropToRight,      ///< 卡片从中间往右侧掉落
    ZJAnimationDismissStyleCardDropToTop,        ///< 卡片从中间往顶部移动消失
};

@interface ZJAnimationPopView : UIView

/** 显示时点击背景是否移除弹框，默认为NO。 */
@property (nonatomic) BOOL isClickBGDismiss;
/** 显示时是否监听屏幕旋转，默认为NO */
@property (nonatomic) BOOL isObserverOrientationChange;
/** 显示时背景的透明度，取值(0.0~1.0)，默认为0.5 */
@property (nonatomic) CGFloat popBGAlpha;
@property (nonatomic , strong) UIImageView *headImage;

/// 动画相关属性参数
/** 显示时动画时长，>= 0。不设置则使用默认的动画时长 */
@property (nonatomic) CGFloat popAnimationDuration;
/** 隐藏时动画时长，>= 0。不设置则使用默认的动画时长 */
@property (nonatomic) CGFloat dismissAnimationDuration;
/** 显示完成回调 */
@property (nullable, nonatomic, copy) void(^popComplete)();
/** 移除完成回调 */
@property (nullable, nonatomic, copy) void(^dismissComplete)();

/**
 通过自定义视图来构造弹框视图
 
 @param customView 自定义视图
 */
- (nullable instancetype)initWithCustomView:(UIView *_Nonnull)customView
                                   popStyle:(ZJAnimationPopStyle)popStyle
                               dismissStyle:(ZJAnimationDismissStyle)dismissStyle;

/**
 显示弹框
 */
- (void)pop;

/**
 移除弹框
 */
- (void)dismiss;

@end

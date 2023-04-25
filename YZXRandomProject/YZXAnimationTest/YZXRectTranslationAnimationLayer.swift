//
//  YZXRectTranslationAnimationLayer.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/4/25.
//

import Foundation
import QuartzCore
import UIKit

class YZXRectTranslationAnimationLayer: CAShapeLayer {
    
    //MARK: - data
    /// 一个动画执行的最小宽度（必须）
    var oneAnimationMinWidth: CGFloat = 0.0
    
    /// 动画执行时间（默认0.3s）
    var animationDuration: CGFloat = 0.3
    
    /// 动画默认path的frame
    var animationDefaultPathFrame: CGRect = .zero {
        didSet {
            let bezierPath = UIBezierPath(roundedRect: animationDefaultPathFrame, cornerRadius: animationDefaultPathFrame.height / 2.0)
            path = bezierPath.cgPath
        }
    }
    
    // -------------------- 私有属性 --------------------
    private var displayLink: CADisplayLink?
    
    /// 上一步动画的时间
    private var animationBeginTime: TimeInterval = 0.0
    
    /// path动画开始的位置
    private var fromRect: CGRect = .zero
    
    /// path动画最终的位置
    private var toRect: CGRect = .zero
    
    /// 圆1的中心点
    private var center1: CGPoint = .zero

    /// 圆2的中心点
    private var center2: CGPoint = .zero

    /// 圆1的半径
    private var r1: CGFloat = .zero

    /// 圆2的半径
    private var r2: CGFloat = .zero;

    /// control point P
    private var pointP: CGPoint = .zero

    /// control point O
    private var pointO: CGPoint = .zero

    /// 默认path的高度（静止时，path的高度）
    private var defaultHeight: CGFloat = 0.0
    //MARK: - ---------------------- data END ----------------------

    //MARK: - 公用方法
    /// 开始动画 （需要其他值设置成功后才可调用）
    /// - Parameters:
    ///   - fromRect: 动画开始的位置
    ///   - toRect: 动画结束的位置
    func starstartAnimation(fromRect: CGRect, toRect: CGRect) {
        guard let _ = path else {
            assert(path != nil, "请设置动画开始前的 path")
            return
        }
        
        guard oneAnimationMinWidth > 0.0 else {
            assert(oneAnimationMinWidth != 0.0, "请设置 oneAnimationMinWidth")
            return
        }
        
        guard animationDuration > 0.0 else {
            assert(animationDuration != 0.0, "请设置 动画执行时间")
            return
        }
        
        defaultHeight = UIBezierPath(cgPath: path!).bounds.size.height
        
        self.fromRect = fromRect
        self.toRect = toRect
        
        // 右滑动
        if fromRect.minX < toRect.minX {
            center1 = CGPoint(x: fromRect.minX + defaultHeight / 2.0, y: fromRect.midY)
            center2 = CGPoint(x: fromRect.maxX - defaultHeight / 2.0, y: fromRect.midY)
        }else {  // 左滑动
            center1 = CGPoint(x: fromRect.maxX - defaultHeight / 2.0, y: fromRect.midY)
            center2 = CGPoint(x: fromRect.minX + defaultHeight / 2.0, y: fromRect.midY)
        }
        pointP = CGPoint(x: fromRect.midX, y: fromRect.minY)
        pointO = CGPoint(x: fromRect.midX, y: fromRect.maxY)
        r1 = defaultHeight / 2.0
        r2 = defaultHeight / 2.0
        
        p_startAnimation()
    }
    //MARK: - ---------------------- 公用方法 END ----------------------
    
    //MARK: - CADisplayLink
    private func p_startAnimation() {
        p_stopAnimation()
        animationBeginTime = CACurrentMediaTime()
        
        displayLink = CADisplayLink(target: self, selector: #selector(step(sender:)))
        displayLink?.add(to: RunLoop.main, forMode: .common)
        displayLink?.isPaused = false
    }
    
    private func p_stopAnimation() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func step(sender: CADisplayLink) {
        // 当前时间
        let this_time = CACurrentMediaTime()
        // 动画已执行时间
        let animation_time = this_time - animationBeginTime
        
        p_animationCircleCenterAndRadius(animationTime: animation_time)
        p_animationControlPoint(animationTime: animation_time)
        
        // 是否向右移动
        let is_move_to_right = toRect.minX > fromRect.minX
        // 动画时间大于等于动画执行时长，结束动画
        if animation_time >= animationDuration {
            if is_move_to_right {
                r1 = defaultHeight / 2.0
                r2 = defaultHeight / 2.0
                center1 = CGPoint(x: toRect.minX + defaultHeight / 2.0, y: center1.y)
                center2 = CGPoint(x: toRect.maxX - defaultHeight / 2.0, y: center2.y)
            }else {
                r1 = defaultHeight / 2.0
                r2 = defaultHeight / 2.0
                center1 = CGPoint(x: toRect.maxX - defaultHeight / 2.0, y: center1.y)
                center2 = CGPoint(x: toRect.minX + defaultHeight / 2.0, y: center2.y)
            }
            pointP = CGPoint(x: toRect.midX, y: toRect.minY)
            pointO = CGPoint(x: toRect.midX, y: toRect.maxY)
            p_stopAnimation()
        }
        
        path = p_reloadBeziePath().cgPath
    }
    //MARK: - ---------------------- CADisplayLink END ----------------------
    
    //MARK: - 动画拆解
    /**
     绘制path时，计算左右两个圆的中心点和半径
     在计算时，首先确定x轴变换多宽为一个变化循环（及设置的oneAnimationMinWidth），再通过framRect和toRect确定执行整个动画所需的总宽度，从而计算出一个变换循环所需的时间，然后将这一个变化循环，分成3个步骤：
     第一个1/3的时间内，r1：由 总高度1 -> 2/3总高度，r2：由 总高度1 -> 1/3总高度
     第二个1/3的时间内，r1：由 2/3总高度 -> 1/3总高度，r2：由 1/3总高度 -> 2/3总高度
     第三个1/3的时间内，r1：由 1/3总高度 ->  总高度1，r2：由 2/3总高度 -> 总高度1
     */
    private func p_animationCircleCenterAndRadius(animationTime: CGFloat) {
        // 是否向右移动
        let is_move_to_right = toRect.minX > fromRect.minX
        
        /**
         x轴，动画执行路程
         */
        // x轴，总动画执行的宽度
        let total_animation_width = abs(toRect.minX - fromRect.minX)
        // x轴，一个动画执行的宽度
        let one_animation_width = oneAnimationMinWidth / 3.0
        // 动画个数
        let animation_number = Int(total_animation_width / one_animation_width)
        
        /**
         y轴，动画执行路程
         */
        // y轴，最大变化高度（即两个圆最大的半径）
        let y_animation_height = defaultHeight / 2.0
        // y轴，1/3 个最大变化高度 （一个动画可能执行的高度是组动画高度的1/3或者2/3）
        let y_1_3_animation_height = y_animation_height / 3.0
        // y轴，2/3 个最大变化高度
        let y_2_3_animation_height = y_animation_height / 3.0 * 2.0
        
        /**
         动画执行时间
         */
        // 一个动画执行的总时间
        let one_animation_time = animationDuration / CGFloat(animation_number)
        
        /**
         动画执行速度
         */
        // x轴，一个动画执行的速度
        let velocity_x = one_animation_width / one_animation_time
        // y轴，1/3 个组动画高度，在一个动画执行时间内的速度
        let velocity_1_3_y = y_1_3_animation_height / one_animation_time
        // y轴，2/3 个组动画高度，在一个动画执行时间内的速度
        let velocity_2_3_y = y_2_3_animation_height / one_animation_time
        
        // x轴，一定时间内执行的距离
        let x_animation_distance = is_move_to_right ? (animationTime * velocity_x) : -(animationTime * velocity_x)
        // x轴，开始的坐标
        let startX1 = is_move_to_right ? (fromRect.minX + defaultHeight / 2.0) : (fromRect.maxX - defaultHeight / 2.0)
        let startX2 = is_move_to_right ? (fromRect.maxX - defaultHeight / 2.0) : (fromRect.minX + defaultHeight / 2.0)
        // x轴，变化后的坐标
        center1 = CGPoint(x: startX1 + x_animation_distance, y: center1.y)
        center2 = CGPoint(x: startX2 + x_animation_distance, y: center2.y)
        
        // x轴，获取当前执行的第几个动画（下标从0开始）
        let animation_index = Int(abs(x_animation_distance) / one_animation_width)
        // y轴，每执行一个动画，将时间从0开始重新计算
        let perUnitTime = (animationTime - one_animation_time * CGFloat(animation_index))
        /**
         一组动画分为3个动画，
         第一个1/3的时间，r1：由 总高度1 -> 2/3总高度，r2：由 总高度1 -> 1/3总高度
         第二个1/3的时间，r1：由 2/3总高度 -> 1/3总高度，r2：由 1/3总高度 -> 2/3总高度
         第三个1/3的时间，r1：由 1/3总高度 ->  总高度1，r2：由 2/3总高度 -> 总高度1
         */
        if animation_index % 3 == 0 {
            r1 = y_animation_height - velocity_1_3_y * perUnitTime
            r2 = y_animation_height - velocity_2_3_y * perUnitTime
        }else if animation_index % 3 == 1 {
            r1 = y_2_3_animation_height - velocity_1_3_y * perUnitTime
            r2 = y_1_3_animation_height + velocity_1_3_y * perUnitTime
        }else {
            r1 = y_1_3_animation_height + velocity_2_3_y * perUnitTime
            r2 = y_2_3_animation_height + velocity_1_3_y * perUnitTime
        }
    }
    
    /**
     绘制path时，计算上面曲线和下面曲线的控制点随时间的变化
     在计算时，首先确定x轴变换多宽为一个变化循环（及设置的oneAnimationMinWidth），再通过framRect和toRect确定执行整个动画所需的总宽度，从而计算出一个变换循环所需的时间，然后将这一个变化循环，分成2个步骤：
     首先：P点和O点，x轴坐标随着时间一直变换匀速变化
      y轴：
     第一个1/2的时间，P点 + 变化高度，O点 - 变化高度，最终让P点，O点在圆中心点y轴的上下1/4半径位置
     第二个1/2的时间，P点 - 变化高度，O点 + 变化高度，最终让P点，O点在圆中心点y轴的上下1半径位置
     */
    func p_animationControlPoint(animationTime: CGFloat) {
        // 是否向右移动
        let is_move_to_right = toRect.minX > fromRect.minX
        /**
         x轴，动画执行路程
         */
        // x轴，总动画执行的宽度
        let total_animation_width = abs(toRect.minX - fromRect.minX)
        /**
         y轴，动画执行路程
         */
        // y轴，最大变化高度（即两个圆最大的半径）
        let y_animation_height = defaultHeight / 2.0
        /**
         计算控制点动画
         */
        // x轴，控制点一个动画执行的宽度
        let control_point_animation_width = oneAnimationMinWidth / 2.0
        // 控制点，y轴，最大变化高度
        let control_point_y_change_max_height = y_animation_height / 4.0 * 3.0
        // 控制点，动画个数
        let control_point_animation_number = Int(total_animation_width / control_point_animation_width)
        // 控制点，一个动画执行的时间
        let control_point_one_animation_time = animationDuration / CGFloat(control_point_animation_number)
        // 控制点，x轴，1/2 个组动画宽度，在一个动画执行时间内的速度
        let control_point_velocity_x = control_point_animation_width / control_point_one_animation_time
        // 控制点，y轴，最大变化高度一个动画执行的速度
        let control_point_velocity_y = control_point_y_change_max_height / control_point_one_animation_time
        // 控制点，x轴，一定时间内执行的距离
        let control_point_x_animation_distance = animationTime * control_point_velocity_x
        // 控制点，x轴，获取当前执行的第几个动画（下标从0开始）
        let control_point_animation_index = Int(abs(control_point_x_animation_distance) / control_point_animation_width)
        // 控制点，y轴，每执行一个动画，将时间从0开始重新计算
        let control_point_per_unit_time = (animationTime - control_point_one_animation_time * CGFloat(control_point_animation_index))
        // 控制点，一个动画开始时，P点和O点开始的x，y坐标
        let startPX = fromRect.midX
        let startPY = fromRect.minY
        let startOY = fromRect.maxY
        // 控制点，x轴，变化的距离，右移时+，左移时-
        let control_point_x_change_distance = is_move_to_right ? control_point_x_animation_distance : -control_point_x_animation_distance
        let control_point_y_change_distance = control_point_per_unit_time * control_point_velocity_y
        /**
         一组动画分为2个动画，P点和O点，x轴坐标随着时间一直变换 （最大变化高度control_point_y_change_max_height）
         第一个1/2的时间，y轴，P点 + 变化高度，O点 - 变化高度
         第二个1/2的时间，y轴，和上一个动画正好相反
         */
        if control_point_animation_index % 2 == 0 {
            pointP = CGPoint(x: startPX + control_point_x_change_distance, y: startPY + control_point_y_change_distance)
            pointO = CGPoint(x: pointP.x, y: startOY - control_point_y_change_distance)
        }else {
            pointP = CGPoint(x: startPX + control_point_x_change_distance, y: startPY + control_point_y_change_max_height - control_point_y_change_distance)
            pointO = CGPoint(x: pointP.x, y: startOY - control_point_y_change_max_height + control_point_y_change_distance)
        }
    }
    //MARK: - ---------------------- 动画拆解 END ----------------------
    
    //MARK: - 生成path
    private func p_reloadBeziePath() -> UIBezierPath {
        let is_move_right = center1.x < center2.x;
        let pointA = CGPoint(x: center1.x, y: center1.y + (is_move_right ? r1 : -r1))
        let pointB = CGPoint(x: center1.x, y: center1.y - (is_move_right ? r1 : -r1))
        let pointC = CGPoint(x: center2.x, y: center2.y - (is_move_right ? r2 : -r2))
        let pointD = CGPoint(x: center2.x, y: center2.y + (is_move_right ? r2 : -r2))

        let path = UIBezierPath()
        path.move(to: pointA)
        path.addArc(withCenter: center1, radius: r1, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.addLine(to: pointB)
        path.addQuadCurve(to: pointC, controlPoint: is_move_right ? pointP : pointO)
        path.addArc(withCenter: center2, radius: r2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.addLine(to: pointD)
        path.addQuadCurve(to: pointA, controlPoint: is_move_right ? pointO : pointP)
        return path
    }
    //MARK: - ---------------------- 生成path END ----------------------
}

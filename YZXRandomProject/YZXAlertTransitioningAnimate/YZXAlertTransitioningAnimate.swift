//
//  YZXAlertTransitioningAnimate.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/5/5.
//

import Foundation
import UIKit

enum YZXAlertTransitioningAnimationStyle {
    case popUp               // 从中间弹出
    case popOutFromBottom    // 从底部弹出
}

class YZXAlertTransitioningAnimate: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    /// 动画执行时间
    var transitionDuration: TimeInterval?
    
    /// 动画类型
    var animationStyle = YZXAlertTransitioningAnimationStyle.popUp
    
    /// 展现alert时，背景mask的alpha值，默认 0.3
    var maskViewAlpha = 0.3

    private(set) lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration ?? 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        toViewController.view.frame = transitionContext.containerView.frame
        maskView.frame = toViewController.view.bounds
        if toViewController.isBeingPresented {
            maskView.alpha = 0.0
            transitionContext.containerView.addSubview(maskView)
            transitionContext.containerView.addSubview(toViewController.view)
            
            if animationStyle == .popUp {
                toViewController.view.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0) {[self] in
                    toViewController.view.transform = CGAffineTransformIdentity
                    maskView.alpha = maskViewAlpha
                } completion: { finished in
                    transitionContext.completeTransition(finished)
                }
            }else if animationStyle == .popOutFromBottom {
                var toViewControllerFrame = toViewController.view.frame
                toViewControllerFrame.origin.y = toViewControllerFrame.size.height
                toViewController.view.frame = toViewControllerFrame
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext)) { [self] in
                    toViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    maskView.alpha = maskViewAlpha
                } completion: { finished in
                    transitionContext.completeTransition(finished)
                }
            }
        }else {
            if animationStyle == .popUp {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0) { [self] in
                    maskView.alpha = 0.0
                    fromViewController.view.alpha = 0.0
                } completion: { finished in
                    transitionContext.completeTransition(finished)
                }

            }else if animationStyle == .popOutFromBottom {
                UIView.animate(withDuration: transitionDuration(using: transitionContext)) { [self] in
                    maskView.alpha = 0.0
                    fromViewController.view.alpha = 0.0
                } completion: { finished in
                    transitionContext.completeTransition(finished)
                }
            }
        }
    }
    //MARK: - ---------------------- <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning> END ----------------------
}

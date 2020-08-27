//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Kirill Pustovalov on 25.08.2020.
//

import Foundation
import UIKit

open class BottomSheetViewController: UIViewController { 
    public var animationDuration = 0.45
    public var viewController: UIViewController?
    
    var nextState: State {
        isPopoverVisible ? .collapsed : .expanded
    }
    
    var popoverViewController: PopoverViewController!
    var visualEffectView: UIVisualEffectView!
    
    var endHeight: CGFloat = 0
    var startHeight: CGFloat = 0
    
    var isPopoverVisible = false
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    var lastCompletedFraction = 0.0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultStartHeight = view.frame.height * 0.07
        let defaultEndHeight = view.frame.height * 0.90
        setupSizeWith(startHeight: defaultStartHeight, endHeight: defaultEndHeight)
        
        setupPopover()
    }
    public func setupSizeWith(startHeight: CGFloat, endHeight: CGFloat) {
        self.startHeight = startHeight
        self.endHeight = endHeight
    }
    func setupPopover() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        popoverViewController = PopoverViewController()
        popoverViewController.viewController = viewController
        self.view.addSubview(popoverViewController.view)
        
        popoverViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - startHeight, width: self.view.bounds.width, height: endHeight)
        popoverViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePopoverTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePopoverSlide(recognizer:)))
        
        popoverViewController.handlerTapAreaView.addGestureRecognizer(tapGestureRecognizer)
        popoverViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    func disableViewControllerGestures(for duration: Double) {
        popoverViewController.handlerTapAreaView.gestureRecognizers?.first?.isEnabled = false
        popoverViewController.view.gestureRecognizers?.first?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.popoverViewController.handlerTapAreaView.gestureRecognizers?.first?.isEnabled = true
            self.popoverViewController.view.gestureRecognizers?.first?.isEnabled = true
        }
    }
    func calculateAnimationTimeLeft(fraction: Double) -> Double {
        var normalizedFraction: Double
        if fraction > 1 {
            normalizedFraction = 1
        } else if fraction < 0 {
            normalizedFraction = 0.001
        } else {
            normalizedFraction = fraction
        }
        
        let fractionDuration = animationDuration * normalizedFraction
        let timeLeft = animationDuration - fractionDuration
        return timeLeft
    }
    @objc func handlePopoverTap(recognzier: UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            disableViewControllerGestures(for: lastCompletedFraction)
            animateTransitionIfNeeded(for: nextState, duration: animationDuration)
        default:
            break
        }
    }
    @objc func handlePopoverSlide (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: animationDuration)
        case .changed:
            let translation = recognizer.translation(in: self.popoverViewController.view)
            var fractionComplete = translation.y / endHeight
            fractionComplete = isPopoverVisible ? fractionComplete : -fractionComplete
            
            lastCompletedFraction = Double(fractionComplete)
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            let duration = calculateAnimationTimeLeft(fraction: lastCompletedFraction)
            disableViewControllerGestures(for: duration)
            
            let velocity = recognizer.velocity(in: view).y / 60
            var correctedVelocity: CGFloat
            if velocity < 0 {
                correctedVelocity = -velocity
            } else {
                correctedVelocity = velocity
            }
            
            if correctedVelocity > 5 {
                continueInteractiveTransition()
                return
            } else if lastCompletedFraction < 0.5 {
                var state: State
                if nextState == .collapsed {
                    state = .expanded
                } else {
                    state = .collapsed
                }
                runningAnimations.forEach {
                    $0.stopAnimation(false)
                    $0.finishAnimation(at: .current)
                }
                startInteractiveTransition(state: state, duration: duration)
                continueInteractiveTransition()
            } else {
                continueInteractiveTransition()
            }
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded (for state: State, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.popoverViewController.view.frame.origin.y = self.view.frame.height - self.endHeight
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    
                case .collapsed:
                    self.popoverViewController.view.frame.origin.y = self.view.frame.height - self.startHeight
                    self.visualEffectView.effect = nil
                }
            }
            frameAnimator.addCompletion { _ in
                self.isPopoverVisible.toggle()
                self.view.gestureRecognizers?.forEach {
                    $0.isEnabled.toggle()
                }
                self.navigationController?.navigationBar.gestureRecognizers?.forEach {
                    $0.isEnabled.toggle()
                }
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.popoverViewController.view.layer.cornerRadius = 10
                    self.popoverViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    
                case .collapsed:
                    self.popoverViewController.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
    }
    func startInteractiveTransition(state: State, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(for: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

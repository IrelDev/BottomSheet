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
    
    public var isHalfPresentationEnabled = false {
        didSet {
            if isHalfPresentationEnabled == true {
                animationDuration = animationDuration / 2
            }
        }
    }
    
    var nextState: State {
        var nextState: State
        if !isHalfPresentationEnabled {
            nextState = isPopoverVisible ? .collapsed : .expanded
        } else {
            if isPopoverHalfPresented {
                if isPopoverVisible {
                    nextState = .collapsed
                } else {
                    nextState = .expanded
                }
            } else {
                nextState = .halfPresented
            }
        }
        return nextState
    }
    
    var popoverViewController: PopoverViewController!
    var visualEffectView: UIVisualEffectView!
    
    var endHeight: CGFloat = 0
    var startHeight: CGFloat = 0
    
    var collapsedCornerRadius: CGFloat = 0
    var halfPresentedCornerRadius: CGFloat = 5
    var expandedCornerRadius: CGFloat = 15
    
    var isPopoverVisible = false
    var isPopoverHalfPresented = false
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    var lastCompletedFraction = 0.0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if endHeight == 0 && startHeight == 0 {
            let defaultStartHeight = view.frame.height * 0.07
            let defaultEndHeight = view.frame.height * 0.90
            setupSizeWith(startHeight: defaultStartHeight, endHeight: defaultEndHeight)
        }
        
        setupPopover()
    }
    public func setupSizeWith(startHeight: CGFloat, endHeight: CGFloat) {
        self.startHeight = startHeight
        self.endHeight = endHeight
    }
    public func setupCornerRadiusForAllStates(collapsed: CGFloat, halfPresented: CGFloat, expanded: CGFloat) {
        collapsedCornerRadius = collapsed
        halfPresentedCornerRadius = halfPresented
        expandedCornerRadius = expanded
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
        
        popoverViewController.view.layer.cornerRadius = collapsedCornerRadius
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
    @objc func handlePopoverSlide(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if !isHalfPresentationEnabled || nextState == .halfPresented {
                startInteractiveTransition(state: nextState, duration: animationDuration)
            }
        case .changed:
            let translation = recognizer.translation(in: self.popoverViewController.view)
            if !isHalfPresentationEnabled || nextState == .halfPresented {
                var fractionComplete = translation.y / endHeight
                fractionComplete = isPopoverVisible ? fractionComplete : -fractionComplete
                
                lastCompletedFraction = Double(fractionComplete)
                updateInteractiveTransition(fractionCompleted: fractionComplete)
            } else {
                let maximumHeight = self.view.frame.height - self.endHeight / 2
                let newY = popoverViewController.view.center.y + translation.y
                
                guard newY >= maximumHeight else { return }
                popoverViewController.view.center.y = popoverViewController.view.center.y + translation.y
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        case .ended:
            let duration: Double
            let velocity = recognizer.velocity(in: view).y / 60
            
            if isHalfPresentationEnabled {
                if velocity > 0 {
                    animateTransitionIfNeeded(for: .collapsed, duration: animationDuration)
                } else {
                    animateTransitionIfNeeded(for: .expanded, duration: animationDuration)
                }
                duration = animationDuration
                updateInteractiveTransition(fractionCompleted: 0)
            } else {
                duration = calculateAnimationTimeLeft(fraction: lastCompletedFraction)
            }
            disableViewControllerGestures(for: duration)
            
            var correctedVelocity: CGFloat
            if velocity < 0 {
                correctedVelocity = -velocity
            } else {
                correctedVelocity = velocity
            }
            if correctedVelocity > 5 {
                continueInteractiveTransition()
                return
            }
            
            else if lastCompletedFraction < 0.5 {
                if !isHalfPresentationEnabled || nextState == .halfPresented {
                    runningAnimations.forEach {
                        $0.isReversed = true
                    }
                }
            }
            continueInteractiveTransition()
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
                    if !self.isHalfPresentationEnabled {
                        self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    }
                case .collapsed:
                    self.popoverViewController.view.frame.origin.y = self.view.frame.height - self.startHeight
                    if !self.isHalfPresentationEnabled {
                        self.visualEffectView.effect = nil
                    }
                case .halfPresented:
                    self.popoverViewController.view.frame.origin.y = self.view.frame.height - self.endHeight / 2
                }
            }
            frameAnimator.addCompletion { _ in
                if frameAnimator.isReversed {
                    self.runningAnimations.removeAll()
                    return
                }
                if state == .halfPresented {
                    self.isPopoverHalfPresented = true
                } else { self.isPopoverHalfPresented = false }
                
                if state == .expanded {
                    self.isPopoverVisible = true
                } else if state == .collapsed {
                    self.isPopoverVisible = false
                }
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.makeTopRoundCorners(uiView: self.popoverViewController.view, radius: self.expandedCornerRadius)
                case .collapsed:
                    self.popoverViewController.view.layer.cornerRadius = self.collapsedCornerRadius
                case .halfPresented:
                    self.makeTopRoundCorners(uiView: self.popoverViewController.view, radius: self.halfPresentedCornerRadius)
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
    }
    func makeTopRoundCorners(uiView: UIView, radius: CGFloat) {
        uiView.layer.cornerRadius = radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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

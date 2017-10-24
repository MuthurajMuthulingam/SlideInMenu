//
//  ViewController+Menu.swift
//  SlideInMenuTest
//
//  Created by Muthuraj Muthulingam on 3/2/17.
//  Copyright © 2017 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

// MARK: - Extention to handle Menu related tasks
extension ViewController {
    //MARK: - Menu related methods
    //Show/Hide Menu
    /// show Menu
    ///
    /// - Parameter shouldShow: flag to inform visiblity of menu
    func showMenu(shouldShow:Bool)
    {
        let menuOriginXPosition = (shouldShow) ? Constants.maxStartXPosition:minStartXPosition
        showMenu(shouldShow,menuViewOriginXPosition: menuOriginXPosition)
    }
    
    // Show Menu with more customizations
    /// Show/Hide Menu
    ///
    /// - Parameters:
    ///   - shouldShow: flag to inform visiblity of menu
    ///   - menuViewOriginXPosition: X Position of menuView
    func showMenu(_ shouldShow:Bool,menuViewOriginXPosition:CGFloat) {
        
        if shouldShow {
            addBlurredOverlayView()
        }
        UIView.animate(withDuration: Constants.defaultAnimationDuration, animations: {
            if shouldShow {
                self.menuVC?.view.isHidden = !shouldShow
                self.blurEffectView?.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            }
            if menuViewOriginXPosition <= Constants.maxStartXPosition {
                self.menuVC?.view.frame = CGRect(x: menuViewOriginXPosition, y: 0, width: self.menuVCWidth, height: self.view.frame.height)
                self.panGestureView?.frame = CGRect(x: menuViewOriginXPosition, y: 0, width: self.menuVCWidth + Constants.panGestureViewOffset, height: self.view.frame.height)
                self.blurEffectView?.alpha = 0.1+((self.menuVCWidth + menuViewOriginXPosition)/self.menuVCWidth*0.7)
            }
        }, completion: { (completed) in
            if menuViewOriginXPosition == Constants.maxStartXPosition || menuViewOriginXPosition == self.minStartXPosition {
                self.blurEffectView?.isUserInteractionEnabled = shouldShow
                if !shouldShow {
                    self.blurEffectView?.effect = nil
                }
                // As Application remains lightcontent status bar, no need to update
                // change Status Bar color
            }
        })
    }
    
    // add Pangesture
    func setupMenuPanning() {
        // create Pangesture view
        addPanGestureView()
        // add panGesture
        addPanGesture()
    }
    
    /// add Pan Gesture
    private func addPanGesture() {
        createPanGesture()
        panGestureView?.addGestureRecognizer(panGesture!)
    }
    
    /// Create pan Gesture
    private func createPanGesture() {
        if panGesture == nil {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        }
    }
    
    /// Add PanGesture View
    private func addPanGestureView() {
        if panGestureView == nil {
            panGestureView = UIView(frame: self.view.bounds)
            panGestureView?.backgroundColor = UIColor.clear
            self.view.addSubview(panGestureView!)
        }
    }
    
    /// Hanlde Pan Event
    @objc fileprivate func viewPanned(_ panGesture:UIPanGestureRecognizer) {
        let panningInformation = getPanningDirection(panGesture)
        if panningInformation.panDirection == .left || panningInformation.panDirection == .right {
            switch panGesture.state {
            case .began:
                previousXPos = Double(panGesture.location(in: self.view).x)
                break
            case .changed:
                let currentMenuXOrigin = (menuVC?.view.frame)!.minX
                if (panningInformation.panDirection == .left  && currentMenuXOrigin == minStartXPosition){
                    break
                } else if (panningInformation.panDirection == .right  && currentMenuXOrigin == Constants.maxStartXPosition){
                    break
                }
                decideMenuViewOrigin(panningInformation)
                break
            case .ended:
                let currentXPosition = abs((self.menuVC?.view.frame.origin.x)!)
                let centerPosition = abs(minStartXPosition*0.5)
                var shouldShowMenu = false
                var originXPos = minStartXPosition
                if  currentXPosition <= centerPosition { // panningInformation.panDirection == .right
                    shouldShowMenu = true
                    originXPos = Constants.maxStartXPosition
                }
                showMenu(shouldShowMenu, menuViewOriginXPosition: originXPos)
                break
            default:
                break
            }
        }
    }
    
    /// Get Panning Direction
    private func getPanningDirection(_ panGesture:UIPanGestureRecognizer) -> (panDirection:PanDirection,originXPosition:CGFloat) {
        var panDirection:PanDirection = .right
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        var originXPosition = CGFloat(0)
        let velocity = panGesture.velocity(in: self.view)
        let location = panGesture.location(in: self.view)
        let difference = abs(previousXPos - Double(location.x))
        previousXPos = Double(location.x)
        if velocity.x < 0 {
            originXPosition = CGFloat(difference)
            panDirection = .left
        } else if (velocity.x > viewWidth || velocity.x <= viewWidth) {
            originXPosition = CGFloat(difference)
            panDirection = .right
        } else if (velocity.y < 0 || velocity.y <= viewHeight) {
            panDirection = .bottom
        } else if velocity.y > viewHeight {
            panDirection = .top
        }
        return (panDirection,originXPosition)
    }
    
    /// decide Menu view origin onscreen
    private func decideMenuViewOrigin(_ panningInfo:(panDirection:PanDirection,originXPosition:CGFloat)) {
        let currentXPosition = CGFloat((self.menuVC?.view.frame.origin.x)!)
        var proposedStartXPosition = panningInfo.originXPosition
        switch panningInfo.panDirection {
        case .left:
            // propsedStartXPosition always negative value, as panning left
            proposedStartXPosition = currentXPosition - proposedStartXPosition
            if (proposedStartXPosition < minStartXPosition) {
                proposedStartXPosition = minStartXPosition
            }
            showMenu(false,menuViewOriginXPosition: proposedStartXPosition)
            break
        case .right:
            // propsedStartXPosition always Positive value, as panning Right
            proposedStartXPosition += currentXPosition
            if (proposedStartXPosition > Constants.maxStartXPosition) {
                proposedStartXPosition = Constants.maxStartXPosition
            }
            showMenu(true,menuViewOriginXPosition: proposedStartXPosition)
            break
        default:
            break
        }
    }
}

//MARK: - MenuVC Delegate Methods
private typealias MenuDelegate = ViewController
extension MenuDelegate:MenuViewControllerDelegate {
    func menuViewPanned(menuViewController menuVC: MenuViewController, panGesture: UIPanGestureRecognizer) {
        viewPanned(panGesture)
    }
}

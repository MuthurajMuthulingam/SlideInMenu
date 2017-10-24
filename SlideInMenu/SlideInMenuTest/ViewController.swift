//
//  ViewController.swift
//  SlideInMenuTest
//
//  Created by Muthuraj Muthulingam on 3/2/17.
//  Copyright © 2017 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// Constants to be used in all sub VCs
    enum Constants {
        static let panGestureViewOffset = CGFloat(20)
        static let maxStartXPosition = CGFloat(0)
        static let defaultAnimationDuration = TimeInterval(0.3)
        static let blurBackgroundAlpha = CGFloat(0.5)
    }
    
    /// Direction of Panning
    ///
    /// - left: indicate to panning left
    /// - right: indicate to panning right
    /// - top: indicate to panning top
    /// - bottom: indicate to panning bottom
    enum PanDirection {
        case left
        case right
        case top
        case bottom
    }
    
    /// MenuVC instance
    var menuVC:MenuViewController?
    /// Apple provided Blur effect view
    var blurEffectView:UIVisualEffectView?
    /// Panning view
    var panGestureView:UIView?
    /// Gesture to be added to support Panning
    var panGesture:UIPanGestureRecognizer?
    /// tracker to handle previous position
    var previousXPos = Double(0)
    
    var minStartXPosition = CGFloat(0) // will be changed
    var menuVCWidth = CGFloat(0)
    
    /// Set this flag to enable Menu in sub classes
    var enableMenu:Bool = false {
        didSet {
            if enableMenu {
                // for time being
                setupMenuPanning()
                addMenuViewController()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // enable menu
        enableMenu = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Blurred Overlay View
    func addBlurredOverlayView() {
        if blurEffectView == nil {
            //only apply the blur if the user hasn't disabled transparency effects
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                blurEffectView = UIVisualEffectView()
                blurEffectView?.isHidden = false
                //always fill the view
                blurEffectView?.frame = self.view.bounds
                self.blurEffectView?.alpha = Constants.blurBackgroundAlpha
                //self.blurEffectView?.isUserInteractionEnabled = false
                blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.insertSubview(blurEffectView!, belowSubview: (panGestureView)!)
            } else {
                self.view.backgroundColor = UIColor.white
            }
            addGestureRecognizerToBlurrView()
        }
    }
    
    /// add gesture recognizer to blur view
    private func addGestureRecognizerToBlurrView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        blurEffectView?.addGestureRecognizer(tapGesture)
    }
    /// blurView Tapped  Action.
    @objc private func blurViewTapped() {
        showMenu(shouldShow: false)
    }
    
    /// Add Menu Child View controller
    func addMenuViewController() {
        if menuVC == nil {
            menuVCWidth = (self.view.frame.width*0.86)
            menuVC = MenuViewController(nibName: String(describing: MenuViewController.self), bundle: Bundle.main)
            menuVC?.view.isHidden = true
            menuVC?.delegate = self
            self.addChildViewController(menuVC!)
            minStartXPosition = -menuVCWidth
            menuVC?.view.frame = CGRect(x: minStartXPosition, y: 0, width: menuVCWidth, height: self.view.frame.height)
            panGestureView?.frame = CGRect(x: minStartXPosition, y: 0, width: menuVCWidth + Constants.panGestureViewOffset, height: self.view.frame.height)
            self.view.addSubview((menuVC?.view)!)
            menuVC?.didMove(toParentViewController: self)
        }
    }
}


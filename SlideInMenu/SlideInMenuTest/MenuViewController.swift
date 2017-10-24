//
//  MenuViewController.swift
//  SlideInMenuTest
//
//  Created by Muthuraj Muthulingam on 3/2/17.
//  Copyright © 2017 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

/// Delegate to be informed when handling panning on MenuVC
protocol MenuViewControllerDelegate : class{
    func menuViewPanned(menuViewController:MenuViewController, panGesture:UIPanGestureRecognizer)
}


class MenuViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak private var contentContainerView:UIView!
    
    //delegate instance
    weak var delegate:MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addPanGestureToContentView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// add PanGesture to conten
    private func addPanGestureToContentView() {
        let contentPanGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        contentContainerView.addGestureRecognizer(contentPanGesture)
    }
    
    /// viewPanned
    @objc private func viewPanned(_ panGesture:UIPanGestureRecognizer) {
        // notify delegate to receive panning
        self.delegate?.menuViewPanned(menuViewController: self, panGesture: panGesture)
    }
}

//
//  ViewController.swift
//  DownloadAnimation
//
//  Created by Muthuraj on 03/01/17.
//  Copyright © 2017 Muthuraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var downloadView: UIView!
	@IBOutlet weak var cartView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func sendButtonClicked(_ sender: UIButton) {
		downloadView.addTransitionEffect(to: cartView.frame, duration: 1, repeatCount: 1, needsCurve: true )
	}
}

extension UIView {
	
	/// Target View position
	///
	/// - leftTop: indicates Top Left corner
	/// - leftBottom: indicates Bottom Left corner
	/// - rightTop: indicates Top Right corner
	/// - rightBottom: indicates Bottom Right corner
	private enum TargetViewPosition {
		case leftTop
		case leftBottom
		case rightTop
		case rightBottom
	}
	/// Get snapshot of View
	///
	/// - Returns: UIImage instance of view
	private func getSnapShot() -> UIImage{
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
		drawHierarchy(in: self.bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
	/// Adding Transisition effect
	///
	/// - Parameter frame: target position for view to be trasnferred
	func addTransitionEffect(to frame:CGRect, duration:Double = 1, repeatCount:Float = 1, needsCurve:Bool = false) {
		let image = self.getSnapShot()
		let imageView = UIImageView(image: image)
		imageView.frame = CGRect(origin: self.frame.origin, size: image.size)
		self.superview?.addSubview(imageView)
		animateTransition(on: imageView,to: frame,duration: duration, repeatCount: repeatCount,needsCurve: needsCurve)
	}
	
	/// Animate Target Imageview to frame
	///
	/// - Parameters:
	///   - view: view which is going to be transferred to target position
	///   - frame: target position to which view is going to be transferred
	private func animateTransition(on view:UIView,to frame:CGRect, duration:Double = 1, repeatCount:Float = 1, needsCurve:Bool = false) {
		var path:UIBezierPath? = nil
		if needsCurve{
			path = UIBezierPath()
			path?.move(to: CGPoint(x: view.center.x,y: view.center.y))
			// decide path direction from position of target view
			let position = getTargetViewPosition(frame: frame)
			let controlPoints = calculateControlPoints(for: position, with: view)
			path?.addCurve(to: CGPoint(x: frame.origin.x, y: (frame.origin.y + 20)), controlPoint1: controlPoints.controlPoint1, controlPoint2:controlPoints.controlPoint2)
		}
		
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations:
			{
				view.frame = CGRect(origin: frame.origin, size: frame.size)
				if needsCurve{
					let animation = CAKeyframeAnimation(keyPath: "position")
					animation.path = path?.cgPath
					animation.repeatCount = repeatCount
					animation.duration = 0.3
					animation.fillMode = kCAFillModeForwards
					animation.isRemovedOnCompletion = false
					view.layer.add(animation, forKey: "animate position along path")
				}
				
		}, completion:{(status:Bool) -> Void in
			UIView.animate(withDuration: 0.5, animations: {
				view.alpha = 0
			}, completion: { (status:Bool) in
				view.removeFromSuperview()
			})
		})
	}
	
	/// Find TargetView position from its frame
	///
	/// - Parameter frame: frame of the target view
	/// - Returns: returns a position of TargetView
	private func getTargetViewPosition(frame:CGRect) -> TargetViewPosition {
		var position = TargetViewPosition.rightTop
		if (self.frame.origin.x > frame.origin.x) {
			if (self.frame.origin.y > frame.origin.y) {
				position = .leftTop
			} else {
				position = .leftBottom
			}
		} else {
			if (self.frame.origin.y > frame.origin.y) {
				position = .rightTop
			} else {
				position = .rightBottom
			}
		}
		return position
	}
	
	/// calculate control points for path
	///
	/// - Parameters:
	///   - position: TargetView position
	///   - view: view to be transferred
	/// - Returns: control point values
	private func calculateControlPoints(for position:TargetViewPosition, with view:UIView) -> (controlPoint1:CGPoint, controlPoint2:CGPoint) {
		// by default set control points for rightTop point
		var controlPoint1 = CGPoint(x: view.frame.origin.x/2,y: view.frame.origin.x/2)
		var controlPoint2 = CGPoint(x: frame.origin.x/4, y: frame.origin.y/4)
		// set Control point for right Bottom
		if position == .rightBottom {
			controlPoint1 = CGPoint(x: (frame.origin.x - (frame.size.width/2)), y: frame.maxY + (frame.size.height/4))
			controlPoint2 = CGPoint(x: frame.maxX + (frame.size.width/2), y: frame.maxY + (frame.size.height/2))
		} else if position == .leftTop { // left Top Position
			controlPoint1 = CGPoint(x: (frame.maxX + (frame.size.width/2)), y: frame.origin.x/2)
			controlPoint2 = CGPoint(x: frame.origin.x, y: frame.origin.y/4)
		} else if position == .leftBottom { // left Bottom Position
			controlPoint1 = CGPoint(x: (frame.maxX + (frame.size.width/2)), y: frame.maxY + (frame.size.height/4))
			controlPoint2 = CGPoint(x: frame.origin.x, y: frame.maxY + (frame.size.height/2))
		}
		
		return (controlPoint1, controlPoint2)
	}
}


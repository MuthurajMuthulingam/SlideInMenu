# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Download animation as a View Extension
* Slide In Menu 
* Sample applications attached.

### How do I get set up? ###

### Download Animation

* Include View extension inside your project.

```
#!swift

/// Adding Download Transisition animation
	///
	/// - Parameters:
	///   - frame: target position
	///   - duration: duration for Animation
	///   - repeatCount: number of animation sequence
	///   - needsCurve: to indicate curved or plain
	func addTransitionEffect(to frame:CGRect, duration:Double = 1, repeatCount:Float = 1, needsCurve:Bool = false){
}
```

example:

```
#!swift
// View on which extension will be called
view.addTransitionEffect(to: targetView.frame, duration: 1, repeatCount: 1, needsCurve: false )
```

### SlideIn Menu

* Menu control has designed in such a way that, MenuViewController and ViewController
* ViewController has all control over Menu as MenuViewController added as child for ViewController.
* Design your MenuViewController contents and keep ViewController as your baseVC(recommended)
* MenuViewController handling added as extension to ViewController. simply include it inside your project.
* Handling events of Menu will be done on BaseVC since this is container for menuViewController.
* You can either opt to show menu in your all baseVC derived classes.
* usage

```
#!swift

// Preferably inside ViewDidAppear.
// Place this line of code
    enableMenu = true // false if you don't want menu
```

 

### Contribution guidelines ###

* Writing tests
* Code review
* other suggestions regarding implementations
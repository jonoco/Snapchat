//
//  ViewController.swift
//  Snapchat
//
//  Created by Joshua Cox on 5/27/15.
//  Copyright (c) 2015 Joshua Cox. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
	
	var registering = true

	@IBOutlet weak var splashLabel: UILabel!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var toggleScreenButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!
	
	@IBAction func signup(sender: AnyObject) {
		
		if username.text != "" && username.text != "" {
			
			if registering {
				// sign up process
				signupUser()
				
			} else {
				// log in process
				loginUser()
				
			}
			
		} else {
			
			print("error: enter text into username and password")
			
		}
		
	}
	
	@IBAction func toggleScreen(sender: AnyObject) {
		
		if registering {
			// switch to log in screen
			registering = false
			
			splashLabel.text = "Log in to begin snapping!"
			signupButton.setTitle("Log In", forState: UIControlState.Normal)
			toggleScreenButton.setTitle("or sign up for an account", forState: UIControlState.Normal)
			
		} else {
			// switch to register screen
			registering = true
			
			splashLabel.text = "Register to begin snapping!"
			signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
			toggleScreenButton.setTitle("or log in to your account", forState: UIControlState.Normal)
			
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.navigationBarHidden = true
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
		if let user = PFUser.currentUser() {
			print("current user: \(user.username)")
			self.goToFriendsList()
		} else {
			print("current user: no user found")
		}
	}
	
	func signupUser() {
		
		let user = PFUser()
		user.username = username.text
		user.password = password.text
		
		user.signUpInBackgroundWithBlock { (success, error) -> Void in
			
			if error == nil {
				
				print("success: sign up user")
				self.goToFriendsList()
				
			} else {
				
				print("error: could not sign up user")
				print(error)
			}
		}
	}
	
	func loginUser() {
		guard let _ = username.text, let _ = password.text else {
			return
		}
		
		PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (success, error) -> Void in
			
			if error == nil {
				
				print("success: logged in user")
				self.goToFriendsList()
				
			} else {
				
				print("error: could not log in user")
				print(error)
			}
			
		}
		
	}
	
	func goToFriendsList() {
		
		self.performSegueWithIdentifier("toFriends", sender: self)
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool {
		
		textField.resignFirstResponder()
		
		return true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
//
//  AddFriendViewController.swift
//  Snapchat
//
//  Created by Joshua Cox on 5/27/15.
//  Copyright (c) 2015 Joshua Cox. All rights reserved.
//

import UIKit
import Parse

class AddFriendViewController: UIViewController {

	@IBOutlet weak var friend: UITextField!
	@IBOutlet weak var warning: UILabel!
	
	@IBAction func addFriend(sender: AnyObject) {
		
		self.hideMessage()
		
		guard let _ = friend.text else {
			print("error: please enter search text")
			return
		}
		
		print("add friend: \(friend.text)")
		
		let query = PFUser.query()
		query!.whereKey("username", equalTo: friend.text!)
		query!.getFirstObjectInBackgroundWithBlock {
			(user: PFObject?, error: NSError?) -> Void in
			
			guard let _ = error else {
				print("failure: could not find user")
				self.showWarning()
				return
			}
			
			if let user: PFUser = user as? PFUser {
				print("success: found user \(user.username)")
				self.showSuccess()
				self.addUserToFriends(user)
			}
		}
	}
	
	func addUserToFriends(friend: PFUser) {
		
		let user = PFUser.currentUser()
		let relation = user!.relationForKey("friends")
		relation.addObject(friend)
		user!.saveInBackgroundWithBlock { (success, error) -> Void in
			
			if error == nil {
				print("success: saved friend")
			} else {
				print("error: could not save friend")
				print(error!.description)
			}
			
		}
	}
	
	func showSuccess() {
		
		self.warning.text = "Added friend"
		self.warning.textColor = UIColor.blueColor()
		self.warning.hidden = false
	}
	
	func showWarning() {
		
		self.warning.text = "Could not find anyone with that name"
		self.warning.textColor = UIColor.redColor()
		self.warning.hidden = false
	}
	
	func hideMessage() {
		self.warning.hidden = true
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool {
		
		addFriend(self)
		textField.resignFirstResponder()
		
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}
	

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
	}
	*/

}

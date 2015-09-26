//
//  ChatViewController.swift
//  Snapchat
//
//  Created by Joshua Cox on 5/27/15.
//  Copyright (c) 2015 Joshua Cox. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate {

	var photoSelected = false
	var selectedImage: NSData = NSData()
	var activityIndicator = UIActivityIndicatorView()
	var friend: NSString?
	var timer = NSTimer()
	var removalTimer = NSTimer()
	var lastFriendPhoto: PFFile?
	var lastFriendImageId: String?
	
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var sendButton: UIButton!
	
	@IBAction func send(sender: AnyObject) {
		
		print("sending image")
		startActivityIndicator()
		hideToolbar()
		
		var message: NSString = ""
		let user = PFUser.currentUser()
		let image = PFObject(className: "Image")
		let imageFile = PFFile(name: "image.jpg", data: selectedImage)
		image["photo"] = imageFile
		image["user"] = user
		image["from"] = user!.username
		image["to"] = friend!
		image.saveInBackgroundWithBlock { (success, error) -> Void in
			
			if error == nil {

				print("success: saved image")
				message = "Photo has been shared"
			
				
			} else {
				
				print("error: could not save image")
				message = "Could not share image"
				
			}
			
			if #available(iOS 8.0, *) {
			    let alert: UIAlertController = UIAlertController(title: "Saved", message: "Photo has been shared", preferredStyle: UIAlertControllerStyle.Alert)
					self.presentViewController(alert, animated: true, completion: nil)
			} else {
			    // Fallback on earlier versions
				let alert: UIAlertView = UIAlertView(title: nil, message: message as String, delegate: self, cancelButtonTitle: "Ok")
				alert.show()
			}
			
			self.stopActivityIndicator()
		}
	}
	
	@IBAction func getPhoto(sender: AnyObject) {
	
//		hideToolbar()
		let image = UIImagePickerController()
		image.delegate = self
		image.sourceType = UIImagePickerControllerSourceType.Camera
		image.allowsEditing = false
		self.presentViewController(image, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("chatting with \(self.friend)")
		hideToolbar()
		checkForFriendsPhoto()
		timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "checkForFriendsPhoto", userInfo: nil, repeats: true)
		
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		timer.invalidate()
	}
	
	func checkForFriendsPhoto() {
		
		let user = PFUser.currentUser()
		let query = PFQuery(className: "Image")
		query.whereKey("from", equalTo: friend!)
		query.whereKey("to", equalTo: user!.username!)
		query.orderByDescending("createdAt")
		query.getFirstObjectInBackgroundWithBlock { (object , error) -> Void in
			
			if error == nil {
				
				print("success: retrieved friend's file")
			
				if object!.objectId == self.lastFriendImageId {
					
					print("friend's image has not changed")
				} else {
					
					self.lastFriendImageId = object!.objectId
					let file = object!["photo"] as! PFFile
					file.getDataInBackgroundWithBlock({ (image, error) -> Void in
						if error == nil {
							self.imageView.image = UIImage(data: image!)
							self.removalTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "removePhoto", userInfo: nil, repeats: false)
							
						} else {
							print("error: could not retrieve image")
						}
					})
				}

			} else {
				print("error: could not retrieve friend's file")
			}
		}
	}
	
	func removePhoto() {
		self.imageView.image = UIImage(named: "ghost.png")
	}
	
	func hideToolbar() {
		self.toolbar.hidden = true
	}
	
	func showToolbar() {
		self.toolbar.hidden = false
	}
	
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
		self.selectedImage = UIImageJPEGRepresentation(image, 0.01)!
		
		photoSelected = true
		showToolbar()
		imageView.image = UIImage(data: self.selectedImage)
	}
	
	func startActivityIndicator() {
		
		activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		UIApplication.sharedApplication().beginIgnoringInteractionEvents()
		
	}
	
	func stopActivityIndicator() {
		
		activityIndicator.stopAnimating()
		UIApplication.sharedApplication().endIgnoringInteractionEvents()
		
	}

	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Navigation

//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//			// Get the new view controller using segue.destinationViewController.
//			// Pass the selected object to the new view controller.
//	}

}

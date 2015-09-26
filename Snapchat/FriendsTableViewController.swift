//
//  FriendsTableViewController.swift
//  Snapchat
//
//  Created by Joshua Cox on 5/27/15.
//  Copyright (c) 2015 Joshua Cox. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UITableViewController {

	var friendsList = [PFUser]()
	var selectedFriend: String?
	var refresher = UIRefreshControl()
	
	@IBAction func logout(sender: AnyObject) {
		
		PFUser.logOutInBackgroundWithBlock { (error) -> Void in
			
			if error == nil {
				
				self.performSegueWithIdentifier("toLogin", sender: self)
				
			} else {
				
				print("error: could not log out")
				print(error)
			}
		}

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		makeRefresher()
		loadFriendsList()
		
	}
	
	func loadFriendsList() {
		
		guard let user = PFUser.currentUser() else {
			return
		}
		
		if let friends = user["friends"] as? PFRelation {
			
			let query = friends.query()
			query!.findObjectsInBackgroundWithBlock { (list, error) -> Void in
				
				if error == nil {
					
					print("success: found list")
					self.friendsList = list as! [PFUser]
					self.tableView.reloadData()
					
				} else {
					
					print("failer: no list found")
				}
				
				if self.refresher.refreshing {
					self.refresher.endRefreshing()
				}
			}
		}
	}
	
	func makeRefresher() {
		
		refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refresher.addTarget(self, action: "loadFriendsList", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refresher)
	}
	
	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}

	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
			// #warning Potentially incomplete method implementation.
			// Return the number of sections.
			return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			// #warning Incomplete method implementation.
			// Return the number of rows in the section.
			return self.friendsList.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

		cell.textLabel?.text = self.friendsList[indexPath.row].username

		return cell
	}
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		self.selectedFriend = self.friendsList[indexPath.row].username
		
		return indexPath
	}

	/*
	// Override to support conditional editing of the table view.
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
			// Return NO if you do not want the specified item to be editable.
			return true
	}
	*/

	/*
	// Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
			if editingStyle == .Delete {
					// Delete the row from the data source
					tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			} else if editingStyle == .Insert {
					// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
			}    
	}
	*/

	/*
	// Override to support rearranging the table view.
	override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

	}
	*/

	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
			// Return NO if you do not want the item to be re-orderable.
			return true
	}
	*/

	
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "toChat" {

			let destinationVC = segue.destinationViewController as! ChatViewController
			destinationVC.friend = selectedFriend
		}
	}
	

}

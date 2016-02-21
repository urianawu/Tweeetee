//
//  SidebarMenuController.swift
//  TwitterOAuth
//
//  Created by you wu on 2/17/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class SidebarMenuController: UITableViewController {

    @IBOutlet weak var homeCell: UITableViewCell!
    @IBOutlet weak var mentionsCell: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    @IBAction func onLogoutButton(sender: AnyObject) {
        User.currentUser?.logout()
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 45))
            //headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
            let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            profileView.clipsToBounds = true
            profileView.layer.cornerRadius = 15
            profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
            profileView.layer.borderWidth = 1
            profileView.setImageWithURL((User.currentUser?.profileImageUrl)!)
            
            let userNameLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 300, height: 30))
            userNameLabel.clipsToBounds = true
            userNameLabel.text = User.currentUser?.screenName
            userNameLabel.textColor = UIColor(red: 0.3, green: 0.4, blue: 0.8, alpha: 0.9)
            userNameLabel.font = UIFont.boldSystemFontOfSize(12)
            headerView.addSubview(userNameLabel)
            headerView.addSubview(profileView)

            return headerView
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 45
        }else {
            return 5
        }
    }

/*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ComposeViewController.swift
//  TwitterOAuth
//
//  Created by you wu on 2/26/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetView: UITextView!
    
    let limitLength = 140
    var profileImageURL = NSURL()
    var replyUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.setImageWithURL(profileImageURL)
        
        tweetView.delegate = self
        if (replyUser.isEmpty) {
            tweetView.text = "What's happening?"
            tweetView.textColor = UIColor.lightGrayColor()
            tweetView.selectedTextRange = tweetView.textRangeFromPosition(tweetView.beginningOfDocument, toPosition: tweetView.beginningOfDocument)
        }else {
            tweetView.text = replyUser+" "
            tweetView.textColor = UIColor.blackColor()
        }

        tweetView.becomeFirstResponder()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let wordCount = tweetView.text.characters.count
        countLabel.text = String(140 - wordCount)
    }

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return textView.text.characters.count + (text.characters.count - range.length) <= limitLength
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tweets = segue.destinationViewController as? TweetsViewController {
            tweets.refreshControlAction(UIRefreshControl())
        }
    }
    

}

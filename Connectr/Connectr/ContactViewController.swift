//
//  ContactViewController.swift
//  Connectr
//
//  Created by Roberto Ariosa Hernández on 08/04/2018.
//

import UIKit
import CoreNFC
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookCore
import FacebookLogin
import FacebookShare
import TwitterKit
import Alamofire

struct Info {
	var name: String
	var img: UIImage
	var twitter: String
	var facebook: String
	var snapchat: String
}

var infoContact = Info(name: "", img: #imageLiteral(resourceName: "profile_placeholder.png"), twitter: "", facebook: "", snapchat: "")
var visibleFacebook : Bool = true
var visibleTwitter : Bool = true
var visibleSnapchat : Bool = true

class ContactViewController: UIViewController {

	@IBOutlet weak var nameContact: UILabel!
	@IBOutlet weak var imgContact: UIImageView!
	@IBOutlet weak var twitterButton: UIButton!
	@IBOutlet weak var facebookButton: UIButton!
	@IBOutlet weak var snapchatButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func twitterButtonPressed(_ sender: Any) {
		let url = NSURL(string: "twitter:///user?user_id=" + infoContact.twitter)!
		if (UIApplication.shared.canOpenURL(url as URL)) {
			UIApplication.shared.open(url as URL)
		}
		else {
			let urlWeb = NSURL(string: "https://twitter.com/" + infoContact.twitter)!
			UIApplication.shared.open(urlWeb as URL)
		}
	}
	
	@IBAction func facebookButtonPressed(_ sender: Any) {
		let url = NSURL(string: "fb://profile/" + infoContact.facebook)!
		if (UIApplication.shared.canOpenURL(url as URL)) {
			UIApplication.shared.open(url as URL)
		}
		else {
			let urlWeb = NSURL(string: "https://www.facebook.com/" + infoContact.facebook)!
			UIApplication.shared.open(urlWeb as URL)
		}
	}
	
	@IBAction func snapchatButtonPressed(_ sender: Any) {
		let url = NSURL(string: "snapchat://add/" + infoContact.snapchat)!
		if (UIApplication.shared.canOpenURL(url as URL)) {
			UIApplication.shared.open(url as URL)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if (infoContact.name != "")
		{
			nameContact.text = infoContact.name
		}
		if (infoContact.facebook != "" && visibleFacebook)
		{
			facebookButton.isEnabled = true;
			facebookButton.setImage(#imageLiteral(resourceName: "Facebook.png"), for: .normal)
			let url = "https://graph.facebook.com/" + infoContact.facebook + "/picture?type=large&return_ssl_resources=1"
			Alamofire.request(url).response { (response2) -> Void in
				if let imageData = response2.data as NSData?, let image = UIImage(data: imageData as Data) {
					self.imgContact.image = image
				}
			}
		}
		else {
			facebookButton.isEnabled = false;
			facebookButton.setImage(#imageLiteral(resourceName: "Facebookdis.png"), for: .disabled)
		}
		
		if (infoContact.twitter != "" && visibleTwitter)
		{
			twitterButton.isEnabled = true;
			twitterButton.setImage(#imageLiteral(resourceName: "Twitter.png"), for: .normal)
		}
		else {
			twitterButton.isEnabled = false;
			twitterButton.setImage(#imageLiteral(resourceName: "Twitterdis.png"), for: .disabled)
		}
		
		if (infoContact.snapchat != "" && visibleSnapchat)
		{
			snapchatButton.isEnabled = true;
			snapchatButton.setImage(#imageLiteral(resourceName: "Snapchat.png"), for: .normal)
		}
		else {
			snapchatButton.isEnabled = false;
			snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .disabled)
		}
	}
}

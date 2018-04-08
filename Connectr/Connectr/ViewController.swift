//
//  ViewController.swift
//  Connectr
//
//  Created by Roberto Ariosa Hernández on 07/04/2018.
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

struct defaultsKeys {
	static let name = "name"
	static let tagtoken = "tagtoken"
	static let snapchatUsername = "snapchatUsername"
	static let twitterUsername = "twitterUsername"
	static let facebookUsername = "facebookUsername"
}

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
	
	private var nfcSession: NFCNDEFReaderSession!
	@IBOutlet weak var scanButton: UIButton!
	@IBOutlet weak var facebookButton: UIButton!
	@IBOutlet weak var twitterButton: UIButton!
	@IBOutlet weak var snapchatButton: UIButton!
	@IBOutlet weak var moreButton: UIButton!
	@IBOutlet weak var ringLoop: UIView!
	
	let loginManager = LoginManager()
	var snapchatUsername: String = ""
	
	func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
		print("The session was invalidated: \(error.localizedDescription)")
	}
	
	func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
		var result = ""
		for payload in messages[0].records {
			result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
		}
		print(result)
		Alamofire.request("https://whispering-shore-53045.herokuapp.com/getuserbytoken/" + result).responseJSON { response in
			print("Response JSON: \(response.result.value ?? "nil")")
			if let result = response.result.value {
				let json = result as! NSDictionary
				
				infoContact.name = (json.object(forKey: "name") as! String) + " " + (json.object(forKey: "surname") as! String)
				print(infoContact.name)
				
				if let facebookObj = (json.object(forKey: "networks") as! NSDictionary).object(forKey: "facebook") {
					infoContact.facebook = facebookObj as! String
					visibleFacebook = true
					print(infoContact.facebook)
				}
				else {
					visibleFacebook = false
				}
				
				if let twitterObj = (json.object(forKey: "networks") as! NSDictionary).object(forKey: "twitter") {
					infoContact.twitter = twitterObj as! String
					visibleTwitter = true
					print(infoContact.twitter)
				}
				else {
					visibleTwitter = false
				}
				
				if let snapchatObj = (json.object(forKey: "networks") as! NSDictionary).object(forKey: "snapchat") {
					infoContact.snapchat = snapchatObj as! String
					visibleSnapchat = true
					print(infoContact.snapchat)
				}
				else {
					visibleSnapchat = false
				}
			}
			
		}
	}
	
	@IBAction func scanButtonPressed(_ sender: Any) {
		initNFCSession();
		nfcSession.begin()
	}
	@IBAction func facebookButtonPressed(_ sender: Any) {
		let defaults = UserDefaults.standard
		if AccessToken.current == nil {
			loginManager.logIn(readPermissions: [], viewController: self, completion: { loginResult in
				switch loginResult {
				case .failed(let error):
					print(error)
				case .cancelled:
					print("User cancelled login.")
				case .success(let grantedPermissions, let declinedPermissions, let accessToken):
					defaults.set(FBSDKProfile.current().userID, forKey: defaultsKeys.facebookUsername)
					self.facebookButton.setImage(#imageLiteral(resourceName: "Facebook.png"), for: .normal)
				}
			})
		}
		else {
			loginManager.logOut()
			facebookButton.setImage(#imageLiteral(resourceName: "Facebookdis.png"), for: .normal)
		}
	}
	
	@IBAction func snapchatButtonPressed(_ sender: Any) {
		let defaults = UserDefaults.standard
		let alertController = UIAlertController( title: "Snapchat login",
												 message: "Enter your Snapchat's username:",
												 preferredStyle: .alert)
		alertController.addTextField(configurationHandler: {
			(textField: UITextField) in
			textField.placeholder = "username"
		})
		let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: {
			action in
			if let stringOne = defaults.string(forKey: defaultsKeys.snapchatUsername) {
				if (stringOne == "") {
					self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .normal)
				}
				else {
					self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchat.png"), for: .normal)
				}
			}
			else {
				self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .normal)
			}
		})
		let saveAction = UIAlertAction(title:"Save", style: .default, handler: {
			action in
			self.snapchatUsername = alertController.textFields!.first!.text!
			defaults.set(self.snapchatUsername, forKey: defaultsKeys.snapchatUsername)
			if let stringOne = defaults.string(forKey: defaultsKeys.snapchatUsername) {
				if (stringOne == "") {
					self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .normal)
				}
				else {
					self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchat.png"), for: .normal)
				}
			}
			else {
				self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .normal)
			}
		})
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	@IBAction func twitterButtonPressed(_ sender: Any) {
		TWTRTwitter.sharedInstance().logIn(completion: {(session, error) in
			if (session != nil) {
				let defaults = UserDefaults.standard
				defaults.set(session?.userName, forKey: defaultsKeys.twitterUsername)
				print(defaultsKeys.twitterUsername)
				self.twitterButton.setImage(#imageLiteral(resourceName: "Twitter.png"), for: .normal)
			} else {
				print("error: \(String(describing: error?.localizedDescription))");
			}
		})
	}
	
	@IBAction func moreButtonPressed(_ sender: Any) {
		let alertController = UIAlertController( title: "Coming Soon",
												 message: "You have added the maximmum number of accounts.",
												 preferredStyle: .alert)
		let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UITabBar.appearance().unselectedItemTintColor = UIColor(displayP3Red: 0, green: 0.2109375, blue: 0.4375, alpha: 1.0)
		
		// Scan button
		scanButton.layer.cornerRadius = scanButton.bounds.width / 2;
		scanButton.layer.borderWidth = 2;
		scanButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
		scanButton.layer.shadowOffset = CGSize(width: 0, height: 3)
		scanButton.layer.shadowOpacity = 1.0
		scanButton.layer.shadowRadius = 3.0
		scanButton.layer.masksToBounds = false
		
		// Draw Buttons
		
		if AccessToken.current == nil {
			facebookButton.setImage(#imageLiteral(resourceName: "Facebookdis.png"), for: .normal)
		}
		else {
			facebookButton.setImage(#imageLiteral(resourceName: "Facebook.png"), for: .normal)
		}
		let defaults = UserDefaults.standard
		if let stringOne = defaults.string(forKey: defaultsKeys.snapchatUsername) {
			if (stringOne == "") {
				self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .normal)
			}
			else {
				self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchat.png"), for: .normal)
			}
		}
		else {
			self.snapchatButton.setImage(#imageLiteral(resourceName: "Snapchatdis.png"), for: .normal)
		}
		
		if let stringOne = defaults.string(forKey: defaultsKeys.twitterUsername) {
			if (stringOne == "") {
				self.twitterButton.setImage(#imageLiteral(resourceName: "Twitterdis.png"), for: .normal)
			}
			else {
				self.twitterButton.setImage(#imageLiteral(resourceName: "Twitter.png"), for: .normal)
			}
		}
		else {
			self.twitterButton.setImage(#imageLiteral(resourceName: "Twitterdis.png"), for: .normal)
		}
		
//		if AccessToken.current != nil {
//			FBSDKProfile.loadCurrentProfile(completion: { (profile, error) in
//				print(profile!.linkURL.absoluteURL)
//			})
//		}
	}
	
	private func initNFCSession() {
		nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
		nfcSession.alertMessage = "You can hold you NFC-tag to the back-top of your iPhone"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
	}
}

class RingLoop: UIView {
	override func draw(_ rect: CGRect) {
		let ring = UIBezierPath(ovalIn: CGRect(x: rect.minX + 32, y: rect.minY + 32, width: rect.width - 64, height: rect.height - 64))
		UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).setStroke()
		ring.stroke()
	}
}

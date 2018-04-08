//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {

	@IBOutlet weak var linkTag: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet var tap: UITapGestureRecognizer!
	@IBOutlet var tapImg: UITapGestureRecognizer!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tap.delegate = self
		tapImg.delegate = self
		
		// Label
		let defaults = UserDefaults.standard
		if let stringOne = defaults.string(forKey: defaultsKeys.name) {
			if (stringOne == "") {
				self.nameLabel.text = "Tap to insert a name"
			}
			else {
				self.nameLabel.text = stringOne
			}
		}
		else {
			self.nameLabel.text = "Tap to insert a name"
		}
		
		// Img
		if AccessToken.current == nil {
			imageView.image = #imageLiteral(resourceName: "profile_placeholder.png")
		}
		else {
			FBSDKProfile.loadCurrentProfile { (response, error) in
				self.nameLabel.text = response?.name
				let url = response?.imageURL(for: .square, size: CGSize(width: 300, height: 300))
				Alamofire.request(url!, headers: nil).response { (response2) -> Void in
					if let imageData = response2.data as? NSData, let image = UIImage(data: imageData as Data) {
						self.imageView.image = image
					}
				}
			}
		}
		imageView.layer.cornerRadius = imageView.bounds.width / 2
		
		// Button
		if let stringOne = defaults.string(forKey: defaultsKeys.tagtoken) {
			if (stringOne == "") {
				linkTag.setTitle("Pair Tag", for: .normal)
				linkTag.tintColor = UIColor(red: 0, green: 0.4765625, blue: 1.0, alpha: 1.0)
			}
			else {
				linkTag.setTitle("Paired", for: .normal)
				linkTag.tintColor = UIColor.gray
			}
		}
		else {
			linkTag.setTitle("Pair Tag", for: .normal)
			linkTag.tintColor = UIColor.gray
		}
    }
	
	@IBAction func labelTapped(_ sender: Any) {
		print("tapped")
	}
	
	@IBAction func linkTagPressed(_ sender: Any) {
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

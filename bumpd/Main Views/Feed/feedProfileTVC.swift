//
//  feedProfileTVC.swift
//  bumpd
//
//  Created by Jeremy Gaston on 8/18/23.
//

import UIKit
import Firebase

class feedProfileTVC: UITableViewCell {

    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var btnTapAction : (()->())?
    var btnTapAction2 : (()->())?
    
    // Outlets
    
    @IBOutlet weak var recipientImg: CustomizableImageView!
    @IBOutlet weak var metaData: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var accessLabel: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var cellBtn: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.recipientImg.image = nil
        self.metaData.text = nil
        self.timestamp.text = nil
        self.accessLabel.image = nil
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Functions
    
    func setupViews() {
        
        profileBtn.addTarget(self, action: #selector(someAction), for: .touchUpInside)
        cellBtn.addTarget(self, action: #selector(cellAction), for: .touchUpInside)
        
    }
    
    @objc func someAction(_ sender: UITapGestureRecognizer){
        
        btnTapAction?()
        
    }
    
    @objc func cellAction(_ sender: UITapGestureRecognizer){
        
        btnTapAction2?()
        
    }
    
    func setupCell(bum: Bumps) {
        
        let recip = bum.recipient
        let auth = bum.author
        let user = Auth.auth().currentUser?.uid
        
        if recip == user && auth != user {
            
            databaseRef.child("Users/\(auth)").observe(.value) { (snapshot) in
                
                let img = snapshot.childSnapshot(forPath: "img").value as? String ?? "https://firebasestorage.googleapis.com/v0/b/bumpd-7f46b.appspot.com/o/profileImage%2Fdefault_profile%402x.png?alt=media&token=973f10a5-4b54-433f-859f-c6657bed5c29"
                let name = snapshot.childSnapshot(forPath: "name").value as? String ?? ""
                
                self.recipientImg.loadImageUsingCacheWithUrlString(urlString: img)
                self.metaData.text = "\(name) bumpd with you at \(bum.location)"
                self.timestamp.text = "\(bum.createdAt.timestampSinceNow())"
                
            }
            
        } else if auth == user && recip != user {
            
            databaseRef.child("Users/\(recip)").observe(.value) { (snapshot) in
                
                let img = snapshot.childSnapshot(forPath: "img").value as? String ?? "https://firebasestorage.googleapis.com/v0/b/bumpd-7f46b.appspot.com/o/profileImage%2Fdefault_profile%402x.png?alt=media&token=973f10a5-4b54-433f-859f-c6657bed5c29"
                let name = snapshot.childSnapshot(forPath: "name").value as? String ?? ""
                
                self.recipientImg.loadImageUsingCacheWithUrlString(urlString: img)
                self.metaData.text = "You bumpd into \(name) at \(bum.location)"
                self.timestamp.text = "\(bum.createdAt.timestampSinceNow())"
                
            }
            
        }
        
    }

}

//
//  AddUserVC.swift
//  RealmDataBaseSwift
//
//  Created by Inkswipe on 5/18/18.
//  Copyright © 2018 Inkswipe. All rights reserved.
//

import UIKit
import RealmSwift
protocol  AddUserVCDeleget
{
    func updateUI()
    
}
class AddUserVC: BaseViewController
{

    @IBOutlet weak var saveBtn: UIButton!
    var isEdit : String?
    var person : Person?
    var deleget : AddUserVCDeleget?
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var userNameText : UITextField!
    @IBOutlet weak var userAddressText: UITextField!
    
    var realm : Realm!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try! Realm()
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClick))
        self.navigationItem.rightBarButtonItem = cancel
        
        if isEdit == nil
        {
            self.navigationItem.title = "Add User"
            self.saveBtn.setTitle("ADD USER", for: .normal)
        }
        else
        {
            self.navigationItem.title = "Update User"
            self.saveBtn.setTitle("UPDATE USER", for: .normal)
            if person?.image != nil
            {
                self.userImageView.image = UIImage(data: (person?.image!)!)
            }
            self.userAddressText.text = person?.address
            self.userNameText.text = person?.name
            
        }
        
  
    }
    @objc func cancelBtnClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnClicked(_ sender: Any)
    {
        if isEdit == nil
        {
            try! realm.write
            {
                let person = Person()
                person.name = self.userNameText.text!
                person.address =  self.userAddressText.text!
                if UIImage (named: "UserImage")! != self.userImageView.image
                {
                    person.image = UIImageJPEGRepresentation(self.userImageView.image!, 0)
                }
                realm.add(person)
                self.dismiss(animated: true, completion: nil)
                self.deleget?.updateUI()
            }
        }
        else
        {
           
            try! realm.write
            {
                self.person?.name = self.userNameText.text!
                self.person?.address =  self.userAddressText.text!
                if UIImage (named: "UserImage")! != self.userImageView.image
                {
                    self.person?.image = UIImageJPEGRepresentation(self.userImageView.image!, 0)
                    //UIImagePNGRepresentation(self.userImageView.image!)
                }
                self.dismiss(animated: true, completion: nil)
                self.deleget?.updateUI()
            }
        }
       
       
        
    }
    
   
    @IBAction func galleryAndCameraBtnAction(_ sender: Any)
    {
        self.view.endEditing(true)
        self.addButtonTappedForProfile(sender: sender as AnyObject)
    }
    override func getImage(image: UIImage) {
        
        self.userImageView.image = image
      
    }
    

}

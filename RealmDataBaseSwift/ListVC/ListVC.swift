//
//  ViewController.swift
//  RealmDataBaseSwift
//
//  Created by Inkswipe on 5/18/18.
//  Copyright © 2018 Inkswipe. All rights reserved.
//

import UIKit
import RealmSwift
class ListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,AddUserVCDeleget {
    
    

    @IBOutlet var listTableView : UITableView!
    
    
    var realm : Realm!
//    var personListArray: Results<Person> {
//        get {
//            return realm.objects(Person.self)
//        }
//    }
    
    var personListArray : Results<Person>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        realm = try! Realm()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        personListArray = realm.objects(Person.self)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return personListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "ListTableCell") as! ListTableCell
        let person = personListArray[indexPath.row]
        cell.userNameLbl.text = person.name
        cell.userAddressLbl.text = person.address
        if (person.image != nil)
        {
             cell.userImage.image = UIImage(data: person.image!)
        }
        else
        {
             cell.userImage.image = UIImage(named: "UserImage")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            try! self.realm.write
            {
                let person = self.personListArray[indexPath.row]
                self.realm.delete(person)
                self.updateUI()
            }
            
        }
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.personListArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddUserVC") as! AddUserVC
        let nav = UINavigationController(rootViewController: vc)
        vc.deleget = self
        vc.isEdit = "YES"
        vc.person = person
        self.present(nav, animated: true, completion: nil)
        
    }
    @IBAction func addUserBtnClicked(_ sender: UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddUserVC") as! AddUserVC
        let nav = UINavigationController(rootViewController: vc)
        vc.deleget = self
        self.present(nav, animated: true, completion: nil)
        
    }
    func  updateUI()
    {
        personListArray = realm.objects(Person.self)
        self.listTableView.reloadData()
    }
  
}


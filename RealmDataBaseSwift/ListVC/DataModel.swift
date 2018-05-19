//
//  DataModel.swift
//  RealmDataBaseSwift
//
//  Created by Inkswipe on 5/18/18.
//  Copyright © 2018 Inkswipe. All rights reserved.
//
import RealmSwift

class Person: Object
{
    @objc dynamic var name = ""
    @objc dynamic var image: Data? = nil // optionals supported
    @objc dynamic var address = ""
}



extension UIView {
    
     @IBInspectable var cornerRadius: CGFloat {
        get {
            
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
          
        }
    }
    
   
}


//
//  UserTable.swift
//  FirebaseDemo
//
//  Created by Farhana Khan on 03/05/21.
//

import UIKit
import  FirebaseDatabase
class UserTableVC: UIViewController {
    var ref : DatabaseReference?
    @IBOutlet weak var UserTV: UITableView!
    var userData = [UserData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserTV.delegate = self
        UserTV.dataSource = self
        //set the firebase reference
        ref = Database.database().reference().child("users")
        ref?.observe(.childAdded){[weak self](result) in
            let key = result.key
            guard let value = result.value as? [String:Any] else { return }
            if let firstname = value["firstName"] as? String, let lastName = value["lastName"] as? String {
                let data = UserData(id: key, firstName:firstname,lastName:lastName)
                self?.userData.append(data)
                
                //reload table
                self?.UserTV.reloadData()
                
            }
        }
    }
}


extension UserTableVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("count \(userData.count)")
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserTVC
        let dataResp = userData[indexPath.row]
        cell.nameLb.text = "\(dataResp.firstName) \(dataResp.lastName)"
        return cell
    }
    
    
}

class UserData {
    var id : String
    var firstName : String
    var lastName : String
    
    init(id: String,firstName: String,lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
}


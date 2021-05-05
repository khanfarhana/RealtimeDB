//
//  SignUpVC.swift
//  FirebaseAuth
//
//  Created by Farhana Khan on 02/05/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUpVC: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var txF: UITextField!
    @IBOutlet weak var txL: UITextField!
    @IBOutlet weak var txE: UITextField!
    @IBOutlet weak var txP: UITextField!
    @IBOutlet weak var errorLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    //check the fields and validate that the data is correct. If everything is correct, this method return nil. Otherwise, it returns the error message
    func ValidateFields() -> String? {
        
        //Check that all fields are filled in
        if txF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txL.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txE.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txP.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        //check if password is secure
        let cleanedPassword = txP.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is atleast 8 charcter,contains special character and a number."
        }
        return nil
    }
    
    
    @IBAction func signUpPress(_ sender: UIButton) {
        let error = ValidateFields()
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showErr(msg: error!)
        }
        else {
            
            //create clean version of data
            let firstName = txF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = txL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txE.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txP.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if  err != nil {
                    //There was an error creating user
                    self.showErr(msg: "Error Creating user")
                }
                let ref = Database.database().reference(fromURL: "https://fir-demo-44271-default-rtdb.asia-southeast1.firebasedatabase.app/")
                let usersReference = ref.child("users").child(result!.user.uid)
                let values = ["firstName":firstName, "lastName": lastName]
                usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                    
                    if  err != nil {
                        print(err!)
                    }
                    
                    self.transitionHome()
                    
                })
                
            }
        }
    }
    func showErr(msg : String){
        errorLb.text = msg
        errorLb.alpha = 1
    }
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }
    
    func transitionHome()  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension SignUpVC {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

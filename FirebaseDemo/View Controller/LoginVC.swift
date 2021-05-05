//
//  LoginVC.swift
//  FirebaseAuth
//
//  Created by Farhana Khan on 02/05/21.
//

import UIKit
import FirebaseAuth
class LoginVC: UIViewController {
    
    @IBOutlet weak var txE: UITextField!
    @IBOutlet weak var txP: UITextField!
    @IBOutlet weak var errorLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func loginPress(_ sender: UIButton) {
        let email = txE.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = txP.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if  err != nil {
                //could'nt Sign in
                self.errorLb.text = err!.localizedDescription
                self.errorLb.alpha = 1
            }
            else {
                self.txE.text = ""
                self.txP.text = ""
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTableVC") as! UserTableVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func forgotbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension LoginVC {
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

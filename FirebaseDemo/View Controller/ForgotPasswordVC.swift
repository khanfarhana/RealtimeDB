//
//  ForgotPasswordVC.swift
//  FirebaseDemo
//
//  Created by Farhana Khan on 04/05/21.
//

import UIKit
import Firebase
class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var forgotTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sendBtn(_ sender: UIButton) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: forgotTF.text!) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                ok.setValue(UIColor.init(red:0/255,green:80/255,blue:0/255,alpha:1), forKey: "titleTextColor")

                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "Reset Password", message: "Do You Really Want To Reset Password?", preferredStyle: .alert)
            let Cancel = UIAlertAction(title: "Cancel", style: .cancel)
            let Reset = UIAlertAction(title: "Reset", style: .default) { (action) in
                let alert = UIAlertController(title: "Reset Link!", message: "Reset Link has been sent to your email", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    self.forgotTF.text = ""
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                ok.setValue(UIColor.init(red:0/255,green:80/255,blue:0/255,alpha:1), forKey: "titleTextColor")
                alert.addAction(ok)
                self.present(alert, animated: true,completion: nil)
            }
            Cancel.setValue(UIColor.init(red:0/255,green:80/255,blue:0/255,alpha:1), forKey: "titleTextColor")
            Reset.setValue(UIColor.init(red:0/255,green:80/255,blue:0/255,alpha:1), forKey: "titleTextColor")
            alert.addAction(Cancel)
            alert.addAction(Reset)
            self.present(alert, animated: true,completion: nil)
        }
    }
}

extension ForgotPasswordVC {
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

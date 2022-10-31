//
//  ViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-10-31.
//

import UIKit

class LoginViewController: UIViewController {
    
    // IBOutlets
    //labels
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    
    // text fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // views
    @IBOutlet weak var repeatPasswordLineView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // IBActions

    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
    }
}


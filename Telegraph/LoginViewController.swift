//
//  ViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-10-31.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: IBOutlets
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
    
    //MARK: VARS
    var isLogin: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUIFor(login: true)
        setupTextFieldDelegates()
        setupBackgroundTap()
    }
    
    //MARK: IBActions

    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showFailed("All fields are required!")
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            resetPassword()
        } else {
            ProgressHUD.showFailed("Email is required!")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("Email is required!")
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    //MARK: SETUP
    private func setupTextFieldDelegates(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_: )), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_: )), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_: )), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        updatePlaceholderLabels(textField: textField)
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap(){
        view.endEditing(false)
    }
    
    
    //MARK: ANIMATIONS
    
    private func updateUIFor(login: Bool){
        loginButton.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signupButton.setTitle(login ? "Sign Up" : "Login", for: .normal)
        signupLabel.text = login ? "Don't have an account?" : "Have an account?"
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabelOutlet.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            passwordTextField.text = textField.hasText ? "Password" : ""
        default:
            repeatPasswordTextField.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    //MARK: HELPERS
    private func isDataInputedFor(type: String) -> Bool {
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registeration":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default: //forgot password
            return emailTextField.text != ""
        }
    }
    
    private func loginUser(){
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            if error == nil {
                if isEmailVerified{
                    print("user has logged in : ", User.currentUser?.email)
                } else {
                    ProgressHUD.showFailed("Please verify email")
                    self.resendButton.isHidden = false
                }
            }else{
                ProgressHUD.showFailed(error.localizedDescription)
            }
        }
    }
    
    private func registerUser() {
        if passwordTextField.text == repeatPasswordTextField.text {
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil {
                    ProgressHUD.showSucceed("Verification email sent.")
                    self.resendButton.isHidden = false
                } else {
                    ProgressHUD.showFailed(error!.localizedDescription)
                }
            }
        }else{
            ProgressHUD.showFailed("The Passwords don't match")
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSucceed("Reset link sent.")
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail(){
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSucceed("Verification email sent.")
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    // MARK: NAVIGATION
    private func goToApp(){
        print("go to app")
    }
    
}


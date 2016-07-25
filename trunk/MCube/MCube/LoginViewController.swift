//  Created by Mukesh Jha on 02/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.

import UIKit
import SwiftValidator
import Alamofire
import Toast_Swift
import BEMCheckBox




class LoginViewController: UIViewController,ValidationDelegate ,UITextFieldDelegate {
    
    @IBOutlet weak var rememberMe: BEMCheckBox!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passworderror: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailerror: UILabel!
    @IBOutlet weak var email: UITextField!
    private var showingActivity = false
    let validator = Validator()
    var code:String?
    var authkey:String?
    var message:String?
    
    var empName:String?
    var empEmail:String?
    var ivrs:String?
    var lead:String?
    var mtracker:String?
    var pbx:String?
    var track:String?
    var businessName:String?
    var empContact:String?
    //var rememberMe:Bool=false
    var showpassicon:UIImageView?
    var iconClick : Bool!
    @IBOutlet weak var checkBox: CheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loginButton.layer.cornerRadius = 10
        validator.registerField(email, errorLabel: emailerror, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        
        validator.registerField(password,errorLabel: passworderror, rules: [RequiredRule(), MinLengthRule(length: 5)])
        self.email.delegate = self;
        self.password.delegate = self;
        iconClick = true
        self.setShowHideIcon()
        if NSUserDefaults.standardUserDefaults().stringForKey("emailfield") != nil
            && NSUserDefaults.standardUserDefaults().stringForKey("passfield") != nil
        {
            email.text=NSUserDefaults.standardUserDefaults().stringForKey("emailfield")
            password.text=NSUserDefaults.standardUserDefaults().stringForKey("passfield")
            
            
        }
        
    }
    
    
    func imageTapped(img: AnyObject)
    {
        // Your action
       
        if(iconClick == true) {
            password.secureTextEntry = false
            iconClick = false
            showpassicon = UIImageView(image:UIImage(named: "show")!.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
            
        } else {
            password.secureTextEntry = true
            iconClick = true
            showpassicon = UIImageView(image:UIImage(named: "hide")!.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        }
        
       
        showpassicon!.userInteractionEnabled=true;
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LoginViewController.imageTapped(_:)))
        showpassicon!.addGestureRecognizer(tapGestureRecognizer)
        password.rightViewMode = UITextFieldViewMode.Always
        password.rightView = showpassicon
        
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder()
            return false
        }
        if textField == password {
            textField.resignFirstResponder()
            validator.validate(self)
            return false
        }
        return true
    }
    
    
    @IBAction func LoginTap(sender: AnyObject) {
        validator.validate(self)
        
        
    }
    @IBOutlet weak var loginClick: UIButton!
    
    
    
    func validationSuccessful() {
        loginClick.enabled=false
        emailerror.text="";
        passworderror.text="";
        self.showActivityIndicator()
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/checkAuth", parameters: ["email":email.text!, "password":password.text!]).validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                self.loginClick.enabled=true
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                if((response.objectForKey("code")) != nil){
                    self.code=response.objectForKey("code")as? String;
                }
                if((response.objectForKey("msg")) != nil){
                    self.message=response.objectForKey("msg")as? String;
                    
                }
                if((response.objectForKey("authKey")) != nil){
                    self.authkey = response.objectForKey("authKey")! as? String
                }
                
                
                if((response.objectForKey("empName")) != nil){
                    self.empName = response.objectForKey("empName")! as? String
                    
                }
                
                if((response.objectForKey("empEmail")) != nil){
                    self.empEmail = response.objectForKey("empEmail")! as? String
                    
                }
                
                if((response.objectForKey("ivrs")) != nil){
                    self.ivrs = response.objectForKey("ivrs")! as? String
                    
                }
                
                if((response.objectForKey("lead")) != nil){
                    self.lead = response.objectForKey("lead")! as? String
                    
                }
                if((response.objectForKey("mtracker")) != nil){
                    self.mtracker = response.objectForKey("mtracker")! as? String
                    
                }
                if((response.objectForKey("pbx")) != nil){
                    self.pbx = response.objectForKey("pbx")! as? String
                    
                }
                if((response.objectForKey("track")) != nil){
                    self.track = response.objectForKey("track")! as? String
                    
                }
                if((response.objectForKey("businessName")) != nil){
                    self.businessName = response.objectForKey("businessName")! as? String
                    
                }
                if((response.objectForKey("empContact")) != nil){
                    self.empContact = response.objectForKey("empContact")! as? String
                    
                }
                
                
                
                //  print("code \(self.code)")
                
            case .Failure(let error):
                //print("Request failed with error: \(error)")
                if (error.code == -1009) {
                    self.showAlert("No Internet Conncetion")
                }
                
                self.loginClick.enabled=true;
                self.showActivityIndicator()
                }
                if(self.code=="401"||self.code=="400"){
                    if(self.message != nil){
                        self.showActivityIndicator()
                        self.showAlert(self.message!)
                    }
                }
                if(self.code=="200"){
                    if(self.message != nil){
                        self.showActivityIndicator()
                        NSUserDefaults.standardUserDefaults().setObject(self.empName, forKey: "name")
                        NSUserDefaults.standardUserDefaults().setObject(self.empEmail, forKey: "email")
                        NSUserDefaults.standardUserDefaults().setObject(self.authkey, forKey: "authkey")
                        NSUserDefaults.standardUserDefaults().setObject(self.empContact, forKey: "empContact")
                        NSUserDefaults.standardUserDefaults().setObject(self.businessName, forKey: "businessName")
                        
                        NSUserDefaults.standardUserDefaults().setObject(self.track, forKey: "track")
                        NSUserDefaults.standardUserDefaults().setObject(self.ivrs, forKey: "ivrs")
                        NSUserDefaults.standardUserDefaults().setObject(self.lead, forKey: "lead")
                        NSUserDefaults.standardUserDefaults().setObject(self.pbx, forKey: "pbx")
                        NSUserDefaults.standardUserDefaults().setObject(self.mtracker, forKey: "mtracker")
                        
                        
                        
                        
                        
                        // NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "select")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("name") {
                            print(myLoadedString) // "Hello World"
                        }
                        
                        if(self.rememberMe.on){
                            NSUserDefaults.standardUserDefaults().setObject(self.email.text, forKey: "emailfield")
                            NSUserDefaults.standardUserDefaults().setObject(self.password.text, forKey: "passfield")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        else{
                            if NSUserDefaults.standardUserDefaults().stringForKey("emailfield") != nil
                                && NSUserDefaults.standardUserDefaults().stringForKey("passfield") != nil
                            {
                                NSUserDefaults.standardUserDefaults().removeObjectForKey("emailfield")
                                NSUserDefaults.standardUserDefaults().removeObjectForKey("passfield")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                        }
                        
                        
                        
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        //self.showAlert(self.message!)
                        
                        
                        
                    }
                }
                
        }
        
    }
    
    
    
    
    func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.Center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    
    
    
    
    func showAlert(mesage :String){
        //dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    
    func validationFailed(errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.redColor().CGColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }    }

    
    
    
    
    
    func setShowHideIcon(){
        
        
        
        let user:UIImage=UIImage(named: "user")!;
        let usericon:UIImageView = UIImageView(image:user.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        email.leftViewMode = UITextFieldViewMode.Always
        email.leftView = usericon
        
        let pass:UIImage=UIImage(named: "pass")!;
        let passicon:UIImageView = UIImageView(image:pass.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        password.leftViewMode = UITextFieldViewMode.Always
        password.leftView = passicon
        
        
        //  let showpass:UIImage=UIImage(named: "show")!;
        showpassicon = UIImageView(image:UIImage(named: "hide")!.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        showpassicon!.userInteractionEnabled=true;
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LoginViewController.imageTapped(_:)))
        showpassicon!.addGestureRecognizer(tapGestureRecognizer)
        password.rightViewMode = UITextFieldViewMode.Always
        password.rightView = showpassicon
        
    }
}



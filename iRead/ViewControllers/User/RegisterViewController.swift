//
//  RegisterViewController.swift
//  TextField
//
//  Created by Simon on 16/4/20.
//  Copyright © 2016年 CosmicMind, Inc. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
//import AVOSCloudDynamic

class RegisterViewController: UserViewController {

    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var maskView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var registerButton: DeformationButton = {
        let button = DeformationButton(frame: iReadConstant.RegisterButton.frame)
        button.contentColor = iReadColor.themeBlueColor
        button.layer.cornerRadius = iReadConstant.RegisterButton.cornerRadius
        button.clipsToBounds = true
        button.forDisplayButton.clipsToBounds = true
        button.forDisplayButton.layer.cornerRadius = iReadConstant.RegisterButton.cornerRadius
        button.progressColor = iReadColor.themeLightWhiteColor
        button.forDisplayButton.backgroundColor = iReadColor.themeBlueColor
        button.forDisplayButton.setTitle("注册", forState: .Normal)
        button.forDisplayButton.setTitleColor(iReadColor.themeLightWhiteColor, forState: .Normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "注册我阅"
        // Do any additional setup after loading the view.
        prepareForTextField(emailField, placehold: "邮箱", detialInfo: "邮箱格式不正确")
        prepareForTextField(passwordField, placehold: "密码", detialInfo: "密码至少六位数")
        prepareForTextField(usernameField, placehold: "用户名", detialInfo: "用户名不能为空")
        prepareForRegisterButton()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
    }
    
    func prepareForRegisterButton() {
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: "handleRegisterEvent", forControlEvents: .TouchUpInside)
    }
    
    func startRegisterAnimation() {
        registerButton.isLoading = true
        registerButton.enabled = false
    }
    
    func stopRegisterAnimation() {
        registerButton.isLoading = false
        registerButton.enabled = true
        registerButton.setNeedsDisplay()
    }

    private func prepareForTextField(field: TextField, placehold: String, detialInfo: String) {
        field.delegate = self
        field.placeholder = placehold
        field.placeholderTextColor = MaterialColor.grey.base
        field.font = RobotoFont.regularWithSize(16)
        field.textColor = MaterialColor.black
        field.borderStyle = .None
        
//        field.titleLabel = UILabel()
        field.titleLabel!.font = RobotoFont.mediumWithSize(11)
        field.titleLabelColor = MaterialColor.grey.base
        field.titleLabelActiveColor = iReadColor.themeBlueColor
        
//        field.detailLabel = UILabel()
        field.detailLabel!.text = detialInfo
        field.detailLabel!.font = RobotoFont.mediumWithSize(11)
        field.detailLabelActiveColor = iReadColor.themeRedColor
        field.detailLabelAnimationDistance = 4
        
        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)
        let clearButton: FlatButton = FlatButton()
        field.clearButton.pulseColor = MaterialColor.grey.base
        field.clearButton.pulseScale = false
        field.clearButton.tintColor = MaterialColor.grey.base
        field.clearButton.setImage(image, forState: .Normal)
        field.clearButton.setImage(image, forState: .Highlighted)
        
//        field.clearButton = clearButton
        
    }

    func handleRegisterEvent() {
        
        resignCurrrentResponser()

        if let username = usernameField.text, let password = passwordField.text, let email = emailField.text {
            
            let result = shouldRegisterAccount(username, password: password, email: email)

            if result {
                print("进行注册请求")

                startRegisterAnimation()
                sendRegisterRequest(username, email: email, password: password) {
                    self.stopRegisterAnimation()
                }
                
            } else {
                HUDManager.sharedManager.showupErrorMessage("注册失败")
            }
        } else {
            HUDManager.sharedManager.showupErrorMessage("注册失败")
        }
        
    }

}

// MARK: - LeanCloud Register Handle
extension RegisterViewController {

    func sendRegisterRequest(username: String, email: String, password: String, handler: ()->()) {
        let user = Reader()
        user.username = username
        user.email = email
        user.password = password
        user.signUpInBackgroundWithBlock(){
            completion, error in
            if error != nil {
                self.handleRegisterError(error)
            } else {
                self.handleRegisterCompletion(completion, user: user)
            }
            handler()
        }
    }
    
    func handleRegisterError(error: NSError) {
        print("注册错误发生:\(error)")
        if error.code == 202 {
            self.showupTopInfoMessage("用户名已存在")
        } else {
            self.showupTopInfoMessage(error.localizedDescription)
        }
        
    }
    
    func handleRegisterCompletion(completion: Bool, user: Reader) {
        if completion {
            
            self.showupSuccessMessage("注册成功")
            
            // 数据处理
            self.uploadUserDataToServer(user.objectId)
            
            // 跳转逻辑
            self.dismissViewControllerAnimated(true, completion: nil)
            print("实现跳转逻辑")
        } else {
            self.showupTopInfoMessage("注册失败")
        }
    }
   
    func uploadUserDataToServer(userID: String) {
        print(userID)
        let avatarData = UIImageJPEGRepresentation(profileImageView.image!, iReadConstant.ProfileImageView.imageQuality)
        let avatar = AVFile(name: "avatar", data: avatarData!)
        avatar.saveInBackgroundWithBlock{
            result, error in
            
            if self.filterShowUpError(error) {
                let reader = Reader.currentUser()
                reader.avater_url = avatar.url
                iReadUserDefaults.updateAvatorIconURLString(avatar.url)
                reader.readTime = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey)
                reader.readCounts = iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
                reader.readMode = iReadUserDefaults.defaults.boolForKey(ReadModeKey)
                reader.themeMode = iReadUserDefaults.defaults.boolForKey(ThemeModeKey)
                print(reader)
                reader.saveInBackground()
                print("😎upload image \(avatar.url)done")
            }
        }
        
        FeedResource.sharedResource.uploadUserArticlesToServer(userID){
            error in
            if self.filterShowUpError(error) {
                print("😎upload Articles done \(userID)")
            }
        }
        
        FeedResource.sharedResource.uploadUserFeedItemsToServer(userID){
            error in
            if self.filterShowUpError(error) {
                print("😎upload FeedItems done \(userID)")
            }
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}

// MARK: - <#UIImagePickerControllerDelegate, UINavigationControllerDelegate#>
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func updateProfileImageHandle(sender: AnyObject) {
        let imagePickVC = UIImagePickerController()
        imagePickVC.delegate = self
        imagePickVC.allowsEditing = false
        
        
        guard UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) else {
            HUDManager.sharedManager.showupInfoMessage("无法访问相册")
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }
        
        imagePickVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickVC, animated: true, completion: {
            completion in
        })
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        defer {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        let image = image.largestCenteredSquareImage().resizeToTargetSize(CGSizeMake(iReadConstant.ProfileImageView.width, iReadConstant.ProfileImageView.height))
        profileImageView.image = image.roundCornersToCircle()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RegisterViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        
        let field = textField as! TextField
        updateDetailLabelStateInTextField(field)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let field = textField as! TextField
        
        updateDetailLabelStateInTextField(field)
        let shouldReturn = updateResponseStateInTextField(field)
        
        return shouldReturn
        
    }
   
    func updateResponseStateInTextField(field: TextField) -> Bool {
        switch field {
        case usernameField:
            let hideWarn = field.text?.isVaildUsername() ?? false
            let shouldReturn = shouldResignTextField(field, shouldResgin: hideWarn)
            return shouldReturn
        case passwordField:
            let hideWarn = field.text?.isVaildPassword() ?? false
            let shouldReturn = shouldResignTextField(field, shouldResgin: hideWarn)
            return shouldReturn
        case emailField:
            if let hideWarn = field.text?.isValidEmail() {
                let shouldReturn = shouldResignTextField(field, shouldResgin: hideWarn)
                return shouldReturn
            } else {
                return false
            }
        default:
            return true
        }
        
    }
    
    func updateDetailLabelStateInTextField(field: TextField) {
        switch field {
        case usernameField:
            if let hideWarn = field.text?.isVaildUsername() {
                field.detailLabelHidden = hideWarn
            }
            
        case passwordField:
            if let hideWarn = field.text?.isVaildPassword() {
                field.detailLabelHidden = hideWarn
            }

        case emailField:
            if let hideWarn = field.text?.isValidEmail() {
                field.detailLabelHidden = hideWarn
            }
        default:
            field.detailLabelHidden = true
        }
    }
    
    func shouldResignTextField(textField: UITextField, shouldResgin: Bool) -> Bool {
        if shouldResgin {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    func shouldRegisterAccount(username: String, password: String, email: String) -> Bool {
        
        let contentExist = !(username.isEmpty && password.isEmpty && email.isEmpty)
        
        let contentVaild = username.isVaildUsername() && password.isVaildPassword()
        && email.isValidEmail()
        
        return contentExist && contentVaild
    }
    
    
}

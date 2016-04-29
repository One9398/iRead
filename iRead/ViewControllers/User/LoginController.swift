//
//  LoginController.swift
//  TextField
//
//  Created by Simon on 16/4/20.
//  Copyright © 2016年 CosmicMind, Inc. All rights reserved.
//

import UIKit
import Material
//import LeanCloudSocialDynamic

class LoginController: UserViewController {
    
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var passwordField: TextField!
    
    private var loginButton: DeformationButton = {
        let button = DeformationButton(frame: iReadConstant.LoginButton.frame)
        button.contentColor = iReadColor.themeBlueColor
        button.layer.cornerRadius = iReadConstant.LoginButton.cornerRadius
        button.clipsToBounds = true
        button.forDisplayButton.clipsToBounds = true
        button.forDisplayButton.layer.cornerRadius = iReadConstant.LoginButton.cornerRadius
        button.progressColor = iReadColor.themeLightWhiteColor
        button.forDisplayButton.backgroundColor = iReadColor.themeBlueColor
        button.forDisplayButton.setTitle("登录", forState: .Normal)
        button.forDisplayButton.setTitleColor(iReadColor.themeLightWhiteColor, forState: .Normal)
        return button
    }()
    
    enum AccountType: String {
        case QQ = "qq"
        case Weibo = "weibo"
        case Wechat = "wechat"
        
        var currentSNSType : AVOSCloudSNSType {
            switch self {
            case .QQ:
                return .SNSQQ
            case .Wechat:
                return .SNSWeiXin
            case .Weibo:
                return .SNSSinaWeibo
            }
        }
        
        var currentPlatform : String {
            switch self {
            case .QQ:
                return AVOSCloudSNSPlatformQQ
            case .Wechat:
                return AVOSCloudSNSPlatformWeiXin
            case .Weibo:
                return AVOSCloudSNSPlatformWeiBo
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = "登录"
        prepareForTextField(usernameField, placehold: "用户名/邮箱", detialInfo: "用户名/邮箱不能为空")
        prepareForTextField(passwordField, placehold: "密码", detialInfo: "密码至少六位数")
        prepareForLoginButton()
        print(iReadUserDefaults.isLogined)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func prepareNavigationItem(image: UIImage?) {
        let iconImage = UIImage(assetsIdentifier: .icon_close)
        super.prepareNavigationItem(iconImage)
    }
    
    override func popCurrentViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareForLoginButton() {
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(LoginController.handleLoginEvent), forControlEvents: .TouchUpInside)
    }
    
    func startRegisterAnimation() {
        loginButton.isLoading = true
        loginButton.enabled = false
    }
    
    func stopRegisterAnimation() {
        loginButton.isLoading = false
        loginButton.enabled = true
        loginButton.setNeedsDisplay()
    }
    
    private func prepareForTextField(field: TextField, placehold: String, detialInfo: String, clearIcon: String = "ic_close_white") {
        field.delegate = self
        field.placeholder = placehold
        field.placeholderTextColor = MaterialColor.grey.base
        field.font = RobotoFont.regularWithSize(16)
        field.textColor = MaterialColor.black
        field.borderStyle = .None
//        field.titleLabel = UILabel()
//        field.titleLabel = UILabel()
        field.titleLabel!.font = RobotoFont.mediumWithSize(11)
        field.titleLabelColor = MaterialColor.grey.base
        field.titleLabelActiveColor = iReadColor.themeBlueColor
        field.titleLabelAnimationDistance = 4
        
//        field.detailLabel = UILabel()
        field.detailLabel!.text = detialInfo
        field.detailLabel!.font = RobotoFont.mediumWithSize(11)
        field.detailLabelActiveColor = iReadColor.themeRedColor
        field.detailLabelAnimationDistance = 2
        
        let image = UIImage(named: clearIcon)?.imageWithRenderingMode(.AlwaysTemplate)
        
        field.clearButton.pulseColor = MaterialColor.grey.base
        field.clearButton.pulseScale = false
        field.clearButton.tintColor = MaterialColor.grey.base
        field.clearButton.setImage(image, forState: .Normal)
        field.clearButton.setImage(image, forState: .Highlighted)
//        field.clearButton = clearButton
        
    }
   
    func sendLoginRequest(username: String, password: String, completionHandle:((Void)->())) {
        
        Reader.logInWithUsernameInBackground(username, password: password) {
            user, error in
            if error != nil {
                self.handleLoginError(error)
            } else {
                self.handleLoginSuccessUser(user as! Reader)
            }
            
            completionHandle()
        }
        
    }
    
    func handleLoginSuccessUser(user: Reader) {
        
        self.showupSuccessMessage("登录成功")
        iReadUserDefaults.updateAvatorIconURLString(user.avater_url)
        
        // 本地化数据处理
        loadUserDataFromServerWhenOAuthed(user)
       
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func handleLoginError(error: NSError) {
        print(error)
        switch error.code {
        case 211:
            self.showupInfoMessage("用户不存在")
        case 210:
            self.showupErrorMessage("用户/密码错误")
        default:
            self.showupErrorMessage("登录错误")
        }
    }
    
    func handleLoginEvent() {
        
        resignCurrrentResponser()
        
        if let username = usernameField.text, let password = passwordField.text {
            
            if shouldLoginAccount(username, password: password) {
                print("请求登录")
                
                /*
                1展示请求动画
                2注册请求
                3请求反馈
                4取消动画
                5根据请求反馈提示HUD
                */
                
                startRegisterAnimation()
                sendLoginRequest(username, password: password){
                    self.stopRegisterAnimation()
                }
                
            } else {
                print("登录信息不全")
                self.showupInfoMessage("登录失败")
            }
            
        } else {
            print("登录信息不全")
            self.showupInfoMessage("登录失败")
        }
    }
    
    @IBAction func resetPasswordHandle(sender: AnyObject) {
        print("input email")
        iReadAlert.showFeedInput(title: "重置密码", placeholder: "输入注册所用的邮箱", confirmTitle: "输入完成", dismissTitle: "想起来了", inViewController: self, withFinishedAction: {
            text in
            if text.isValidEmail() {
                // 发邮件
                self.showupTopInfoMessage("已发送密码重置邮件")
            } else if text.isEmpty {
                assertionFailure("输入邮箱啊啊啊")
            } else {
                // 邮箱不正确
                self.showupTopInfoMessage("邮箱格式错误")
            }
        })        
    }
}

// MARK: - OAuth Handle
extension LoginController {
    
    @IBAction func otherPlatformLoginHandle(sender: UIButton) {
        guard let accountType = AccountType(rawValue: sender.titleForState(.Normal)!) else { fatalError("no such account type")}
        sendOAuthRequestWithPlatformType(accountType)
    }
    
    func sendOAuthRequestWithPlatformType(type: AccountType) {
        
        let currentSNSType = type.currentSNSType
        let platformType = type.currentPlatform
        
        if currentSNSType == .SNSWeiXin {
            self.showupTopInfoMessage("微信登录即将开放")
            return
        } else if currentSNSType == .SNSQQ && !AVOSCloudSNS.isAppInstalledForType(.SNSQQ) {
            self.showupTopInfoMessage("需要QQ客户端才可登录")
            return
        } else {
            print("进入授权")
        }
        
        
        AVOSCloudSNS.loginWithCallback({
            object, error in
            
            if error != nil {
                let errorInfo = self.handleOAuthEror(error)
                self.showupTopInfoMessage(errorInfo)
                
            } else {
                let authData = object as! [NSObject : AnyObject]
                
                self.loginButton.isLoading = true
                
                // 绑定AVUser数据
                Reader.loginWithAuthData(authData, platform:platformType ) {
                    user, error in
                    if error != nil {
                        self.handleBindingDataError(error)
                    } else {
                        
                        // 跳转逻辑
                        self.savePlatformUserLocalAuthData(authData)
                        self.loginSucceedWithUser(user as! Reader)
                        self.loginButton.isLoading = false
                        self.dismissViewControllerAnimated(true, completion: {
                            self.showupSuccessMessage("登录成功")
                        })
                    }
                }
            }
            }, toPlatform: currentSNSType)
    }
    
    func savePlatformUserLocalAuthData(data: [NSObject: AnyObject]) {
        // 获取到第三方用户信息 object
        guard let token = data["access_token"] as? String, let username = data["username"] as? String, let avatar = data["avatar"] as? String else {
            assertionFailure("用户不完整:\(data)")
            return
        }
        
        // 保存数据
        let dic:[String:String] = ["token":token,"username":username,"avatar":avatar]
        print(dic)
        iReadUserDefaults.saveCurrentPlatformUserDictionary(dic)
        
    }
    
    func loginSucceedWithUser(user: Reader) {
        let avatar = iReadUserDefaults.fetchCurrentPlatformUserDictionary().avatar
        user.username = iReadUserDefaults.fetchCurrentPlatformUserDictionary().username
        
        let isNew = user.avater_url.isEmpty
        user.avater_url = avatar
        user.saveInBackgroundWithBlock{
            result, error in
            if self.filterShowUpError(error) {
                iReadUserDefaults.updateAvatorIconURLString(avatar)
                print("imageURL\(avatar)--save-done")
            }
        }
        
        // 新用户存，旧用户读
        if isNew {
            uploadUserDataToServerWhenFirstOAuthed(user)
        } else {
            loadUserDataFromServerWhenOAuthed(user)
        }
        
    }
    
    private func uploadUserDataToServerWhenFirstOAuthed(user: Reader) {
        FeedResource.sharedResource.uploadUserFeedItemsToServer(user.objectId){
            error in
            if self.filterShowUpError(error) {
                print("😎upload items done \(user.objectId)")
            }
        }
        
        user.readTime = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey)
        user.readCounts = iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
        user.readMode = iReadUserDefaults.defaults.boolForKey(ReadModeKey)
        user.themeMode = iReadUserDefaults.defaults.boolForKey(ThemeModeKey)
        print(user)
        user.fetchWhenSave = true
        user.saveInBackgroundWithBlock{
            result, error in
            
            if self.filterShowUpError(error) {
                print("😎upload user done \(result)")
            }
        }
        
        uploadUserArticlesWithUserID(user.objectId)
        
    }
    
    private func uploadUserArticlesWithUserID(userID: String) {
        FeedResource.sharedResource.uploadUserArticlesToServer(userID){
            error in
            if self.filterShowUpError(error) {
                print("😎upload Articles done \(userID)")
            }
        }
    }
    
    private func loadUserDataFromServerWhenOAuthed(user: Reader) {
        loadUserInfoWithUser(user)
        loadUserItemsWithUserID(user.objectId)
        loadUserArticlesWithUserID(user.objectId)

    }
    
    private func loadUserInfoWithUser(user: Reader) {
        Reader.currentUser().fetchInBackgroundWithBlock{
            result, error in
            if self.filterShowUpError(error) {
                
                iReadUserDefaults.defaults.setInteger(user.readTime, forKey: ReadTimeIntervalKey)
                iReadUserDefaults.defaults.setInteger(user.readCounts, forKey: ReadCountsKey)
                iReadUserDefaults.defaults.setBool(user.readMode, forKey: ReadModeKey)
                iReadUserDefaults.defaults.setBool(user.themeMode, forKey: ThemeModeKey)
                
                print("😎download  Reader done \(user.objectId)")
            }
        }

    }
    
    private func loadUserItemsWithUserID(userID: String) {
        FeedResource.sharedResource.loadFeedItem{
            items, error in
            if let error = error {
                self.showupTopInfoMessage(error.localizedDescription)
            } else {
                FeedResource.sharedResource.items = items
                if self.filterShowUpError(error) {
                    print("😎download items done \(userID)")
                }
            }
        }
    }
    
    private func loadUserArticlesWithUserID(userID: String) {
        FeedResource.sharedResource.loadUserArticlesFromServer(userID){
            articles, error in
            if self.filterShowUpError(error) {
                FeedResource.sharedResource.articles = articles
                print("😎download articles done \(userID)")
            }
        }
    }
    
    private func handleOAuthEror(error: NSError) -> String {
        
        guard let errorTyep = AVOSCloudSNSErrorCode(rawValue: Int32(error.code)) else {
            
            assertionFailure("指定错误类型之外的授权错误\(error)")
            return "登录出错"
        }
        
        switch errorTyep {
        case .UserCancel:
            return "登录取消"
        case .TokenExpired:
            return "登录超时"
        case .CodeNotSupported:
            return "当前平台不支持网页登录"
        case .CodeAuthDataError:
            return "授权数据错误"
        case .LoginFail:
            return "登录失败"
        case .NeedLogin:
            return "无绑定用户"
        }
    }    
    
    func handleBindingDataError(error: NSError) {
        iReadAlert.showErrorMessage(title: "数据错误", message: "授权数据绑定异常", dismissTitle: "确定", inViewController: self)
    }
    
}

// MARK: - <#UITextFieldDelegate#>
extension LoginController : UITextFieldDelegate {
    
   	func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        let field = textField as! TextField
        updateDetailLabelStateInTextField(field)
        let shouldReturn = updateResponseStateInTextField(field)
        return shouldReturn
        
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let field = textField as! TextField
        updateDetailLabelStateInTextField(field)
        
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
    
    func shouldLoginAccount(username: String, password: String) -> Bool {
        
        let contentExist = !(username.isEmpty && password.isEmpty)
        let contentVaild = username.isVaildUsername() && password.isVaildPassword()
        
        return contentExist && contentVaild
    }
    
}

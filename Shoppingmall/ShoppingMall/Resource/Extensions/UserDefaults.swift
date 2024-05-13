import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case mobileDeviceId
        case showOnboarding
        case token
        case mobileUserId
        case mobileUserName
        case mobileUserSurname
        case mobileUserEmail
        case mobileUserPhoneNumber
        case userBalance
        case userPromoCode
        case appRating
    }
    
    var mobileDeviceId: String? {
        get {
            string(forKey: UserDefaultsKeys.mobileDeviceId.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.mobileDeviceId.rawValue)
        }
    }
    
    var showOnboarding: Bool? {
        get {
            Bool(bool(forKey: UserDefaultsKeys.showOnboarding.rawValue))
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.showOnboarding.rawValue)
        }
    }
    
    var token: String? {
        get {
            string(forKey: UserDefaultsKeys.token.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.token.rawValue)
        }
    }
    
    var mobileUserId: String? {
        get {
            string(forKey: UserDefaultsKeys.mobileUserId.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.mobileUserId.rawValue)
        }
    }
    
    var mobileUserName: String? {
        get {
            string(forKey: UserDefaultsKeys.mobileUserName.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.mobileUserName.rawValue)
        }
    }
    
    var mobileUserSurname: String? {
        get {
            string(forKey: UserDefaultsKeys.mobileUserSurname.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.mobileUserSurname.rawValue)
        }
    }
    
    var mobileUserEmail: String? {
        get {
            string(forKey: UserDefaultsKeys.mobileUserEmail.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.mobileUserEmail.rawValue)
        }
    }
    
    var mobileUserPhoneNumber: String? {
        get {
            string(forKey: UserDefaultsKeys.mobileUserPhoneNumber.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.mobileUserPhoneNumber.rawValue)
        }
    }
    
    var userBalance: Int? {
        get {
            integer(forKey: UserDefaultsKeys.userBalance.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.userBalance.rawValue)
        }
    }
    
    var userPromoCode: String? {
        get {
            string(forKey: UserDefaultsKeys.userPromoCode.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.userPromoCode.rawValue)
        }
    }
    
    var appRating: Int? {
        get {
            integer(forKey: UserDefaultsKeys.appRating.rawValue)
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.appRating.rawValue)
        }
    }
}

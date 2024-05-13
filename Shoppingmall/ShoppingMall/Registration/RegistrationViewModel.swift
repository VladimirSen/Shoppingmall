import Foundation
import Combine

final class RegistrationViewModel: ObservableObject {
    @Published var smsCode: String = ""
    @Published var wrongPromoCode = true
    @Published var isPhoneNumberEntered = false
    private var mobileDeviceId: String? {
        UserDefaults.standard.mobileDeviceId
    }
    private var token: String? {
        UserDefaults.standard.token
    }
    private let service = RegistrationService()
    var cancellables = Set<AnyCancellable>()
    
    func setupSmsCode(phone: String) {
        let data: [String: Any] = [
            "phone": phone
        ]
        service.smsCodePublisher(by: data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                } else {
                    self?.smsCode = "000000"
                }
            })
            .store(in: &cancellables)
    }
    
    func setupMobileUserAuth(phone: String, smsCode: String) {
        let data: [String: Any] = [
            "phone": phone,
            "smsCode": smsCode,
            "mobileDeviceId": mobileDeviceId ?? ""
        ]
        service.userAuthPublisher(by: data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let userData) = result {
                    UserDefaults.standard.mobileUserPhoneNumber = userData.phone
                    UserDefaults.standard.userPromoCode = userData.referralCode
                    UserDefaults.standard.token = userData.rememberToken
                    UserDefaults.standard.userBalance = userData.pointsBalance
                    UserDefaults.standard.mobileUserEmail = userData.email
                    UserDefaults.standard.appRating = userData.appEvaluation
                    if let (beforeUppercase, afterUppercase) = userData.name?.splitName() {
                        UserDefaults.standard.mobileUserName = beforeUppercase
                        UserDefaults.standard.mobileUserSurname = afterUppercase
                    }
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupToken() {
        let data: [String: Any] = ["token": token ?? ""]
        service.tokenPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let token) = result {
                    UserDefaults.standard.mobileUserId = token.mobileUserId
                    UserDefaults.standard.mobileDeviceId = token.id
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
        
    func setupMobileUserName(name: String, email: String) {
        let data: [String: Any] = [
            "token": token ?? "",
            "name": name,
            "email": email
        ]
        service.mobileUserPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let userData) = result {
                    if let (beforeUppercase, afterUppercase) = userData.name?.splitName() {
                        UserDefaults.standard.mobileUserName = beforeUppercase
                        UserDefaults.standard.mobileUserSurname = afterUppercase
                    }
                    UserDefaults.standard.mobileUserEmail = userData.email
                    UserDefaults.standard.userBalance = userData.pointsBalance
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupAddRegister() {
        service.addRegisterPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let userData) = result {
                    UserDefaults.standard.userBalance = (UserDefaults.standard.userBalance ?? 0) + (userData.changeBalance ?? 0)
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupMobileUserCode(code: String) {
        let data: [String: Any] = ["referral_code": code]
        service.promoCodePublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let userData) = result {
                    UserDefaults.standard.userBalance = (UserDefaults.standard.userBalance ?? 0) + (userData.changeBalance ?? 0)
                    self?.wrongPromoCode = false
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupMobileUserSurvey(dateBirth: String, haveKids: Bool) {
        let data: [String: Any] = [
            "token": token ?? "",
            "dateBirth": dateBirth,
            "haveKids": haveKids
        ]
        service.mobileUserPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let userData) = result {
                    UserDefaults.standard.userBalance = userData.pointsBalance
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupSurveyChange() {
        service.addSurveyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let userData) = result {
                UserDefaults.standard.userBalance = (UserDefaults.standard.userBalance ?? 0) + (userData.changeBalance ?? 0)
            } else if case .failure(let errorResponse) = result {
                AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
            }
            })
            .store(in: &cancellables)
    }
    
    func setupCheckPhone(phone: String) {
        let data: [String: Any] = [
            "phone": phone
        ]
        service.checkPhonePublisher(by: data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                } else {
                    self?.smsCode = "000000"
                    self?.isPhoneNumberEntered = true
                }
            })
            .store(in: &cancellables)
    }
    
    func setupChangePhone(phone: String, smsCode: String) {
        let data: [String: Any] = [
            "phone": phone,
            "sms_code": smsCode
        ]
        service.changePhonePublisher(by: data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let userData) = result {
                    UserDefaults.standard.mobileUserPhoneNumber = userData.phone
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
}

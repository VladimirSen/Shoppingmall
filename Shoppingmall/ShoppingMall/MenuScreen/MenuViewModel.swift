import Foundation
import Combine

final class MenuViewModel: ObservableObject {
    private let service = MenuService()
    var cancellables = Set<AnyCancellable>()
    
    func setupEventsPush(resetData: Bool) {
        let data: [String: Any]
        if resetData {
            data = ["enable_push_event": false]
        } else {
            data = ["enable_push_event": true]
        }
        service.pushPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupPromotionPush(resetData: Bool) {
        let data: [String: Any]
        if resetData {
            data = ["enable_push_promotion": false]
        } else {
            data = ["enable_push_promotion": true]
        }
        service.pushPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupChildrenEventsPush(resetData: Bool) {
        let data: [String: Any]
        if resetData {
            data = ["enable_push_children": false]
        } else {
            data = ["enable_push_children": true]
        }
        service.pushPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupAppFeedback(text: String, rating: Int) {
        let data: [String: Any] = [
            "mobile_device_id": UserDefaults.standard.mobileDeviceId ?? "",
            "text": text,
            "rating": rating
        ]
        service.appFeedbackPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let feedback) = result {
                    UserDefaults.standard.appRating = feedback.rating
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        let data: [String: Any] = [
            "mobileDeviceId": UserDefaults.standard.mobileDeviceId ?? "",
            "token": UserDefaults.standard.token ?? ""
        ]
        service.logoutPubliser(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                } else {
                    UserDefaults.standard.token = nil
                    UserDefaults.standard.mobileUserId = nil
                    UserDefaults.standard.mobileUserName = ""
                    UserDefaults.standard.mobileUserSurname = ""
                    UserDefaults.standard.mobileUserEmail = ""
                    UserDefaults.standard.mobileUserPhoneNumber = ""
                    UserDefaults.standard.userPromoCode = ""
                    UserDefaults.standard.userBalance = 0
                    UserDefaults.standard.appRating = 0
                }
            })
            .store(in: &cancellables)
    }
}

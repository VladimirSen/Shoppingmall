import UIKit.UIDevice
import Combine

final class ViewModel: ObservableObject {
    private let service: Service
    private var mobileDeviceId: String? {
        UserDefaults.standard.mobileDeviceId
    }
    var cancellables = Set<AnyCancellable>()
    
    init(service: Service) {
        self.service = service
    }
    
    func setupMobileDeviceId() {
        guard mobileDeviceId == nil else { return }
        let data: [String: Any] = [
            "install_app": Date().timeIntervalSince1970,
            "os": UIDevice.current.systemName,
            "version_os": UIDevice.current.systemVersion,
            "model": UIDevice.current.name
        ]
        service.mobileDeviceIdPublisher(by: data)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { result in
                if case .success(let device) = result {
                    UserDefaults.standard.mobileDeviceId = device.id
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupEventsPush() {
        let data: [String: Any] = ["enable_push_event": true]
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
}

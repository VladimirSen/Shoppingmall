import SwiftUI
import Combine

final class Service {
    func mobileDeviceIdPublisher(by data: [String: Any]) -> AnyPublisher<Result<MobileDevice, ResponseError>, DataError> {
        guard let url = URL(string: Constants.Path.mobileDevicePath) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(MobileDevice.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func pushPublisher(by data: [String: Any]) -> AnyPublisher<Result<SingleMobileDevice, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileDevicePath)/\(UserDefaults.standard.mobileDeviceId ?? "")/setting-push") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(SingleMobileDevice.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
}

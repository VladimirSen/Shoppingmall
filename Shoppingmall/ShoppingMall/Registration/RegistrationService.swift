import Foundation
import Combine

final class RegistrationService: ObservableObject {
    private var mobileDeviceId: String? {
        UserDefaults.standard.mobileDeviceId
    }
    private var mobileUserId: String? {
        UserDefaults.standard.mobileUserId
    }
    private var token: String? {
        UserDefaults.standard.token
    }
    
    func smsCodePublisher(by data: [String: Any]) -> AnyPublisher<Result<Void, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/login") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                if try JSONSerialization.jsonObject(with: data, options: []) is [Any] {
                    return .success(())
                } else {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func userAuthPublisher(by data: [String: Any]) -> AnyPublisher<Result<MobileUser, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/auth") else {
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
                    let response = try JSONDecoder().decode(MobileUser.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func mobileUserPublisher(by data: [String: Any]) -> AnyPublisher<Result<MobileUser, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(mobileUserId ?? "")") else {
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
                    let response = try JSONDecoder().decode(MobileUser.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func tokenPublisher(by data: [String: Any]) -> AnyPublisher<Result<Token, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileDevicePath)/\(mobileDeviceId ?? "")/token") else {
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
                    let response = try JSONDecoder().decode(Token.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func addRegisterPublisher() -> AnyPublisher<Result<ListTransaction, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(mobileUserId ?? "")/add-register") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "token")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(ListTransaction.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func promoCodePublisher(by data: [String: Any]) -> AnyPublisher<Result<ListTransaction, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(mobileUserId ?? "")/referral") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(ListTransaction.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func addSurveyPublisher() -> AnyPublisher<Result<ListTransaction, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(mobileUserId ?? "")/survey") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "token")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(ListTransaction.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }

    func checkPhonePublisher(by data: [String: Any]) -> AnyPublisher<Result<Void, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(mobileUserId ?? "")/check-phone") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                if try JSONSerialization.jsonObject(with: data, options: []) is [Any] {
                    return .success(())
                } else {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func changePhonePublisher(by data: [String: Any]) -> AnyPublisher<Result<MobileUser, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(mobileUserId ?? "")/change-phone") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(token, forHTTPHeaderField: "token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(MobileUser.self, from: data)
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

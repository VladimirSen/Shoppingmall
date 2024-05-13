struct MobileDevice: Decodable {
    let id: String
}

struct SingleMobileDevice: Decodable {
    let id: String
    let installApp: String
    let os: String
    let versionOs: String
    let model: String
    let enablePushPromotion: Bool
    let enablePushEvent: Bool
    let enablePushChildren: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case installApp = "install_app"
        case os
        case versionOs = "version_os"
        case model
        case enablePushPromotion = "enable_push_promotion"
        case enablePushEvent = "enable_push_event"
        case enablePushChildren = "enable_push_children"
    }
}

struct ResponseError: Decodable, Hashable, Error {
    let message: String?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "error_message"
        case text = "error_text"
    }
}

enum DataError: Error {
    case urlError
    case dataError
}

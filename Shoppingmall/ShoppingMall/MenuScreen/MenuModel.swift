struct Feedback: Decodable, Hashable {
    let id: String
    let mobileDeviceId: String
    let mobileUserId: String?
    let text: String?
    let rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mobileDeviceId = "mobile_device_id"
        case mobileUserId = "mobile_user_id"
        case text
        case rating
    }
}

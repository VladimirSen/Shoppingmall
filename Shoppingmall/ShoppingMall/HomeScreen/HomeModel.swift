struct News: Codable, Hashable {
    let id: String
    let type: String
    let title: String?
    let logoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case logoUrl = "logo_url"
    }
}

struct NewsDetail: Codable, Hashable {
    let id: String
    let title: String?
    let logoUrl: String?
    let content: String?
    let publishDate: String?
    let sitemap: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case logoUrl = "logo_url"
        case content
        case publishDate = "publish_date"
        case sitemap
    }
}

struct NewsAndPromotionListEntity: Decodable, Hashable {
    let id: String
    let type: String?
    let title: String?
    let logoUrl: String?
    let disclaimer: String?
    let date: DatePeriod?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case logoUrl = "logo_url"
        case disclaimer
        case date
    }
}

struct EventList: Decodable, Hashable {
    let id: String
    let title: String?
    let logoUrl: String?
    let date: DatePeriod?
    let eventPurchased: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case logoUrl = "logo_url"
        case date
        case eventPurchased = "event_purchased"
    }
}

struct Event: Decodable, Hashable {
    let id: String
    let title: String?
    let logoUrl: String?
    let content: String?
    let date: DatePeriod?
    let sitemap: String?
    let cost: Int?
    let eventPurchased: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case logoUrl = "logo_url"
        case content
        case date
        case sitemap
        case cost
        case eventPurchased = "event_purchased"
    }
}

struct DatePeriod: Decodable, Hashable {
    let start: String?
    let finish: String?
}

struct Promotion: Decodable, Hashable {
    let id: String
    let title: String?
    let logoUrl: String?
    let disclaimer: String?
    let startDate: String?
    let finishDate: String?
    let content: String?
    let sitemap: String?
    let offerId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case logoUrl = "logo_url"
        case disclaimer
        case startDate = "start_date"
        case finishDate = "finish_date"
        case content
        case sitemap
        case offerId = "offer_id"
    }
}

struct Offer: Decodable, Hashable, Identifiable {
    let id: String
    let shop: Shop
    let name: String?
    let disclaimer: String?
    let description: String?
    let confirmationConditions: String?
    let conditionsReceiving: String?
    let type: String?
    let cost: Int?
    let offerActivatedForMultiple: Bool
    let onHome: Bool
    let startAt: String?
    let endAt: String?
    let createdAt: String?
    let image: String?
    let offerPurchased: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case shop
        case name
        case disclaimer
        case description
        case confirmationConditions = "confirmation_conditions"
        case conditionsReceiving = "conditions_receiving"
        case type
        case cost
        case offerActivatedForMultiple = "offer_activated_for_multiple"
        case onHome = "on_home"
        case startAt = "start_at"
        case endAt = "end_at"
        case createdAt = "created_at"
        case image
        case offerPurchased = "offer_purchased"
    }
}

struct Services: Decodable, Hashable {
    let id: String
    let name: String?
    let logoUrl: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUrl = "logo_url"
        case description
    }
}

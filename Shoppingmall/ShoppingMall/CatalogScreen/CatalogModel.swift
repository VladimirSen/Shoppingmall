struct CategoryItem: Decodable, Hashable {
    let id: String
    let name: String
    let logoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUrl = "logo_url"
    }
}

struct Shop: Decodable, Hashable {
    let id: String
    let name: String?
    let logoUrl: String?
    let siteUrl: String?
    let images: [Images]?
    let floor: Int?
    let description: String?
    let promotions: [Promotion]?
    let offers: [Offer]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUrl = "logo_url"
        case siteUrl = "site_url"
        case images
        case floor
        case description
        case promotions
        case offers
    }
}

struct Images: Decodable, Hashable {
    let url: String
}

struct MobileUser: Decodable {
    let id: String
    let mobileId: String?
    let phone: String
    let name: String?
    let email: String?
    let gender: String?
    let registrationByPromoCode: Bool?
    let referralCode: String?
    let enablePushPromotion: Bool?
    let enablePushEvent: Bool?
    let enablePushChildren: Bool?
    let finishPoll: Bool?
    let dateBirth: String?
    let haveKids: Bool?
    let countInvitedUsers: Int?
    let pointsBalance: Int?
    let totalPointsAccumulated: Int?
    let totalPointsSpent: Int?
    let countOffersPurchased: Int?
    let maximumPurchasedOffers: Int?
    let appEvaluation: Int?
    let rememberToken: String?
    let createdAt: String?
    let hasFeedback: Bool?
    let countShare: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mobileId = "mobile_id"
        case phone
        case name
        case email
        case gender
        case registrationByPromoCode = "registration_by_promo_code"
        case referralCode = "referral_code"
        case enablePushPromotion = "enable_push_promotion"
        case enablePushEvent = "enable_push_event"
        case enablePushChildren = "enable_push_children"
        case finishPoll = "finish_poll"
        case dateBirth = "date_birth"
        case haveKids = "have_kids"
        case countInvitedUsers = "count_invited_users"
        case pointsBalance = "points_balance"
        case totalPointsAccumulated = "total_points_accumulated"
        case totalPointsSpent = "total_points_spent"
        case countOffersPurchased = "count_offers_purchased"
        case maximumPurchasedOffers = "maximum_purchased_offers"
        case appEvaluation = "app_evaluation"
        case rememberToken = "remember_token"
        case createdAt = "created_at"
        case hasFeedback = "has_feedback"
        case countShare = "count_share"
    }
}

struct Token: Decodable {
    let id: String
    let mobileUserId: String?
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case mobileUserId = "mobile_user_id"
        case token
    }
}

struct ListTransaction: Decodable, Hashable {
    let id: String
    let changeBalance: Int?
    let typeTransaction: String?
    let object: Object?
    let typeObject: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case changeBalance = "change_balance"
        case typeTransaction = "type_transaction"
        case object
        case typeObject = "type_object"
        case createdAt = "created_at"
    }
}

struct Object: Decodable, Hashable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let shopId: String?
    let name: String?
    let title: String?
    let disclaimer: String?
    let description: String?
    let confirmationConditions: String?
    let conditionsReceiving: String?
    let type: String?
    let cost: Int?
    let onHome: Bool
    let startAt: String?
    let endAt: String?
    let count: Int?
    let priority: Int?
    let archive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case shopId = "shop_id"
        case name
        case title
        case disclaimer
        case description
        case confirmationConditions = "confirmation_conditions"
        case conditionsReceiving = "conditions_receiving"
        case type
        case cost
        case onHome = "on_home"
        case startAt = "start_at"
        case endAt = "end_at"
        case count
        case priority
        case archive
    }
}

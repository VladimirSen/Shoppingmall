enum Constants {
    enum Path {
        static let serverPath = "https://skillbox.dev.instadev.net/api/v1"
        static let mobileDevicePath = "\(serverPath)/mobile-device"
        static let newsPath = "\(serverPath)/news"
        static let promitionsAndEventPath = "\(newsPath)/with/promotions-and-event"
        static let promotionPath = "\(serverPath)/promotions"
        static let offersPath = "\(serverPath)/offers"
        static let eventsPath = "\(serverPath)/events"
        static let shopsPath = "\(serverPath)/shops"
        static let categoryPath = "\(shopsPath)/category/slug"
        static let servicesPath = "\(categoryPath)/services"
        static let mobileUserPath = "\(serverPath)/mobile-users"
    }
}

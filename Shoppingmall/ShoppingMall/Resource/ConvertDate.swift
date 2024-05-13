import Foundation

func convertDateString(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    } else {
        return dateString
    }
}

func convertDateTS(_ timestamp: String) -> String {
    let date = Date(timeIntervalSince1970: Double(timestamp) ?? 0)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    dateFormatter.locale = Locale(identifier: "ru_RU")
    return dateFormatter.string(from: date)
}

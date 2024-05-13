import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            return try NSAttributedString(data: data,
                                          options: options,
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func splitName() -> (String, String)? {
        var uppercaseCount = 0
        for (index, char) in
                self.enumerated() where char.isUppercase {
            uppercaseCount += 1
            if uppercaseCount == 2 {
                let beforeUppercase = String(self[..<self.index(self.startIndex, offsetBy: index)])
                let afterUppercase = String(self[self.index(self.startIndex, offsetBy: index)...])
                return (beforeUppercase, afterUppercase)
            }
        }
        return nil
    }
}

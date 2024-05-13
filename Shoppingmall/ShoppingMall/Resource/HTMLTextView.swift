import SwiftUI

struct HTMLTextView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    var htmlText: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let textColor = colorScheme == .dark ? UIColor.white : UIColor.black
        if let attributedString = htmlText.htmlToAttributedString {
            uiView.attributedText = attributedString
            uiView.font = .systemFont(ofSize: 16)
            uiView.textColor = textColor
        }
    }
}

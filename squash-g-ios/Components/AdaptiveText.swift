import SwiftUI

// UILabel-backed SwiftUI view that automatically adjusts font size to fit width.
struct AdaptiveText: UIViewRepresentable {
    var text: String
    var maxFontSize: CGFloat = 72
    var weight: UIFont.Weight = .heavy
    var textColor: UIColor = .white
    var minimumScaleFactor: CGFloat = 0.35
    var isMonospacedDigits: Bool = true

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = minimumScaleFactor
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byClipping
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        if isMonospacedDigits {
            uiView.font = UIFont.monospacedDigitSystemFont(ofSize: maxFontSize, weight: weight)
        } else {
            uiView.font = UIFont.systemFont(ofSize: maxFontSize, weight: weight)
        }
        uiView.text = text
        uiView.textColor = textColor
    }
}

#if DEBUG
struct AdaptiveText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            AdaptiveText(text: "123", maxFontSize: 72, textColor: UIColor(red: 0.0, green: 0.82, blue: 1.0, alpha: 1.0))
                .frame(height: 80)
            AdaptiveText(text: "1000000", maxFontSize: 72, textColor: .systemPink)
                .frame(height: 80)
        }
        .padding()
        .background(Color.black)
    }
}
#endif

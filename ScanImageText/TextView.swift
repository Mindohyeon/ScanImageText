import SwiftUI
import AppKit

struct TextView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.alignment = .center
        textView.isEditable = true
        textView.isSelectable = true
        textView.delegate = context.coordinator
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.text = textView.string
            }
        }
    }
}

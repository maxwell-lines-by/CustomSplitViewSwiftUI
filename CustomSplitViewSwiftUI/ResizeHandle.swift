import Foundation
import SwiftUI

struct ResizeHandle: View {
    @Binding
    var width: CGFloat
    
    private let minWidth: CGFloat
    private let maxWidth: CGFloat
    private let flipped: Bool
    private let isCollapsible: Bool
    private let publishWidth : (CGFloat) -> Void
    
    init(width: Binding<CGFloat>, minWidth: CGFloat, maxWidth: CGFloat, flipped: Bool, isCollapsible: Bool, publishWidth: @escaping (CGFloat) -> Void) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.flipped = flipped
        self.isCollapsible = isCollapsible
        self.publishWidth = publishWidth
        self._width = width
    }
    
    @State private var isCollapsed = false

    var body: some View {
           Rectangle()
               .fill(Color.gray.opacity(0.5))
               .frame(width: 1)
               .onHover { hovering in
                   if hovering {
                       NSCursor.resizeLeftRight.push()
                   } else {
                       NSCursor.pop()
                   }
               }
               .gesture(
                   DragGesture()
                    .onChanged { value in
                        let translation = flipped ? -value.translation.width : value.translation.width
                        updateWidth(with: translation)
                    }
                       .onEnded { _ in
                           finalizeResize()
                       }
               )
       }
       
       private func updateWidth(with translation: CGFloat) {
           let newWidth = width + translation           
           if isCollapsible && newWidth < minWidth {
               // Cancel the gesture by not updating the width
               isCollapsed = true
               finalizeResize()
           } else {
               publishWidth(min(max(minWidth, newWidth), maxWidth))
               isCollapsed = false
           }
       }
       
       private func finalizeResize() {
           if isCollapsible && isCollapsed {
               withAnimation(.easeOut(duration: 0.2)) {
                   publishWidth(0)
               }
           }
       }
}

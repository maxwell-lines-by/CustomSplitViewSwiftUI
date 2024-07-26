import Foundation
import SwiftUI

class SplitViewModel: ObservableObject {
    
    let sideBarMinWidth = 200.0
    let sideBarMaxWidth = 300.0

    let detailsMinWidth = 200.0
    let detailsIdealWidth = 300.0
    let detailsMaxWidth = 500.0
    
    let mainLayoutMinWidth = 400.0
    
    @Published
    var showDetails = false
    
    @Published
    var showMainColumn = true
    
    /// changes when window is resized, represents total width of window
    @Published
    private(set) var availableWidth: CGFloat = 1000
    
    @Published
    private(set) var sidebarWidth: CGFloat = 200
    
    @Published
    private(set) var detailsWidth: CGFloat = 0
 
    
    var mainLayoutWidth: CGFloat {
        get {
            return showMainColumn ? availableWidth - (sidebarWidth + detailsWidth) : mainLayoutMinWidth
        }
    }
    
    var swipeEventMontior: Any?
    let swipeThreshold: CGFloat = 20

    init(){
        addTwoFingerSwipe()
    }
    
    func addTwoFingerSwipe() {
        swipeEventMontior = NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { [weak self] event in
            self?.handleScrollEvent(event)
            return event
        }
    }
    
    @objc
    func handleScrollEvent(_ event: NSEvent) {
        if event.phase == .changed {
            // The gesture is ongoing
            let deltaX = event.scrollingDeltaX
            let deltaY = event.scrollingDeltaY

            // Determine the direction of the swipe
            if abs(deltaX) > abs(deltaY) {
                if deltaX > swipeThreshold && showDetails {
                    Task { @MainActor in
                        setShowDetails(to: false)
                    }
                }
            }
        }
    }
    
    // called when window is resizing
    public func setAvailableWidth(to newVal: CGFloat){
        availableWidth = newVal
        
        // checks if window is small enough that the middle column should be collapsed
        if showMainColumn && showDetails{
            hideMainColumnIfNeeded()
            return
        // checks if window is large enough that the middle column can be expanded
        } else if !showMainColumn {
                if availableWidth - sidebarWidth > mainLayoutMinWidth + detailsIdealWidth{
                    withAnimation{
                        detailsWidth = availableWidth - sidebarWidth

                        detailsWidth = availableWidth - (sidebarWidth + mainLayoutMinWidth)
                        showMainColumn = true
                    }
                } else {
                    detailsWidth = availableWidth - sidebarWidth
                }
            }
        }
    
    public func setDetailsWidth(to newVal: CGFloat){
        // if details are hidden, set to 0 and set show Details to false
        if !showDetails || newVal == 0{
            showDetails = false
            withAnimation {
                detailsWidth = 0
            }
            return
        }
 
        // if details is the only column available, it should fill the space
        if showDetails && !showMainColumn {
            withAnimation {
                detailsWidth = availableWidth - sidebarWidth
            }
            return
        }
        // otherwise, respond to drag gesture and set
        detailsWidth = newVal

        // check if main column should be collapsed
        hideMainColumnIfNeeded()
    }
    
    public func setSideBarWidth(to newVal: CGFloat){
        sidebarWidth = newVal
        hideMainColumnIfNeeded()
    }
    
    public func toggleShowDetails(){
        setShowDetails(to: !showDetails)
    }
    
    public func setShowDetails(to newVal: Bool){
        guard showDetails != newVal else {return}
        showDetails = newVal
        
        if showDetails {
            setDetailsWidth(to: detailsIdealWidth)
        } else {
            setDetailsWidth(to: 0)
            showMainColumn = true
        }
    }
    
    private func hideMainColumnIfNeeded() {
        if mainLayoutWidth < mainLayoutMinWidth && showDetails {
            showMainColumn = false
            withAnimation{
                detailsWidth = availableWidth - sidebarWidth
            }
        }
    }
}

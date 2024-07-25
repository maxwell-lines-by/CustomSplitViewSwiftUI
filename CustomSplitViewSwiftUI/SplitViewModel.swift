import Foundation
import SwiftUI

class SplitViewModel: ObservableObject {
    
    let sideBarMinWidth = 200.0
    let sideBarMaxWidth = 300.0

    let detailsMinWidth = 200.0
    let detailsIdealWidth = 300.0
    let detailsMaxWidth = 500.0
    
    let mainLayoutMinWidth = 400.0
    
    private var showDetails = false
    private var showMainColumn = true
    
    /// changes when window is resized, represents total width of window
    @Published
    private(set) var availableWidth: CGFloat = 1000
    
    @Published
    var sidebarWidth: CGFloat = 200
    
    @Published
    var detailsWidth: CGFloat = 0
 
    
    var mainLayoutWidth: CGFloat {
        get {
            return availableWidth - (sidebarWidth + detailsWidth)
        }
    }
    
    // called when window is resizing
    public func setAvailableWidth(to newVal: CGFloat){
        print("set availableWidth to \(newVal)")
        availableWidth = newVal
        
        // checks if window is small enough that the middle column should be collapsed
        if showMainColumn && showDetails{
            hideMainColumnIfNeeded()
            return
        // checks if window is large enough that the middle column can be expanded
        } else if !showMainColumn {
            detailsWidth = availableWidth - sidebarWidth
                if detailsWidth > mainLayoutMinWidth + detailsIdealWidth{
                    withAnimation{
                        detailsWidth = availableWidth - (sidebarWidth + mainLayoutMinWidth)
                        showMainColumn = true
                    }
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
            showMainColumn = true
            setDetailsWidth(to: 0)
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

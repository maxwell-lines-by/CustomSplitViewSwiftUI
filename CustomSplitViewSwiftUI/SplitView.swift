//
//  ContentView.swift
//  3-Col-SwiftUI
//
//  Created by Maxwell Altman on 7/23/24.
//

import SwiftUI

struct SplitView: View {
    @StateObject
    var viewModel = SplitViewModel()
                                 
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                SideBar()
                    .frame(width: viewModel.sidebarWidth)
                    .frame(maxHeight: .infinity)
                ResizeHandle(width: $viewModel.sidebarWidth, minWidth: viewModel.sideBarMinWidth, maxWidth: viewModel.sideBarMaxWidth, flipped: false, isCollapsible: false, publishWidth: viewModel.setSideBarWidth)
           
                MainLayout(toggleShowDetails: viewModel.toggleShowDetails)
                    .frame(width:  viewModel.mainLayoutWidth)
                    .frame(maxHeight: .infinity)
                    .clipped()
                
                ResizeHandle(width: $viewModel.detailsWidth, minWidth: viewModel.detailsMinWidth, maxWidth: viewModel.detailsMaxWidth, flipped: true, isCollapsible: true, publishWidth: viewModel.setDetailsWidth)
                Details(setShowDetails: viewModel.setShowDetails)
                    .frame(width: viewModel.detailsWidth)
                    .frame(maxHeight: .infinity)
                    .clipped()
            }
            .onChange(of: geometry.size.width, { (newWidth,_) in
                viewModel.setAvailableWidth(to: geometry.size.width)
            })
        }
    }
}

#Preview {
        SplitView()
}


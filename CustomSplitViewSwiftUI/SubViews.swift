import SwiftUI
import Foundation

struct SideBar: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("SideBar")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
}

struct MainLayout: View {
    let toggleShowDetails : () -> Void

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("MainLayout")
            Button("Toggle Details") {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.65, blendDuration: 0)) {
                    toggleShowDetails()
            }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
        .padding()
    }
}

struct Details: View {
    let setShowDetails : (Bool) -> Void

    var body: some View {
        VStack {
            Button("Close Details") {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.65, blendDuration: 0)) {
                    setShowDetails(false)
                }
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Details")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}

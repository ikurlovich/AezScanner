import SwiftUI

struct TabBarView: View {
    @StateObject
    private var coordinator = TabBarCoordinator()
    
    var body: some View {
        VStack {
            VStack {
                switch coordinator.currentView {
                case 2:
                    BluetoothView()
                case 3:
                    HistoryView()
                default:
                    LanView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            tabBarBody()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func tabBarBody() -> some View {
        Capsule()
            .foregroundStyle(.white)
            .frame(width: 290, height: 80)
            .shadow(color: .gray, radius: 10, x: 2, y: 2)
            .overlay(content: animationCircle)
            .overlay(content: tabItems)
    }
    
    @ViewBuilder
    private func tabItems() -> some View {
        HStack {
            tabItem(index: 1, image: .wifi)
            tabItem(index: 2, image: .bluetooth)
                .frame(maxWidth: .infinity)
            tabItem(index: 3, image: .list)
        }
        .padding(.horizontal, 28)
    }
    
    
    @ViewBuilder
    private func tabItem(index: Int, image: ImageResource) -> some View {
        Image(image)
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundStyle(index == coordinator.currentView
                             ? .white
                             : .gray)
            .scaleEffect(index == coordinator.currentView
                         ? 1
                         : 0.8)
            .animation(.easeInOut, value: coordinator.currentView)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.chooseView(index)
            }
    }
    
    @ViewBuilder
    private func animationCircle() -> some View {
        Circle()
            .frame(width: 60)
            .foregroundStyle(.accent)
            .offset(x: indexOffset())
            .animation(.easeInOut, value: coordinator.currentView)
    }
    
    private func indexOffset() -> CGFloat {
        switch coordinator.currentView {
        case 1:
            -102
        case 3:
            +102
        default:
            0
        }
    }
}

#Preview {
    TabBarView()
}

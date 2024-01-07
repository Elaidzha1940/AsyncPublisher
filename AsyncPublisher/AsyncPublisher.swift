//  /*
//
//  Project: AsyncPublisher
//  File: ContentView.swift
//  Created by: Elaidzha Shchukin
//  DAte: 07.01.2024
//
//  */

import SwiftUI

actor AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        myData.append("Melon")
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        myData.append("Banana")
    }
}

class AsyncPublisherViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisher: View {
    @StateObject private var viewModel = AsyncPublisherViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisher()
}

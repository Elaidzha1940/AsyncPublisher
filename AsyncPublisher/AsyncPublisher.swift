//  /*
//
//  Project: AsyncPublisher
//  File: ContentView.swift
//  Created by: Elaidzha Shchukin
//  DAte: 07.01.2024
//
//  */

import SwiftUI
import Combine

class AsyncPublisherDataManager {
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
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            await MainActor.run {
                self.dataArray = ["One"]
            }
            
            for await value in manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
                break
            }
            
            await MainActor.run {
                self.dataArray = ["Two"]
            }
        }
        //        manager.$myData
        //            .receive(on: DispatchQueue.main, options: nil)
        //            .sink { dataArray in
        //                self.dataArray = dataArray
        //            }
        //            .store(in: &cancellables)
    }
    
    
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

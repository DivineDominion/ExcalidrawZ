//
//  ContentView.swift
//  ExcaliDrawZ
//
//  Created by Dove Zachary on 2022/12/25.
//

import SwiftUI
import Foundation


struct ContentView: View {
    @EnvironmentObject var store: AppStore
    @ObservedObject var fileManager: AppFileManager = .shared
    
    @State private var dirMonitor = DirMonitor(dir: AppFileManager.shared.assetDir,
                                               queue: .init(label: "com.chocoford.ExcaliDrawZ-DirMonitor"))
    
    private var hasError: Binding<Bool> {
        store.binding(for: \.hasError) {
            .setHasError($0)
        }
    }
    
    var body: some View {
        content
        .alert(isPresented: hasError,
               error: store.state.error,
               actions: { error in
            
        }, message: { error in
            
        })
    }

    
    @ViewBuilder private var content: some View {
        NavigationSplitView {
            GroupSidebarView()
        } content: {
            FileListView()
        } detail: {
            ExcaliDrawView()
        }
        .toolbar(content: toolbarContent)
        .onAppear(perform: startMonitorFiles)
        .onReceive(dirMonitor.dirWillChange) { _ in
            store.send(.loadAssets)
        }
    }
}

extension ContentView {
    func createNewFile() {
        store.send(.newFile)
    }
    
    func startMonitorFiles() {
        guard dirMonitor.start() else {
            store.send(.setError(.dirMonitorError(.startFailed)))
            return
        }
        store.send(.loadAssets)
    }
}

// MARK: - Toolbar Content
extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
#if os(iOS)
        toolbarContent_iOS()
#else
        toolbarContent_macOS()
#endif
    }
    
#if os(iOS)
    @ToolbarContentBuilder
    private func toolbarContent_iOS() -> some ToolbarContent {
   
    }
#else
    @ToolbarContentBuilder
    private func toolbarContent_macOS() -> some ToolbarContent {
        ToolbarItemGroup(placement: .status) {
            Text(store.state.currentFile?.lastPathComponent ?? "Untitled.excalidraw")
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            Spacer()
            // import
            Button {
                let panel = ExcaliDrawOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.init(filenameExtension: "excalidraw")].compactMap{ $0 }
                if panel.runModal() == .OK {
                    if let url = panel.url {
                        store.send(.importFile(url))
                    } else {
                        store.send(.setError(.fileError(.invalidURL)))
                    }
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            
            // create
            Button {
                createNewFile()
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
    }
#endif
}



#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppStore.preview)
            .frame(minWidth: 800, minHeight: 600)
    }
}
#endif

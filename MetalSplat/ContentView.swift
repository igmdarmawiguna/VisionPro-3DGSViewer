//
//  ContentView.swift
//  MetalSplat
//
//  Created by FIT Monash on 30/10/2025.
//

import SwiftUI
import RealityKit
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isPickingFile = false

#if os(macOS)
    @Environment(\.openWindow) private var openWindow
#elseif os(iOS)
    @State private var navigationPath = NavigationPath()

    private func openWindow(value: ModelIdentifier) {
        navigationPath.append(value)
    }
#elseif os(visionOS)
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    

    @State var immersiveSpaceIsShown = false
    
    private func openWindow(value: ModelIdentifier) {
        Task {
            switch await openImmersiveSpace(value: value) {
            case .opened:
                immersiveSpaceIsShown = true
            case .error, .userCancelled:
                break
            @unknown default:
                break
            }
        }
    }
#endif

    
    var body: some View {
        mainView
    }
    
    let splatFiles: [String] = [
            "pura1.ply",
            "temple-ftk.ply",
            "gs-Initial_18.ply",
            "Pura_19.ply"
        ]
    
    private func openGaussian(named name: String) {
            let path = "/Users/fitmonash/Documents/LearnProjects/VisionProjects/MetalSplat/MetalSplat/Data/\(name)"
            let fileURL = URL(fileURLWithPath: path)
            openWindow(value: ModelIdentifier.gaussianSplat(fileURL))
            
            print("🟢 Opening:", fileURL.lastPathComponent)
        }
    
    @ViewBuilder
    var mainView: some View {
        
        VStack {
            Spacer()

            Text("Gaussian Splat Viewer")
                            .font(.title)
                            .bold()
            HStack {
                ForEach(splatFiles, id: \.self) { name in
                    Button("Show \(name)") {
                        openGaussian(named: name)
                            
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Spacer()

            Button("Show Sample Box") {
                openWindow(value: ModelIdentifier.sampleBox)
            }
            .padding()
            .buttonStyle(.borderedProminent)
#if os(visionOS)
            .disabled(immersiveSpaceIsShown)
#endif

            Spacer()

#if os(visionOS)
            Button("Dismiss Immersive Space") {
                Task {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
            .disabled(!immersiveSpaceIsShown)

            Spacer()
#endif // os(visionOS)
        }
    }
}


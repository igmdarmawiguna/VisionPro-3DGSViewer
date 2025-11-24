//
//  MetalSplatApp.swift
//  MetalSplat
//
//  Created by FIT Monash on 30/10/2025.
//

import CompositorServices
import SwiftUI

@main
struct MetalSplatApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup ("MetalSplatter Sample App", id: "main"){
            ContentView()
                .environment(appModel)
        }

        /*ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)*/

#if os(visionOS)
        ImmersiveSpace(for: ModelIdentifier.self) { modelIdentifier in
            CompositorLayer(configuration: ContentStageConfiguration()) { layerRenderer in
                let renderer = VisionSceneRenderer(layerRenderer)
                do {
                    try renderer.load(modelIdentifier.wrappedValue)
                } catch {
                    print("Error loading model: \(error.localizedDescription)")
                }
                renderer.startRenderLoop()
            }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
       
#endif // os(visionOS)
     }
}

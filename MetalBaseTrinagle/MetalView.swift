//
//  MetalView.swift
//  MetalBaseTrinagle
//
//  Created by Артем Соловьев on 12.05.2025.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    func makeCoordinator() -> MetalRender {
        MetalRender()
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.clearColor = MTLClearColor(
            red: 0.1,
            green: 0.1,
            blue: 0.1,
            alpha: 0.1
        )
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

//
//  MetalRender.swift
//  MetalBaseTrinagle
//
//  Created by Артем Соловьев on 12.05.2025.
//

import MetalKit

final class MetalRender: NSObject, MTKViewDelegate {
    var dedive: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    
    private var vertexFunction: MTLFunction?
    private var fragmentFunction: MTLFunction?
    
    //MARK: - SIMD2 тип предоствляющий вектор из двух точек. В нашем случае это будут точки вершин треугольника
    private let verticesData: [SIMD2<Float>] = [
        SIMD2<Float>(0.0, 0.5), //TOP
        SIMD2<Float>(-0.8, -0.6), //LEFT
        SIMD2<Float>(0.8, -0.6) //RIGHT
    ]
    
    override init() {
        super.init()
        self.dedive = MTLCreateSystemDefaultDevice()
        self.commandQueue = dedive.makeCommandQueue()
        vertexBuffer = dedive.makeBuffer(
            bytes: verticesData,
            length: MemoryLayout<SIMD2<Float>>.stride * verticesData.count
        )
        
        setupShaders()
        
        guard let vertexFunction = vertexFunction,
              let fragmentFunction = fragmentFunction
        else {
            print("Vertext and Fragment function not initiated")
            return
        }
        
        setupPipeline(
            withVertexFunction: vertexFunction,
            andFragmentFunction: fragmentFunction
        )
    }
    
    private func setupPipeline(
        withVertexFunction: MTLFunction,
        andFragmentFunction: MTLFunction
    ) {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try dedive.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch(let error) {
            print("Pipeline not started: \(error)")
        }
    }
    
    private func setupShaders() {
        let library = dedive.makeDefaultLibrary()!
        //MARK: - Достаем наши шейдер функции из файла Shaders.metal
        vertexFunction = library.makeFunction(name: "vertex_main")
        fragmentFunction = library.makeFunction(name: "fragment_main")
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("Buffer not initiated")
            return
        }
        
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        encoder.setRenderPipelineState(pipelineState)
        
        encoder.setVertexBuffer(
            vertexBuffer,
            offset: 0,
            index: 0
        )
        encoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: 3
        )
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}

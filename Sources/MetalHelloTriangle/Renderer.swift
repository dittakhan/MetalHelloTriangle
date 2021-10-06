import MetalKit

let DEFAULT_SHADER_LIB_LOCAL_PATH = "/Sources/Shaders/HelloTriangle.metallib" // NEW LINE

let VERTEX_DATA: [SIMD3<Float>] =
[
    // v0
    [ 0.0,  1.0, 0.0 ], // position
    [ 1.0,  0.0, 0.0 ], // color
    // v1
    [-1.0, -1.0, 0.0 ],
    [ 0.0,  1.0, 0.0 ],
    // v2
    [ 1.0, -1.0, 0.0 ],
    [ 0.0,  0.0, 1.0 ]
]

class Renderer: NSObject
{
    public var mView: MTKView
    private var mPipeline: MTLRenderPipelineState
    private let mCommandQueue: MTLCommandQueue


    public init(view: MTKView)
    {
        mView = view

        guard let commandQueue = mView.device?.makeCommandQueue() else
        {
            fatalError("Could not create command queue");
        }
        
        mCommandQueue = commandQueue

        let shaderLibPath = FileManager.default.currentDirectoryPath + DEFAULT_SHADER_LIB_LOCAL_PATH
        guard let library = try! mView.device?.makeLibrary(filepath: shaderLibPath) else
        {
            fatalError("No shader library!")
        }

        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format      = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset      = 0
        vertexDescriptor.attributes[1].format      = .float3
        vertexDescriptor.attributes[1].bufferIndex = 0 
        vertexDescriptor.attributes[1].offset      = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.layouts[0].stride         = MemoryLayout<SIMD3<Float>>.stride * 2

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = mView.colorPixelFormat
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
        pipelineDescriptor.vertexDescriptor = vertexDescriptor 

        guard let pipelineState = try! mView.device?.makeRenderPipelineState(descriptor: pipelineDescriptor) else
        {
            fatalError("Couldn't create pipeline state")
        }
        mPipeline = pipelineState

        super.init()
        mView.delegate = self
    }

    private func update()
    {
        // print("Renderer update")
        let dataSize = VERTEX_DATA.count * MemoryLayout.size(ofValue: VERTEX_DATA[0])
        let vertexBuffer = mView.device?.makeBuffer(bytes:   VERTEX_DATA,
                                                    length:  dataSize,
                                                    options: []) 

        let commandBuffer  = mCommandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: mView.currentRenderPassDescriptor!)

        commandEncoder?.setRenderPipelineState(mPipeline)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle,
                                    vertexStart: 0,
                                    vertexCount: 3,
                                    instanceCount: 1)
        commandEncoder?.endEncoding()
        commandBuffer.present(mView.currentDrawable!)
        commandBuffer.commit()       
    }
}


extension  Renderer: MTKViewDelegate 
{
    public func draw(in view: MTKView)
    {
        self.update()
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        // This will be called on resize
    }
    
}
import SwiftUI
import MetalKit

class MTLRender: NSObject, MTKViewDelegate
{
	private let device = MTLCreateSystemDefaultDevice()
	private var commandQueue: MTLCommandQueue?
	private var texture: MTLTexture?
	private var texturePtr: UnsafeMutableRawPointer?
    
    override init(){}
    
	func initWithView(_ view: MTKView)
	{
		view.delegate = self
		view.device = device
		self.commandQueue = device?.makeCommandQueue()
        NSLog("zxx commandQueue:", commandQueue)
		let textureDescriptor = MTLTextureDescriptor()
		textureDescriptor.pixelFormat = .rgba8Unorm
		self.texture = device?.makeTexture(descriptor: textureDescriptor)
        NSLog("zxx texture:", texture)
        self.texturePtr = withUnsafeMutablePointer(to: &texture, { UnsafeMutableRawPointer($0) })
        NSLog("zxx:", texturePtr)
	}

	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) 
	{
		CParsec.setFrame(size.width, size.height, view.contentScaleFactor)
	}

	func draw(in view: MTKView)
	{
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {return}
        renderCommandEncoder.endEncoding()
        CParsec.renderFrame(.metal, cq: &commandQueue!, texturePtr:&texturePtr)
        
	}
}
 

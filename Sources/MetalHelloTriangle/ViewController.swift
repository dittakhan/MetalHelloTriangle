import Cocoa
import MetalKit

class ViewController: NSViewController
{
    private var mDevice: MTLDevice?
    private var mRenderer: Renderer?

    override func loadView()
    {
        print("ViewController loadView")

        mDevice = MTLCreateSystemDefaultDevice()

        let rect = NSRect(x:0, y:0, width: WIDTH, height: HEIGHT)
        let mtkView = MTKView(frame: rect, device: mDevice)
        mRenderer = Renderer(view: mtkView)

        view = mtkView

        // view.wantsLayer = true
        // view.layer?.backgroundColor = NSColor.red.cgColor
    }
}
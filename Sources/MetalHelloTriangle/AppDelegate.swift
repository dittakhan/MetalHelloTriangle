import Cocoa

let WIDTH = 800
let HEIGHT = 600

class AppDelegate: NSObject, NSApplicationDelegate
{
    private var mWindow: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        print("AppDelegate applicationDidFinishLaunching")

        let screenSize = NSScreen.main?.frame.size ?? .zero

        let rect = NSMakeRect((screenSize.width  - CGFloat(WIDTH))  * 0.5,
            (screenSize.height - CGFloat(HEIGHT)) * 0.5,
            CGFloat(WIDTH),
            CGFloat(HEIGHT))

        mWindow = NSWindow(contentRect: rect,
                       styleMask:   [.miniaturizable,
                                     .closable,
                                     .resizable,
                                     .titled],
                        backing:    .buffered,
                        defer:      false)

        mWindow?.title = "Hello Triangle!"
        mWindow?.contentViewController = ViewController()
        mWindow?.makeKeyAndOrderFront(nil)
    }
}

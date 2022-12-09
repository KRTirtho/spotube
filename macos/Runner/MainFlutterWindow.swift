import flutter_acrylic
import Cocoa
import FlutterMacOS
import bitsdojo_window_macos

class MainFlutterWindow: BitsdojoWindow {
  override func bitsdojo_window_configure() -> UInt {
    return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }

  override func awakeFromNib() {
    let windowFrame = self.frame
    let blurryContainerViewController = BlurryContainerViewController()
    self.contentViewController = blurryContainerViewController
    self.setFrame(windowFrame, display: true)

    /* Initialize the flutter_acrylic plugin */
    MainFlutterWindowManipulator.start(mainFlutterWindow: self)

    RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)

    super.awakeFromNib()
  }
}

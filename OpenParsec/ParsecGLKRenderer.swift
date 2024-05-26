import GLKit
import ParsecSDK

class ParsecGLKRenderer:NSObject, GLKViewDelegate, GLKViewControllerDelegate
{
	var glkView:GLKView
	var glkViewController:GLKViewController
    var lastWidth:CGFloat
	//var FramesNotFlush:UInt32
	init(_ view:GLKView, _ viewController:GLKViewController)
	{
		glkView = view
		glkViewController = viewController
        lastWidth = 1.0
		//FramesNotFlush = 0
		super.init()

		glkView.delegate = self
		glkViewController.delegate = self
	}

	deinit
	{
		glkView.delegate = nil
		glkViewController.delegate = nil
	}

	func glkView(_ view:GLKView, drawIn rect:CGRect)
	{
		CParsec.pollAudio()
		let deltaWidth: CGFloat = view.frame.size.width - lastWidth
		if deltaWidth > 0.1 || deltaWidth < -0.1
		{
		    CParsec.setFrame(view.frame.size.width, view.frame.size.height, view.contentScaleFactor)
	        lastWidth = view.frame.size.width
		}
        CParsec.renderFrame(.opengl, cq: nil, texturePtr: nil)
		glFlush()

	}

	func glkViewControllerUpdate(_ controller:GLKViewController) { }
}

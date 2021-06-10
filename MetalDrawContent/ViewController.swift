//
//  ViewController.swift
//  MetalDrawContent
//  此示例演示通过Metal框架进行View的绘制
//
//  Created by Stork_lixiaojun on 2021/6/10.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    @IBOutlet weak var mtkView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        doInit()
    }
    
    private func doInit(){
        mtkView.device = MTLCreateSystemDefaultDevice()
        //将MTKView的背景抹去为背景色
        mtkView.clearColor = MTLClearColorMake(1.0, 1.0, 0.0, 1.0)
        //将View设置成在需要时才刷新
        mtkView.enableSetNeedsDisplay = true
        mtkView.delegate = self
    }


}

//实现MTKViewDelegate，以便
//在MTKView需要绘制的时候回调
extension ViewController:MTKViewDelegate{
    
    //绘制的时候回调
    func draw(in view: MTKView) {
        //为了绘制，需要创建一个Render Pass<暂时翻译成渲染通道>
        //渲染通道 是一组渲染命令 通往 一组textures<纹理:GPU能识别的可以绘制的一块内存区域>的通道
        //当textures被使用在Render Pass中时，textures也被称为render targets<渲染目标>
        //要想创建一个Render Pass渲染通道，必须先创建一个Render Pass descriptor<渲染管道描述符>
        let renderPassDes = mtkView.currentRenderPassDescriptor
        if renderPassDes == nil {
            return
        }
        ///创建CommandQueue
        let commandQueue = view.device?.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        //创建Render Pass<渲染通道>
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes!)
        commandEncoder?.endEncoding()
        //注意，并不是所有的纹理<textures>都会显示在屏幕上(当前个人理解:有些纹理可能是用来计算)
        //为了显示在屏幕上，在Metal中，是使用Drawable对象来实现的
        let drawable = view.currentDrawable
        //present方法告诉Metal,当commandBuffer被执行的时候，当渲染完成时，就显示出来
        commandBuffer?.present(drawable!)
        //由于你执行了所有的操作，现在可以提交commandBuffer了
        commandBuffer?.commit()
        
    }
    
    //当绘制内容尺寸发生改变的时候
    //比如 横竖屏切换时
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
}

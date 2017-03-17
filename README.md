
# ARAPointSilder
是一款类似于开关的Silder,具有点击响应,和滑动响应,直接
              自定义通过绘制来显示图片 
我们可以通过各种属性来设置这个silder的样式: 
         
![这是列子](https://github.com/AnRanScheme/ARAPointSilder/raw/master/ARASlider/Untitled.gif)
           
因为只是一个简单的自定义控件在这里就不多说了
          
我们可以设置line的图片,还可以设置滑块的图片

如何创建:  

       let silder = ARAPointSilder()
            silder.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
            silder.center = view.center
            silder.type = .point
            silder.continuous = false
            silder.pointWidth = 20
            silder.numberOfPoint = 4
            silder.titleAttributes = [NSForegroundColorAttributeName: UIColor.red, 
                                      NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!]
            silder.titleArray = ["面议","报价","你看你","傻不傻"]
            silder.addTarget(self, action: #selector(printNumber(sender:)), for: .valueChanged)
            view.addSubview(silder)

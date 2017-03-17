//
//  ARAPointSilder.swift
//  ARASlider
//
//  Created by 安然 on 17/3/14.
//  Copyright © 2017年 安然. All rights reserved.
//

import UIKit

enum ARAPointSilderType: Int {
    case normal = 0
    case point
}

class ARAPointSilder: UIControl {
    
    // MARK: - 属性
    
    /// 滑条的类型
    var type: ARAPointSilderType = .normal
    
    /// 滑块的颜色
    var thumbColor: UIColor = UIColor.white
    
    /// 滑块的图片
    var thumbImage: UIImage?
    
    /// 滑块的大小
    var thumbSize: CGSize = CGSize(width: 25, height: 25)
    
    /// 滑块的点击范围，默认是2倍
    var thumbTouchRate: CGFloat = 2.0
    
    /// 滑块边框颜色
    var thumbBordColor: UIColor = UIColor.blue
    
    /// 类型为普通时，使用value
    var value: CGFloat = 0.0 {
        didSet {
            if value <= minimumValue {
                value = minimumValue
            }
            if value >= maximumValue {
                value = maximumValue
            }
        }
    }

    /// 最大值
    var maximumValue:CGFloat = 1.0
    
    /// 最小值
    var minimumValue:CGFloat = 0.0
    
    /// 最大值的滑动颜色
    var maximumValueTrackColor: UIColor = UIColor.cyan
    
    /// 最小值的滑动颜色
    var minimumValueTrackColor: UIColor = UIColor.red
    
    /// 值变化是否是连续的
    var continuous: Bool = true
    
    /// 类型为点，使用index
    var index: Int = 0 {
        didSet {
            if index >= numberOfPoint {
                index = numberOfPoint - 1
            } else if index < 0 {
                index = 0
            }
        }
    }
    
    /// 点数的point数 默认是5级,最低是2级
    var numberOfPoint: Int = 5 {
        didSet {
            if numberOfPoint < 2 {
                numberOfPoint = 2
            }
        }
    }
    
    /// point点击范围，默认是point大小的2倍 pointTouchRate ＝ 2
    var pointTouchRate: CGFloat = 2.0
    
    /// 设置point的颜色
    var pointColor: UIColor = UIColor.cyan
    
    /// 设置Point的大小
    var pointWidth: CGFloat?
    
    /// 设置slider的左右间隔
    var margin: CGFloat = 30.0
    
    /// 滑条的颜色
    var lineColor: UIColor = UIColor.gray
    
    /// 设置滑条图片来显示
    var lineImage: UIImage?
    
    /// 设置滑条的粗细程度
    var lineWidth: CGFloat = 8.0
    
    /// 滑条y偏移量，默认是0
    var sliderOffset: CGFloat = 0
    
    /// 标题y偏移,默认是向下偏移20 正数向下，负数向上
    var titleOffset: CGFloat = 20
    
    /// 设置point的下标题
    var titleArray: [String]?
    
    /// 标题的字体
    var titleFont: UIFont?
    
    /// 所有标题的颜色
    var titleColor: UIColor?
    
    /// 每个标题的颜色
    var titleColorArray: [UIColor]?
    
    /// 文字的属性
    lazy var titleAttributes: [String:AnyObject] = {
        
        var dict = [String:AnyObject]()
        // 文字颜色
        dict[NSForegroundColorAttributeName] =
            self.titleColor != nil
            ? self.titleColor
            : UIColor.lightGray
        // 文字大小
        dict[NSFontAttributeName] =
            self.titleFont != nil
            ? self.titleFont
            : UIFont(name: "HelveticaNeue", size: 14)
        return dict
        
    }()
    
    private var touchPoint: CGPoint = CGPoint.zero
    
    private var thumbPoint: CGPoint = CGPoint.zero
    
    private var thumbRect: CGRect = CGRect.zero
    
    private var pointRectArray: [NSValue] = [NSValue]()
    
    private var startPoint: CGFloat = 30
    
    private var endPoint: CGFloat = 30
    
    private var y: CGFloat = 0
    
    private var isTap: Bool = false
    
    private var isRun: Bool = false
    
    // MARK: - 系统方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        assert(maximumValue > minimumValue, "maximumValue must be greater than minimumValue")
        
        if maximumValue <= minimumValue {
            minimumValue = 0
            maximumValue = 1
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {

                        self.y          = rect.midY
                        self.y         += self.sliderOffset
                        self.startPoint = self.margin
                        self.endPoint   = rect.size.width - self.margin
                        let width       = rect.size.width - self.margin * 2
                        let context     = UIGraphicsGetCurrentContext()
                        
                        if self.lineImage != nil {
                            self.lineImage!.draw(in: CGRect(x: self.startPoint,
                                                            y: self.y - self.lineWidth / 2.0,
                                                            width: self.endPoint - self.startPoint,
                                                            height: self.lineWidth))
                        } else {
                            self.drawLine(context: context!,
                                          startX: self.startPoint,
                                          endX: self.endPoint,
                                          lineColor: self.lineColor)
                        }
                        
                        if self.type == .point {
                            let pointWidth = self.pointWidth != nil
                                           ? self.pointWidth
                                           : self.lineWidth
 
                            for index in 0..<self.numberOfPoint {
                                let x = self.startPoint + width / CGFloat(self.numberOfPoint - 1) * CGFloat(index) - pointWidth! / 2.0
                                let pointOvalRect = CGRect(x: x,
                                                           y: self.y - pointWidth! / 2.0,
                                                           width: pointWidth!,
                                                           height: pointWidth!)
                                context?.addEllipse(in: pointOvalRect)
                                self.pointColor.set()
                                context?.fillPath()
                                self.pointRectArray.append(NSValue.init(cgRect: pointOvalRect))
                                
                                var title = ""
                                if (self.titleArray?.count ?? 0) > index {
                                    title = (self.titleArray?[index])!
                                }
                                
                                var titlePoint = CGPoint(x: pointOvalRect.midX,
                                                         y: pointOvalRect.midY)
                                let titleSize = (title as NSString).size(attributes: self.titleAttributes)
                                titlePoint.y += self.titleOffset
                                titlePoint.x -= titleSize.width / 2.0
                                let titleRect = CGRect(origin: titlePoint, size: titleSize)
                                (title as NSString).draw(in: titleRect, withAttributes: self.titleAttributes)
                            }
                            
                            if !self.isRun {
                                
                                if self.index >= self.pointRectArray.count {
                                    self.index = self.pointRectArray.count - 1
                                    if self.index < 0 {
                                        self.index = 0
                                    }
                                }
                                
                                let crect = self.pointRectArray[self.index].cgRectValue
                                self.thumbPoint = CGPoint(x: (crect.midX ) - self.thumbSize.width / 2.0,
                                                          y: (crect.midY ) - self.thumbSize.height / 2.0)
                                
                                self.isRun = true
                            }
                            
                        } else if self.type == .normal {
                            
                            if !self.isRun {
                                self.thumbPoint = CGPoint(x: self.changeX() - self.thumbSize.width / 2.0,
                                                          y: self.y - self.thumbSize.height / 2.0)
                                self.isRun = true
                            }
                            
                            if self.lineImage == nil {
                               let startx = self.startPoint
                               let endx = self.thumbPoint.x + self.thumbSize.width / 2
                                self.drawLine(context: context!,
                                              startX: startx,
                                              endX: endx,
                                              lineColor: self.minimumValueTrackColor)
                                
                                let startx1 = self.thumbPoint.x + self.thumbSize.width / 2
                                let endx1 = self.endPoint
                                self.drawLine(context: context!,
                                              startX: startx1,
                                              endX: endx1,
                                              lineColor: self.maximumValueTrackColor)
                            }
                            
                            
                        }
                        
                        self.thumbRect = CGRect(x: self.thumbPoint.x,
                                                 y: self.thumbPoint.y,
                                                 width: self.thumbSize.width,
                                                 height: self.thumbSize.height)
                        if self.thumbImage != nil {
                            self.thumbImage?.draw(in: self.thumbRect)
                        } else {
                            context?.addEllipse(in: self.thumbRect)
                            self.thumbColor.set()
                            context?.setLineWidth(0.3)
                            context?.setStrokeColor(self.thumbBordColor.cgColor)
                            context?.setFillColor(self.thumbColor.cgColor)
                            context?.setShadow(offset: CGSize(width: 0, height: 1), blur: 0.05)
                            context?.drawPath(using: .fillStroke)
                        }
                        
                        
                        
                        
        },
                       completion: nil)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        touchPoint = touch.location(in: self)
        var tempThumbRect = thumbRect
        tempThumbRect.size.width = tempThumbRect.size.width * thumbTouchRate
        tempThumbRect.size.height = tempThumbRect.size.height * thumbTouchRate
        tempThumbRect.origin.x -= (tempThumbRect.size.width - thumbRect.size.width) / 2.0
        tempThumbRect.origin.y -= (tempThumbRect.size.height - thumbRect.size.height) / 2.0
        
        if type == .point {
            isTap = true
            
            for objc in pointRectArray {
                let oldRect = objc.cgRectValue
                var newRect = oldRect
                newRect.size.width = newRect.size.width * pointTouchRate
                newRect.size.height = newRect.size.height * pointTouchRate
                newRect.origin.x -= (newRect.size.width - oldRect.size.width) / 2.0
                newRect.origin.y -= (newRect.size.height - oldRect.size.height) / 2.0
                if newRect.contains(touchPoint) {
                    thumbPoint = CGPoint(x: newRect.midX - thumbSize.width / 2.0,
                                         y: newRect.midY - thumbSize.height / 2.0)
                    setNeedsDisplay()
                    return true
                }
            }
        } else if type == .normal {
            return tempThumbRect.contains(touchPoint)
        }
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        touchPoint = touch.location(in: self)
        let x = touchPoint.x
        
        thumbPoint.x = x - thumbSize.width / 2.0
        
        if x < startPoint  {
            thumbPoint.x = startPoint - thumbSize.width / 2.0
        }
        if x > endPoint {
            thumbPoint.x = endPoint - thumbSize.width / 2.0
        }
        
        valueChangeForX(x: x)
        setNeedsDisplay()
        
        if continuous {
           sendActions(for: .valueChanged)
        }
   
        isTap = false
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        touchPoint = (touch?.location(in: self))!
        var tempIndex = 0
        if isTap {
            for objc in pointRectArray {
                var rect = objc.cgRectValue
                let orgin = rect
                rect.origin.x -= rect.size.width / 2.0
                rect.origin.y -= rect.size.height / 2.0
                rect.size.width = rect.size.width * pointTouchRate
                rect.size.height = rect.size.height * pointTouchRate
                tempIndex += 1
                if rect.contains(touchPoint) {
                    thumbPoint = CGPoint(x: orgin.midX - thumbSize.width / 2.0,
                                         y: orgin.midY - thumbSize.height / 2.0)
                    index = tempIndex - 1
                    valueRefresh()
                    break
                }
            }
        } else {
            if type == .point {
                let x = thumbPoint.x + thumbSize.width / 2.0
                var tempValue: CGFloat = 0.0
                for objc in pointRectArray.enumerated() {
                    let rect = objc.element.cgRectValue
                    var x1 = rect.origin.x
                    x1 += rect.size.width / 2.0
                    let absValue = fabs(x - x1)
                    if objc.offset == 0 {
                        tempValue = absValue
                    } else {
                        if absValue < tempValue {
                            tempValue = absValue
                            tempIndex = objc.offset
                        }
                    }
                }
                let cRect = pointRectArray[tempIndex].cgRectValue
                thumbPoint = CGPoint(x: cRect.midX - thumbSize.width / 2.0,
                                     y: cRect.midY - thumbSize.height / 2.0)
                index = tempIndex
            }
            valueRefresh()
        }
    }
    
    // MARK: - 自定义方法
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        startPoint = margin
    }
    
    func drawLine(context: CGContext, startX: CGFloat, endX: CGFloat, lineColor: UIColor) {
        
        context.move(to: CGPoint(x: startX, y: y))
        context.addLine(to: CGPoint(x: endX, y: y))
        context.setLineWidth(lineWidth)
        /// 起点和重点圆角
        context.setLineCap(CGLineCap.round)
        /// 转角圆角
        context.setLineJoin(CGLineJoin.round)
        context.setStrokeColor(lineColor.cgColor)
        context.strokePath()
        
    }
    
    func changeX() -> CGFloat {
        if self.value == self.minimumValue {
            return startPoint
        } else if self.value == self.maximumValue {
            return endPoint
        }
        return CGFloat(fabsf(Float(self.value))) / (self.maximumValue - self.minimumValue) * (endPoint - startPoint) + startPoint
    }
    
    func valueChangeForX(x: CGFloat) {
        let changeRale = (x - startPoint) / (endPoint - startPoint)
        let temp = changeRale * (maximumValue - minimumValue)
        if minimumValue >= 0 {
            value = temp
        } else {
            if (temp < CGFloat(fabs(minimumValue))) {
                value = -temp
            }
            value = temp - fabs(minimumValue)
        }
    }
    
    func valueRefresh() {
        setNeedsDisplay()
        sendActions(for: .valueChanged)
    }
  
}

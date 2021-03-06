//
//  NVPColorPicker.swift
//  TextEdit
//
//  Created by Vladimir Nevinniy on 08.02.17.
//  Copyright © 2017 Vladimir Nevinniy. All rights reserved.
//

import UIKit

internal protocol NVPColorPickerDelegat : NSObjectProtocol {
    func colorColorPickerTouched(sender:NVPColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState)
}

class NVPColorPicker: UIView {

        
        weak internal var delegate: NVPColorPickerDelegat?
        let saturationExponentTop:Float = 2.0
        let saturationExponentBottom:Float = 1.3
        
        @IBInspectable var elementSize: CGFloat = 1.0 {
            didSet {
                setNeedsDisplay()
            }
        }
        
        private func initialize() {
            self.clipsToBounds = true
            let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(NVPColorPicker.touchedColor(_:)))
            touchGesture.minimumPressDuration = 0
            touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
            self.addGestureRecognizer(touchGesture)
        }
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            initialize()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initialize()
        }
        
        override func draw(_ rect: CGRect) {
            for y in stride(from: 0, to: rect.height, by: elementSize) {
                
                var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
                saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
                let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
                
                for x in  stride(from: 0, to: rect.width, by: elementSize)  {
                    let hue = x / rect.width
                    let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                    
                    let rectanglePath = UIBezierPath(rect: CGRect(x: x, y: y, width: elementSize, height: elementSize))
                    color.setFill()
                    rectanglePath.fill()
                }
            }
        }
        
        func getColorAtPoint(point:CGPoint) -> UIColor {
            let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                       y:elementSize * CGFloat(Int(point.y / elementSize)))
            var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
                : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
            saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
            let hue = roundedPoint.x / self.bounds.width
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
        
        func getPointForColor(color:UIColor) -> CGPoint {
            var hue:CGFloat=0;
            var saturation:CGFloat=0;
            var brightness:CGFloat=0;
            color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
            
            var yPos:CGFloat = 0
            let halfHeight = (self.bounds.height / 2)
            
            if (brightness >= 0.99) {
                let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
                yPos = CGFloat(percentageY) * halfHeight
            } else {
                //use brightness to get Y
                yPos = halfHeight + halfHeight * (1.0 - brightness)
            }
            
            let xPos = hue * self.bounds.width
            
            return CGPoint(x: xPos, y: yPos)
        }
        
        func touchedColor(_ gestureRecognizer: UILongPressGestureRecognizer){
            let point = gestureRecognizer.location(in: self)
            let color = getColorAtPoint(point: point)
            
            self.delegate?.colorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
        }
    

}

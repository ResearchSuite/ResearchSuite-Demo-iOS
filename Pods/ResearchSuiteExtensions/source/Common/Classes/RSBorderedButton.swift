//
//  RSBorderedButton.swift
//  Pods
//
//  Created by James Kizer on 7/11/17.
//
//

import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
extension UIButton {
    func setBackgroundColor(backgroundColor: UIColor?, for state: UIControlState) {
        if let color = backgroundColor {
            self.setBackgroundImage(UIImage.from(color: color), for: state)
        }
        else {
            self.setBackgroundImage(nil, for: state)
        }
    }
    
}

open class RSBorderedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initButton()
    }
    
    private func initButton() {
        self.titleLabel?.font = self.defaultFont
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    
    //what we would like is that normally, a bordered button is text and border set to primary color, and background is clear
    //When highlighted or selected, the text is set to secondary color (defaults to white), border and background set to primary color
    //when disabled, text and border is set to grey (black w/ alpha)
//    private func setTitleColor(_ color: UIColor?) {
//        self.setTitleColor(color, for: UIControlState.normal)
//        self.setTitleColor(UIColor.white, for: UIControlState.highlighted)
//        self.setTitleColor(UIColor.white, for: UIControlState.selected)
//        self.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: UIControlState.disabled)
//    }
//
    
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    
    public func setColors(primaryColor: UIColor, secondaryColor: UIColor? = nil) {
        
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        
        self.internalSetColors(primaryColor: primaryColor, secondaryColor: secondaryColor)
    }
    
    private func internalSetColors(primaryColor: UIColor, secondaryColor: UIColor? = nil) {
        
        let secondaryColor = secondaryColor ?? UIColor.white
        
        //normal, text and border set to primary color, and background is clear
        self.setTitleColor(primaryColor, for: UIControlState.normal)
        self.setBackgroundColor(backgroundColor: nil, for: UIControlState.normal)
        
        //disabled, text and border is set to grey (black w/ alpha)
        self.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: UIControlState.disabled)
        self.setBackgroundColor(backgroundColor: nil, for: UIControlState.disabled)
        
        //highlighted
        self.setTitleColor(secondaryColor, for: UIControlState.highlighted)
        self.setBackgroundColor(backgroundColor: primaryColor, for: UIControlState.highlighted)
        
        //selected
        self.setTitleColor(secondaryColor, for: UIControlState.highlighted)
        self.setBackgroundColor(backgroundColor: primaryColor, for: UIControlState.highlighted)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        //normal, highlighted, selected: primary color
        //disabled: grey
        if self.state == .disabled {
            self.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        }
        else {
            self.layer.borderColor = (self.primaryColor ?? self.tintColor).cgColor
        }
    }
    
    
    //by default, the tint color should be the primary color and secondary color is white
    //first, check to see if color has been configured
    override open func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        if let _ = self.primaryColor {
            return
        }
        else {
            self.internalSetColors(primaryColor: self.tintColor, secondaryColor: nil)
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + 20.0, height: superSize.height)
    }
    
    open var defaultFont: UIFont {
        // regular, 14
        return RSBorderedButton.defaultFont
    }
    
    open class var defaultFont: UIFont {
        // regular, 14
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.headline)
        let fontSize: Double = (descriptor.object(forKey: UIFontDescriptor.AttributeName.size) as! NSNumber).doubleValue
        return UIFont.systemFont(ofSize: CGFloat(fontSize))
    }

}

//
//  FontViewController.swift
//  TextEdit
//
//  Created by Vladimir Nevinniy on 2/9/17.
//  Copyright © 2017 Vladimir Nevinniy. All rights reserved.
//

import UIKit

class FontViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    

    var fontNames = [String]()
    var currentNameFont = "Helvetica"
    var currentSizeFont = 17
    
    var delegate: TextEditViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontFamilyNames = UIFont.familyNames
        
        for familyName in fontFamilyNames {
            let names = UIFont.fontNames(forFamilyName: familyName)
            
            if names.count > 0 {
                
                for name in names {
                    fontNames.append(name)
                }
                
            } else {
                fontNames.append(familyName)
            }
        }

        
        print(currentNameFont)
        if let indexFontSize = fontNames.index(of: currentNameFont) {
            picker.selectRow(indexFontSize, inComponent: 0, animated: false)
        }
    
        picker.selectRow(currentSizeFont-1, inComponent: 1, animated: false)
        
        
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component  ==  1 {
            return 30
        }
        return fontNames.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        if component  ==  1 {
//            return "\(row + 1)"
//        }
//        
//        return fontNames[row]
//    }
    
    
    
    //attributedTitleForRow
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
      
        var textAtt = ""
        
        if component  ==  1 {
            textAtt  = "\(row + 1)"
        } else {
            textAtt = fontNames[row]
        }
        
        
        let nameFont = fontNames[row]
        
        
        let font = UIFont(name: nameFont, size: 12)
        
        let myAttribute = [NSFontAttributeName: font!]
        
        
        let myAttrString = NSAttributedString(string: textAtt, attributes: myAttribute)
        
        
       
        return myAttrString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component  ==  0 {
            currentNameFont = fontNames[row]
        }
        else {
            currentSizeFont = row+1
        }
        
        if let font = UIFont(name: currentNameFont, size: CGFloat(currentSizeFont)) {
            delegate?.setFont(font)
        }
    
    }

}

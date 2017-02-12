//
//  ViewController.swift
//  TextEdit
//
//  Created by Vladimir Nevinniy on 2/8/17.
//  Copyright © 2017 Vladimir Nevinniy. All rights reserved.
//

import UIKit

class TextEditViewController: MainViewController {

    
//    enum PositionText: Int {
//        case Left = 0
//        case Centr
//        case Riht
//    }
    
    //attributedText
    struct MyAttributed {
        var color: UIColor
        var font: UIFont
        var position: NSTextAlignment
    }
    
    
    var fontNames = [String]()
    private var currentFamilyNameCount = 0
    var attributed: MyAttributed!
    
    var textAttrString = NSAttributedString()
    
    

    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributed = MyAttributed(color: textField.textColor!, font: textField.font!, position: .left )
        
    }

 
    @IBAction func changedPosition(_ sender: UISegmentedControl) {
        attributed.position = NSTextAlignment(rawValue: sender.selectedSegmentIndex)!
        
        let text = textField.text
        
        let myAttribute = getAttribute()
        textAttrString = NSAttributedString(string: text!, attributes: myAttribute)
        
        textField.attributedText = textAttrString
        
        
      //  textField.textAlignment = attributed.position
    }

    @IBAction func readAllFonts(_ sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "fontPickerPopover") as! FontViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 400, height: 300)
        
        let font = textField.font!
        
        popoverVC.currentNameFont = font.fontName
        popoverVC.currentSizeFont = Int(font.pointSize)
        popoverVC.delegate = self
        
        print("currentNameFont = \(popoverVC.currentNameFont) currentSizeFont = \(popoverVC.currentSizeFont)")
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = textField
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: textField.frame.width, height: textField.frame.height)
            popoverController.permittedArrowDirections = .any
            
            popoverController.delegate = self
            
        }
        present(popoverVC, animated: true, completion: nil)
 
        
        
    }

    @IBAction func onClickColorButton(_ sender: Any) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 300, height: 200)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = textField
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: textField.frame.width, height: textField.frame.height)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    
    
//    @IBAction func onClickOk(_ sender: UIButton) {
//        performSegue(withIdentifier: "exitAndSaveFromTextEdit", sender: self)
//    }
    
    

 }


extension TextEditViewController: UIPopoverPresentationControllerDelegate {
    
    
    func getAttribute() -> [String : Any] {
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = attributed.position
        
        return [ NSFontAttributeName: attributed.font,  NSForegroundColorAttributeName: attributed.color, NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    func setTextColor (_ color: UIColor) {
        
        let text = textField.text
        
        attributed.color = color
        
        let myAttribute = getAttribute()
        textAttrString = NSAttributedString(string: text!, attributes: myAttribute)
 
        textField.attributedText = textAttrString
    }
    
    
    
    func setFont(_ font: UIFont) {
        let text = textField.text
        
        attributed.font = font
        
        let myAttribute = getAttribute()
        
        textAttrString = NSAttributedString(string: text!, attributes: myAttribute)
        
        textField.attributedText = textAttrString
            
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
}


extension TextEditViewController: UITextFieldDelegate{
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        self.topLayout.constant = 0
//    }
}


extension TextEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component  ==  1 {
            return 30
        }
        return fontNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component  ==  1 {
            return "\(row + 1)"
        }
        
        return fontNames[row]
    }
    
   
    
    
    
}


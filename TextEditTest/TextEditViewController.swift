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
    
    
    @IBOutlet weak var alligmentSegmentControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!

    
    @IBOutlet weak var textFieldSelected: UITextField!
    
    
    @IBAction func getSelectedText(_ sender: UIButton) {
        
        print(textView.selectedTextRange ?? "nil TextRange")
        
        
      //  if textView.selectedTextRange?.isEmpty == false {
            
            print(textView.selectedRange.location)
            print(textView.selectedRange.length)
            
            
     //   }
      //  print(textView.selectedRange.location)
        
        
        if let selectedTextRange = textView.selectedTextRange {
            let start = selectedTextRange.start
            let end = selectedTextRange.end
            let isEmpty = selectedTextRange.isEmpty
            
            
            print("start = \(start)  end = \(end) isEmpty = \(isEmpty)")
            
            print("start document = \(textView.beginningOfDocument)  end document = \(textView.endOfDocument)")
            
            
            
        }
        
                
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // attributed = MyAttributed(color: textView.textColor!, font: textView.font!, position: .left )
        attributed = MyAttributed(color: UIColor.black , font: UIFont.italicSystemFont(ofSize: 17), position: .left )
        
    }

 
    @IBAction func changedPosition(_ sender: UISegmentedControl) {
        
        
        attributed.position = NSTextAlignment(rawValue: sender.selectedSegmentIndex)!
        
        let text = textView.text
        
        let myAttribute = getAttribute()
        
        
        
        
        if textView.selectedTextRange?.isEmpty == false {
            let textMutAttrString = NSMutableAttributedString(attributedString: textView.attributedText)
            
            textMutAttrString.setAttributes(myAttribute, range: textView.selectedRange)
            
            textAttrString = textMutAttrString
        } else {
            textAttrString = NSAttributedString(string: text!, attributes: myAttribute)
        }
        
        let position = textView.selectedTextRange
        textView.attributedText = textAttrString
        textView.selectedTextRange = position
        
        
      //  textField.textAlignment = attributed.position
    }

    @IBAction func readAllFonts(_ sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "fontPickerPopover") as! FontViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 400, height: 300)
        
        let font = textView.font!
        
        popoverVC.currentNameFont = font.fontName
        popoverVC.currentSizeFont = Int(font.pointSize)
        popoverVC.delegate = self
        
        print("currentNameFont = \(popoverVC.currentNameFont) currentSizeFont = \(popoverVC.currentSizeFont)")
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = textView
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: textView.frame.width, height: textView.frame.height)
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
            popoverController.sourceView = textView
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: textView.frame.width, height: textView.frame.height)
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


extension TextEditViewController: UITextViewDelegate {
    //textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        print("change !!!")
    }
    
    //textViewDidChangeSelection
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("selection !!!")
        
        
        var range = NSRange()
        
        if textView.selectedTextRange!.isEmpty {
            
            range.location = textView.selectedRange.location
            range.length = textView.offset(from: textView.selectedTextRange!.start , to: textView.endOfDocument)
            
        } else {
            
            range = textView.selectedRange
            
        }
        
        if let paragraph = textView.attributedText.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle {
          
            print(paragraph.alignment.rawValue)
            if paragraph.alignment.rawValue < 4 {
                alligmentSegmentControl.selectedSegmentIndex = paragraph.alignment.rawValue                
            }
            
       }
    }
    
    
    
}

extension TextEditViewController: UIPopoverPresentationControllerDelegate {
    
    
    func getAttribute() -> [String : Any] {
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = attributed.position
        
        return [ NSFontAttributeName: attributed.font,  NSForegroundColorAttributeName: attributed.color, NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    func setTextColor (_ color: UIColor) {
        
        let text = textView.text
        
        attributed.color = color
        
        let myAttribute = getAttribute()
        textAttrString = NSAttributedString(string: text!, attributes: myAttribute)
 
        textView.attributedText = textAttrString
    }
    
    
    
    func setFont(_ font: UIFont) {
        let text = textView.text
        
        attributed.font = font
        
        let myAttribute = getAttribute()
        
        textAttrString = NSAttributedString(string: text!, attributes: myAttribute)
        
        textView.attributedText = textAttrString
            
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


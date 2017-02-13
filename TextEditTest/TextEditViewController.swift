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
    
    
    
    
    var currentSelectedRange: NSRange?
    
    
    @IBOutlet weak var alligmentSegmentControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!

    
    @IBOutlet weak var textFieldSelected: UITextField!
    
    
//    
//    func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {
//        let attributedString = NSMutableAttributedString(string: targetString)
//        do {
//            let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
//            let range = NSRange(location: 0, length: targetString.utf16.count)
//            for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
//                attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), range: match.range)
//            }
//            return attributedString
//        } catch _ {
//            NSLog("Error creating regular expresion")
//            return nil
//        }
//    }
//    
    @IBAction func getSelectedText(_ sender: UIButton) {
        
      // let attributedString = textView.attributedText
        
    
        textView.text.enumerateLines { (str, hz) in
            print(str)
        }
        
        
//        if let selectedTextRange = textView.selectedTextRange {
//            let length  = textView.offset(from: selectedTextRange.start, to: textView.endOfDocument)
//           
//            let range =  textView.textRange(from: selectedTextRange.start, to: textView.endOfDocument)
//            
//            //let range = NSRange(location: textView.selectedRange.location, length: length)
//            
//           
//            
//            textView.text.enumerateSubstrings(in: range, options: String.EnumerationOptions.byLines, { (str, range1, range2, res) in
//                
//                print(str)
//            })
//            
//            textView.text.enumerateSubstrings(in: Range<String.Index>, options: <#T##String.EnumerationOptions#>, <#T##body: (String?, Range<String.Index>, Range<String.Index>, inout Bool) -> ()##(String?, Range<String.Index>, Range<String.Index>, inout Bool) -> ()#>)
//            
//        }
        
        
        if let selectedTextRange = textView.selectedTextRange {
            do {
                
                
                
                let regex = try NSRegularExpression(pattern: "\n", options: .caseInsensitive)
                var length  = textView.offset(from: selectedTextRange.start, to: textView.endOfDocument)
                
                var range = NSRange(location: textView.selectedRange.location, length: length)
                
                var end = textView.offset(from: textView.beginningOfDocument, to: textView.endOfDocument)
                var start = 0
                
                for match in regex.matches(in: textView.text, options: .withTransparentBounds, range: range) {
                     //attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), range: match.range)
                    
//                    if let toPosition = textView.position(from: selectedTextRange.start, offset: match.range.location) {
//                        textView.selectedTextRange = textView.textRange(from: selectedTextRange.start, to: toPosition)
//                    }
                    
                    
                   // textView.selectedRange = NSRange(location: textView.selectedRange.location, length:  match.range.location - textView.selectedRange.location)
                    end = match.range.location
                    
                    break
                    
                }
                
                length  = textView.offset(from: textView.beginningOfDocument, to: selectedTextRange.start)
                range = NSRange(location: 0, length: length)
                
                for match in regex.matches(in: textView.text, options: .withTransparentBounds, range: range) {
                    //attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), range: match.range)
                    
                    //                    if let toPosition = textView.position(from: selectedTextRange.start, offset: match.range.location) {
                    //                        textView.selectedTextRange = textView.textRange(from: selectedTextRange.start, to: toPosition)
                    //                    }
                    
                    
                    
                    start = match.range.location + 1
                    
                    
                    
                }
                
                print("start = \(start) end = \(end)")
                
                
                textView.selectedRange = NSRange(location:  start, length: end-start)
                
                
            } catch _ {
                
            }
        }
//
       // print(textView.selectedTextRange ?? "nil TextRange")
        
        
      //  if textView.selectedTextRange?.isEmpty == false {
            
       //    print(textView.selectedRange.location)
       //     print(textView.selectedRange.length)
            
            
     //   }
      //  print(textView.selectedRange.location)
        
        
//        if let selectedTextRange = textView.selectedTextRange {
//            let start = selectedTextRange.start
//            let end = selectedTextRange.end
//            let isEmpty = selectedTextRange.isEmpty
//            
//            
//            print("start = \(start)  end = \(end) isEmpty = \(isEmpty)")
//            
//            print("start document = \(textView.beginningOfDocument)  end document = \(textView.endOfDocument)")
        
            
           // textRangeFromPosition
            
     //   }
        
                
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // attributed = MyAttributed(color: textView.textColor!, font: textView.font!, position: .left )
        attributed = MyAttributed(color: UIColor.black , font: UIFont.italicSystemFont(ofSize: 17), position: .left )
        
    }

 
    @IBAction func changedPosition(_ sender: UISegmentedControl) {
        
        
        
        attributed.position = NSTextAlignment(rawValue: sender.selectedSegmentIndex)!
        let myAttribute = getAttribute()
        
        applyAttribute(attribute: myAttribute)
        
    }

    @IBAction func readAllFonts(_ sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "fontPickerPopover") as! FontViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 400, height: 300)
        
        let font = attributed.font
        
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
        
        let rangeSelect = textView.selectedRange
        
        
        
        if rangeSelect.length > 0 {
            currentSelectedRange = rangeSelect
        } else {
            if let selectedTextRange = textView.selectedTextRange {
                do {
                    let regex = try NSRegularExpression(pattern: "\n", options: .caseInsensitive)
                    var length  = textView.offset(from: selectedTextRange.start, to: textView.endOfDocument)
                    
                    var range = NSRange(location: textView.selectedRange.location, length: length)
                    
                    
                    var end = textView.offset(from: textView.beginningOfDocument, to: textView.endOfDocument)
                    var start = 0
                    
                    if let match = regex.firstMatch(in: textView.text, options: .withTransparentBounds, range: range) {
                        end = match.range.location
                    }
                    
                    
                    length  = textView.offset(from: textView.beginningOfDocument, to: selectedTextRange.start)
                    range = NSRange(location: 0, length: length)
                    
                    for match in regex.matches(in: textView.text, options: .withTransparentBounds, range: range) {
                        start = match.range.location + 1
                    }
                    
                    currentSelectedRange = NSRange(location:  start, length: end-start)
                    
                } catch _ {
                    
                }
            }
        }
        

        if let range = currentSelectedRange {
            textView.attributedText.enumerateAttributes(in: range, options: .reverse, using: { (attributes, range, nil) in
                
                if let font = attributes[NSFontAttributeName] as? UIFont {
                    attributed.font = font
                }
                
                if let color = attributes[NSForegroundColorAttributeName] as? UIColor {
                    attributed.color = color
                }
                
                if let paragraph = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
                    attributed.position = paragraph.alignment
                    
                    if attributed.position.rawValue < 4 {
                        alligmentSegmentControl.selectedSegmentIndex = attributed.position.rawValue
                    } else {
                        alligmentSegmentControl.selectedSegmentIndex = 0
                    }
                }
                
            })
        }
    }
    
}


extension TextEditViewController: UIPopoverPresentationControllerDelegate {
    
    
    func getAttribute() -> [String : Any] {
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = attributed.position
        
        return [ NSFontAttributeName: attributed.font,  NSForegroundColorAttributeName: attributed.color, NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    
    func applyAttribute(attribute: [String : Any]) {
        if let currentSelectedRange = currentSelectedRange {
            let textMutAttrString = NSMutableAttributedString(attributedString: textView.attributedText)
            
            textMutAttrString.setAttributes(attribute, range: currentSelectedRange)
            
            textAttrString = textMutAttrString
            let position = textView.selectedRange
            
            textView.attributedText = textAttrString
            textView.selectedRange = position
        }
        
    }
    
    func setTextColor (_ color: UIColor) {
        attributed.color = color
        let myAttribute = getAttribute()
        
        applyAttribute(attribute: myAttribute)
        
    }
    
    
    
    func setFont(_ font: UIFont) {
        
        attributed.font = font
        
        let myAttribute = getAttribute()
        
        applyAttribute(attribute: myAttribute)
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


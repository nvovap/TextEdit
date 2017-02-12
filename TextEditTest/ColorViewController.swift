//
//  ViewController.swift
//  TextEdit
//
//  Created by Vladimir Nevinniy on 2/8/17.
//  Copyright © 2017 Vladimir Nevinniy. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, NVPColorPickerDelegat {
    
    var tag: Int = 0
    var color: UIColor = UIColor.gray
    var delegate: TextEditViewController? = nil
    

    @IBOutlet weak var colorView: NVPColorPicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.delegate = self
       
        
    }
    
    
    @IBAction func valueChanget(_ sender: UIPageControl) {
     
        let x = CGFloat(sender.currentPage) * 300
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        
        let page = lround(Double(fractionalPage))
        
        pageControl.currentPage = page
        
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func colorColorPickerTouched(sender: NVPColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        self.view.backgroundColor = color
        delegate?.setTextColor(color)
    }
}


extension ColorViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Global variables
    
    
    // This function converts from HTML colors (hex strings of the form '#ffffff') to UIColors
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // UICollectionViewDataSource Protocol:
    // Returns the number of rows in collection view
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    // UICollectionViewDataSource Protocol:
    // Returns the number of columns in collection view
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 16
    }
    // UICollectionViewDataSource Protocol:
    // Inilitializes the collection view cells
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.tag = tag
        tag = tag + 1
        
        return cell
    }
    
    // Recognizes and handles when a collection view cell has been selected
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var colorPalette: Array<String>
        
        // Get colorPalette array from plist file
        let path = Bundle.main.path(forResource: "colorPalette", ofType: "plist")
        let pListArray = NSArray(contentsOfFile: path!)
        
        if let colorPalettePlistFile = pListArray {
            colorPalette = colorPalettePlistFile as! [String]
            
            let cell: UICollectionViewCell  = collectionView.cellForItem(at: indexPath)! as UICollectionViewCell
            let hexString = colorPalette[cell.tag]
            color = hexStringToUIColor(hexString)
            self.view.backgroundColor = color
           
            delegate?.setTextColor(color)
        }
    }
}


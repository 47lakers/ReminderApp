//
//  TextLabel.swift
//  My app project
//
//  Created by Ira Xavier Porchia on 5/22/21.
//

import Foundation
import UIKit

func PlaceHolder(placeholderLabel: UILabel!, textView: UITextView!){
    placeholderLabel.text = "Type Here"
    placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
    placeholderLabel.sizeToFit()
    textView.addSubview(placeholderLabel)
    placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
    placeholderLabel.textColor = UIColor.lightGray
    placeholderLabel.isHidden = !textView.text.isEmpty
}

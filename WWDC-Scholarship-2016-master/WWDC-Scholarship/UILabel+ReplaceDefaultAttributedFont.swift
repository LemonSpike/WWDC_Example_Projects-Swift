//
//  UILabel+ReplaceDefaultAttributedFont.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 30/03/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit

private extension UIFont {
  convenience init(baseFont: UIFont, addingTraits traitsToAdd: UIFontDescriptorSymbolicTraits) {
    let baseFontDescriptor = baseFont.fontDescriptor
    let baseFontTraits: UIFontDescriptorSymbolicTraits = baseFontDescriptor.symbolicTraits
    let traits = NSNumber(value: baseFontTraits.union(traitsToAdd).rawValue as UInt32);
    let newFontDescriptor = baseFontDescriptor.addingAttributes([UIFontDescriptorTraitsAttribute: [UIFontSymbolicTrait: traits]])
    self.init(descriptor: newFontDescriptor, size: baseFont.pointSize)
  }
}

extension UILabel {
  func replaceDefaultAttributedStringFont(_ newDefaultFont: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)) {
    guard let text = attributedText?.mutableCopy() as? NSMutableAttributedString else {
      return
    }
    text.enumerateAttributes(in: NSRange(location: 0, length: text.length), options: [], using: { (attributes, range, _) in
      if let font = attributes[NSFontAttributeName] as? UIFont {
        var newAttributes = attributes
        if font.familyName.contains("Helvetica Neue") {
          newAttributes[NSFontAttributeName] = UIFont(baseFont: newDefaultFont, addingTraits: font.fontDescriptor.symbolicTraits)
        } else {
          let fontSize: CGFloat
          if font.familyName.contains("Menlo") {
            fontSize = newDefaultFont.pointSize * 0.8
          } else {
            fontSize = newDefaultFont.pointSize
          }
          let newFont = (attributes[NSFontAttributeName]! as! UIFont).withSize(fontSize)
          newAttributes[NSFontAttributeName] = newFont
        }
        text.setAttributes(newAttributes, range: range)
      }
    })
    attributedText = text
  }
}

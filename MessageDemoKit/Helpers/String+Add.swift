//
//  String+Add.swift
//  ConfigureApp
//
//  Created by MAC on 30/09/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import UIKit

public extension String{
    
   
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var length: Int {
        return self.count
    }
    
    var nsStr: NSString {
        return self as NSString
    }
    
    var pathExtension: String {
        return nsStr.pathExtension
    }
    
    var lastPathComponent: String {
        return nsStr.lastPathComponent
    }
    
    var isBackspace: Bool {
      let char = self.cString(using: String.Encoding.utf8)!
      return strcmp(char, "\\b") == -92
    }
    
    //MARK:- Trim methods
    func trimWhiteSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
 
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func isBlankString()-> Bool {
        return self.trim().count == 0
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }

    func removeStringTill(occurence:String) -> String  {
        if let range = self.range(of: occurence) {
            let secondPart = self[range.upperBound...]
            NSLog("\(secondPart)")
            return String(secondPart)
        }
        return self
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func substring(_ from: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: from)])
    }
    
    func startWith(_ find: String) -> Bool {
        return self.hasPrefix(find)
    }
    
    func equals(_ find: String) -> Bool {
        return self == find
    }
    
    func contains(_ find: String) -> Bool {
        if let _ = self.range(of: find) {
            return true
        }
        return false
    }
    
    //MARK:- Date calc methods
    func toDate(dateFormat : String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.autoupdatingCurrent
        guard let date = formatter.date(from: self) else {
            print("can't converted to date")
            return Date()
        }
        return date
    }
    
    //MARK:- Utility methods
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    
    func htmlStringToPlainText() ->  String{
        return html2AttributedString?.string ?? ""
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func removeHtmlFromString() -> String {
        
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange?
    {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9]{8,14}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    
    
    func makeURL() -> URL? {
        
        let trimmed = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: trimmed ?? "") else {
            return nil
        }
        return url
    }
    
    func URLEncodedString() -> String {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString ?? ""
    }
    
    static func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    static func widthForText(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width:  CGFloat(MAXFLOAT), height:height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    //MARK:- Localize
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        let lang="en"//AppManager.getLanguageCodeForApp()
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj"),let bundle = Bundle(path: path){
            return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
        }
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
}


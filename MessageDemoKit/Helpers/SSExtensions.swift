//
//  Extensions.swift
//
//  Created by wolf.
//  Copyright ©2015 - 2022 Subhu aka wolf . All rights reserved.
//

import Foundation
import UIKit
import Foundation
import AVFoundation
import CommonCrypto
import MapKit

class BGView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
}

@IBDesignable
class TriangleView:UIView{
    @IBInspectable var triangleColor: UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    override func layoutSubviews() {
        let heightWidth = self.frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
        path.addLine(to: CGPoint(x:0, y:heightWidth))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = self.triangleColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
    }
}

class NavC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.configureWithTransparentBackground()
            app.shadowImage = UIImage()
            app.backgroundColor = .clear
            app.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                       .foregroundColor: UIColor.white]
            let btnApp = UIBarButtonItemAppearance()
            btnApp.configureWithDefault(for: .plain)
            btnApp.normal.backgroundImage =  UIImage(named: "back")
            
            app.backButtonAppearance = btnApp
            //            navigationBar.isTranslucent = true
            navigationBar.tintColor = .white
            
            navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                 .foregroundColor: UIColor.white]
            
            self.navigationBar.scrollEdgeAppearance = app
            self.navigationBar.standardAppearance = app
        } else {
            self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage()
        }
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100.0)
    }
    
}

class NavImage: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.additionalSafeAreaInsets.top = 10
        //        self.additionalSafeAreaInsets.bottom = -10
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        let image = UIImage(named: "HomeNav")
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.configureWithTransparentBackground()
            app.backgroundImage = image
            app.backgroundColor = .clear
            app.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                       .foregroundColor: UIColor.white]
            let btnApp = UIBarButtonItemAppearance()
            btnApp.configureWithDefault(for: .plain)
            btnApp.normal.backgroundImage =  UIImage(named: "back")
            
            
            app.backButtonAppearance = btnApp
//            app.backIndicatorImage = UIImage(named: "back")!
            navigationBar.isTranslucent = false
            navigationBar.tintColor = .white
            
            navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                 .foregroundColor: UIColor.white]
            
            self.navigationBar.scrollEdgeAppearance = app
            self.navigationBar.standardAppearance = app
        } else {
            self.navigationBar.setBackgroundImage(image!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
        }
        
        self.navigationBar.shadowImage = UIImage()
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}


extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension UIView {
    func addDashedBorder() {
        let color = UIColor.gray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
// dotted line
@IBDesignable class DottedVertical: UIView {
    
    @IBInspectable var dotColor: UIColor = UIColor.lightGray
    @IBInspectable var lowerHalfOnly: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 8 + 8 - 1
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)
        
        let path = UIBezierPath()
        
        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)
        
        path.move(to: top)
        path.addLine(to: bottom)
        
        path.lineWidth = width
        
        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        
        // for ROUNDED dots, simply change to....
        //let dashes: [CGFloat] = [0.0, itemLength * 2.0]
        //path.lineCapStyle = CGLineCap.round
        
        dotColor.setStroke()
        path.stroke()
    }
}



extension UIApplication {
    //    var statusBarView: UIView? {
    //        if responds(to: Selector("statusBar")) {
    //            return value(forKey: "statusBar") as? UIView
    //        }
    //        return nil
    //    }
}
struct Regex {
    static let userNameRegex   = "^[a-zA-Z ]{2,30}$"
    static let phoneRegex      = "^([0-9]{9,15})$"
    static let passwordRegex   = "^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$"
    static let emailRegex      = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    static let emailPhoneRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$|^([0-9]{10,13})$"
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}
extension UILabel {
    func setHTML(html: String) {
        
        do {
            let attributedString: NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!, options:  [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],documentAttributes: nil)
            self.attributedText = attributedString
        } catch {
            self.text = html
        }
    }
}

//MARK: ------ View Drop Shadow Cannot convert value of type 'NSAttributedString.DocumentAttributeKey' to expected dictionary key type 'NSAttributedString.DocumentReadingOptionKey'

extension UIView {
    
    
    func dropShadow() {
        self.layer.shadowColor =  #colorLiteral(red: 0, green: 0.3449999988, blue: 0.6819999814, alpha: 0.200000003).cgColor
        
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
    
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        // mask.masksToBounds = radius > 0
        self.layer.mask = mask
    }
}

//extension UITextView{
//     public func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        return (action != #selector(UIResponderStandardEditActions.paste(_:)))
//    }
//}
//
//extension UITextField{
//     public func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        return (action != #selector(UIResponderStandardEditActions.paste(_:)))
//    }
//}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    
    func trim() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    //    func MD5() -> String? {
    //        let length = Int(CC_MD5_DIGEST_LENGTH)
    //        var digest = [UInt8](repeating: 0, count: length)
    //
    //        if let d = self.data(using: String.Encoding.utf8) {
    //            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
    //                CC_MD5(body, CC_LONG(d.count), &digest)
    //            }
    //        }
    //
    //        return (0..<length).reduce("") {
    //            $0 + String(format: "%02x", digest[$1])
    //        }
    //    }
    
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var isValidUserName:Bool {
        return testThe(regex: Regex.userNameRegex)
    }
    
    var isValidMobileNumber: Bool {
        return testThe(regex: Regex.phoneRegex)
    }
    
    var isValidPassword:Bool {
        return testThe(regex: Regex.passwordRegex)
    }
    
    var isValidEmailId:Bool {
        return testThe(regex: Regex.emailRegex)
    }
    
    var isValidEmailAndNumber:Bool {
        return testThe(regex: Regex.emailPhoneRegex)
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func testThe(regex:String) -> Bool {
        if self.count > 0 {
            let predicate = NSPredicate(format: "SELF MATCHES %@",regex)
            return predicate.evaluate(with: self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
        }
        return false
    }
    
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension UIViewController {
    func showActionSheetWith(items:[String], title:String, message:String, completion:@escaping ((String) -> Void)) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for item in items {
            actionSheet.addAction(UIAlertAction(title: item, style: .default, handler: { (action) in
                completion(action.title!)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showDoubleButtonAlert(title:String, message:String, action1:String, action2:String, completion1:@escaping ()->(), completion2:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let act1 = UIAlertAction(title: action1, style: .default) { (action) in
            completion1()
        }
        let act2 = UIAlertAction(title: action2, style: .destructive) { (action) in
            completion2()
        }
        alert.addAction(act1)
        alert.addAction(act2)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSingleButtonAlert(title:String, message:String, completion:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            completion()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension UITableView {
    
    /// Check if cell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }
    
}

public extension UIWindow {
    
    /// Transition Options
    struct TransitionOptions {
        
        /// Curve of animation
        ///
        /// - linear: linear
        /// - easeIn: ease in
        /// - easeOut: ease out
        /// - easeInOut: ease in - ease out
        public enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut
            
            /// Return the media timing function associated with curve
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear:        key = CAMediaTimingFunctionName.linear.rawValue
                case .easeIn:        key = CAMediaTimingFunctionName.easeIn.rawValue
                case .easeOut:        key = CAMediaTimingFunctionName.easeOut.rawValue
                case .easeInOut:    key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
                }
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key!))
            }
        }
        
        /// Direction of the animation
        ///
        /// - fade: fade to new controller
        /// - toTop: slide from bottom to top
        /// - toBottom: slide from top to bottom
        /// - toLeft: pop to left
        /// - toRight: push to right
        public enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight
            
            /// Return the associated transition
            ///
            /// - Returns: transition
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade:
                    transition.type = CATransitionType.fade
                    transition.subtype = nil
                case .toLeft:
                    transition.subtype = CATransitionSubtype.fromLeft
                case .toRight:
                    transition.subtype = CATransitionSubtype.fromRight
                case .toTop:
                    transition.subtype = CATransitionSubtype.fromTop
                case .toBottom:
                    transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }
        
        /// Background of the transition
        ///
        /// - solidColor: solid color
        /// - customView: custom view
        public enum Background {
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }
        
        /// Duration of the animation (default is 0.20s)
        public var duration: TimeInterval = 0.20
        
        /// Direction of the transition (default is `toRight`)
        public var direction: TransitionOptions.Direction = .toRight
        
        /// Style of the transition (default is `linear`)
        public var style: TransitionOptions.Curve = .linear
        
        /// Background of the transition (default is `nil`)
        public var background: TransitionOptions.Background? = nil
        
        /// Initialize a new options object with given direction and curve
        ///
        ///   - Parameters:
        ///   - direction: direction
        ///   - style: style
        public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }
        
        public init() { }
        
        /// Return the animation to perform for given options object
        internal var animation: CATransition {
            let transition = self.direction.transition()
            transition.duration = self.duration
            transition.timingFunction = self.style.function
            return transition
        }
    }
    
    
    /// Change the root view controller of the window
    ///
    ///    - Parameters:
    ///   - controller: controller to set
    ///   - options: options of the transition
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {
        
        var transitionWnd: UIWindow? = nil
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
            switch background {
            case .customView(let view):
                transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
            case .solidColor(let color):
                transitionWnd?.backgroundColor = color
            }
            transitionWnd?.makeKeyAndVisible()
        }
        
        // Make animation
        self.layer.add(options.animation, forKey: kCATransition)
        self.rootViewController = controller
        //self.makeKeyAndVisible()
        
        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: (.now() + 1 + options.duration), execute: {
                wnd.removeFromSuperview()
            })
        }
    }
}

internal extension UIViewController {
    
    /// Create a new empty controller instance with given view
    ///
    /// - Parameters:
    ///   - view: view
    ///   - frame: frame
    /// - Returns: instance
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
    
}



@IBDesignable
class SSSlider: UISlider{
    @IBInspectable var cHeight:CGFloat = 12
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: cHeight))
    }
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
    
}


//@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            //layer.masksToBounds = false
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIImageView{
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 10
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
}



@IBDesignable
class SSLabel: UILabel {
    
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override  func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override  var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override func layoutSubviews() {
        // self.adjustsFontSizeToFitWidth  = true
        //fontSize*(actualScreenWidth/designTimeScreenWidth)
        //  let newFontSize: Float = Float(17 * (UIScreen.main.bounds.size.width / 414.0))
        //        if UIScreen.main.bounds.size.height < 500 {
        //            newFontSize = Float(UIScreen.main.bounds.size.height * (self.font.pointSize / 480.0))
        //        }
        //   self.font = UIFont(name: self.font.fontName , size: CGFloat(newFontSize))
    }
    required  init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        
        
    }
    required override init(frame: CGRect)
    {
        super.init(frame: frame)
        //self.adjustsFontSizeToFitWidth  = true
        
    }
}
class TableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
}

extension TableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}

extension UIViewController {
    func isPresented() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    func topMostViewController() -> UIViewController {
        if let navigation = self as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if self.presentedViewController == nil {
            return self
        }
        
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        //        if (self.keyWindow?.rootViewController?.isKind(of: KYDrawerController.classForCoder()))!{
        //            return (self.keyWindow?.rootViewController as! KYDrawerController).mainViewController.topMostViewController()
        //        }
        return self.windows.first?.rootViewController?.topMostViewController()
    }
}


extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
}
extension Date {
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    fileprivate struct Item {
        let multi: String
        let single: String
        let last: String
        let value: Int?
    }
    
    fileprivate var components: DateComponents {
        return Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year, .second],
            from: Calendar.current.date(byAdding: .second, value: -1, to: Date())!,
            to: self
        )
    }
    
    fileprivate var items: [Item] {
        return [
            Item(multi: "years ago", single: "1 year ago", last: "Last year", value: components.year),
            Item(multi: "months ago", single: "1 month ago", last: "Last month", value: components.month),
            Item(multi: "weeks ago", single: "1 week ago", last: "Last week", value: components.weekday),
            Item(multi: "days ago", single: "1 day ago", last: "Last day", value: components.day),
            Item(multi: "minutes ago", single: "1 minute ago", last: "Last minute", value: components.minute),
            Item(multi: "seconds ago", single: "Just now", last: "Last second", value: components.second)
        ]
    }
    
    public func timeAgo(numericDates: Bool = false) -> String {
        for item in items {
            switch (item.value, numericDates) {
            case let (.some(step), _) where step == 0:
                continue
            case let (.some(step), true) where step == 1:
                return item.last
            case let (.some(step), false) where step == 1:
                return item.single
            case let (.some(step), _):
                return String(step) + " " + item.multi
            default:
                continue
            }
        }
        
        return "Just now"
    }
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

public class SSTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable public var underLineColor: UIColor = UIColor.white
    @IBInspectable public var activeUnderLineColor: UIColor = UIColor.black
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    var bottomLine = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override public func draw(_ rect: CGRect) {
        drawUnderLine()
        self.clipsToBounds = false
        self.borderStyle = .none
    }
    
    fileprivate func drawUnderLine() {
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = underLineColor.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = activeUnderLineColor.cgColor
        
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if (self.text?.replacingOccurrences(of: " ", with: "").count)! > 0{
            bottomLine.backgroundColor = activeUnderLineColor.cgColor
        }else{
            bottomLine.backgroundColor = underLineColor.cgColor
        }
    }
    
    
    
}
//class CustomSlider: UISlider {
//    
//    
//    
//    @IBInspectable var height: CGFloat = 8
//    override func trackRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: height))
//    }
//    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        return true
//    }
//    
//    
//}

extension UIView {
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    //    static func random() -> UIColor {
    //        return UIColor(red:   .random(),
    //                       green: .random(),
    //                       blue:  .random(),
    //                       alpha: 1.0)
    //    }
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}

//@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear
    @IBInspectable var secondColor: UIColor = UIColor.black.withAlphaComponent(0.9)
    
    @IBInspectable var vertical: Bool = true
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}
public extension UIView {
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    func setGradientBg() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear, UIColor.black.withAlphaComponent(0.8)]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    func setGradientBgWith(colors:Array<CGColor>) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setGradientBorder(
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    ) {
        let existedBorder = gradientBorderLayer()
        let border = existedBorder ?? CAGradientLayer()
        border.frame = bounds
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        
        let exists = existedBorder != nil
        if !exists {
            layer.addSublayer(border)
        }
        border.name = UIView.kLayerNameGradientBorder
    }
    
    func removeGradientBorder() {
        self.gradientBorderLayer()?.removeFromSuperlayer()
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
}


protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.9) {
        // create effect
        if self.subviews.count > 0{
            self.willRemoveSubview(self.subviews[0])
        }
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.insertSubview(effectView, at: 0)
    }
}

// Conformance
extension UIView: Bluring {}


//        let circle = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        circle.backgroundColor = .gray
//
//        circle.cornerRadius = 100
//
//        let progressLayer = CAShapeLayer()
//
//
//        let circularPath = UIBezierPath(arcCenter:CGPoint(x: circle.bounds.width/2, y: circle.bounds.height/2), radius: 96, startAngle: -.pi, endAngle:.pi * 2 , clockwise: false)
//
//        progressLayer.path = circularPath.cgPath
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.strokeColor = UIColor.green.cgColor
//        progressLayer.lineCap = .round
//        progressLayer.lineWidth = 8.0
//        progressLayer.strokeEnd = 0
//
//        circle.layer.addSublayer(progressLayer)
//
//        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        progressAnimation.toValue = 0.5
//        progressAnimation.fillMode = .forwards
//        progressAnimation.isRemovedOnCompletion = false
//        progressAnimation.duration = 2.0
//        progressLayer.add(progressAnimation, forKey: "progressAnim")
//
//        self.view.addSubview(circle)

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    func setNewcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}
extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}
class HeartButton: UIButton {
    private var isLiked = false
    
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedImage = UIImage(systemName: "heart.fill")
    
    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 2.0
    
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setImage(unlikedImage, for: .normal)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    public func likeState(){
        isLiked = true
        self.tintColor = .red
        animate()
    }
    public func unLikeState(){
        isLiked = false
        self.tintColor = .white
        animate()
    }
    
    public func flipLikedState() {
        isLiked = !isLiked
        self.tintColor = self.isLiked ? .red : .white
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            let newScale = self.isLiked ? self.likedScale : self.unlikedScale
            self.transform = self.transform.scaledBy(x: newScale, y: newScale)
            self.setImage(newImage, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension UIScrollView {
  var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }

  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }
    func scrollToBottom(animated: Bool) {
        var y: CGFloat = 0.0
        let HEIGHT = self.frame.size.height
        if self.contentSize.height > HEIGHT {
            y = self.contentSize.height - HEIGHT
        }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }

}

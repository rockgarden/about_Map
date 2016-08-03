//
//  BasePageCollectionCell.swift
//
//  Created by Alex K. on 04/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//
//  Modify by wangkna. on 30/07/16.
//

import UIKit

/// Base class for UICollectionViewCell
public class BasePageCollectionCell: UICollectionViewCell {
    
    // MARK: - Constants -
    
    /// Animation oposition offset when cell is open
    @IBInspectable
    public var yOffset: CGFloat = 40
    /// A Boolean value that indicates whether the cell is opened.
    public var isOpened = false
    /// frontContainerView open状态 Y轴向上的偏移
    public var open_front_yOffset: CGFloat = 50
    public var open_front_hOffset: CGFloat = 16
    /// backContainerView open状态 Y轴向下的偏移
    public var open_back_yOffset: CGFloat = 20
    /// frontContainerView open状态 width 缩小偏移
    public var open_front_wOffset: CGFloat = 30
    
    /**
     *  Views Constants for NSCoder
     */
    struct Constants {
        static let backContainer = "backContainerViewKey"
        static let shadowView = "shadowViewKey"
        static let frontContainer = "frontContainerKey"
        static let backContainerY = "backContainerYKey"
        static let frontContainerY = "frontContainerYKey"
    }
    
    /**
     *  保存外部定义的itemSize初值
     */
    struct itemSize {
        static var height: CGFloat = 0.0
        static var width: CGFloat = 0.0
    }
    
    // MARK: - Vars -
    
    /// The view used as the face of the cell must connectid from xib or storyboard.
    @IBOutlet public weak var frontContainerView: UIView!
    /// constraints for frontContainerView must connectid from xib or storyboard
    @IBOutlet weak var frontContainerViewH: NSLayoutConstraint!
    @IBOutlet weak var frontContainerViewW: NSLayoutConstraint!
    @IBOutlet public weak var frontConstraintY: NSLayoutConstraint!
    /// The view used as the back of the cell must connectid from xib or storyboard.
    @IBOutlet public weak var backContainerView: UIView!
    /// constraints for backContainerView must connectid from xib or storyboard
    @IBOutlet weak var backContainerViewH: NSLayoutConstraint!
    @IBOutlet weak var backContainerViewW: NSLayoutConstraint!
    @IBOutlet public weak var backConstraintY: NSLayoutConstraint!
    
    var shadowView: UIView?
    
    // MARK: - inits -
    
    /**
     Initializes a UICollectionViewCell from data in a given unarchiver.
     
     - parameter aDecoder: An unarchiver object.
     
     - returns: An initialized UICollectionViewCell object.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureOutletFromDecoder(aDecoder)
    }
    
    /**
     Initializes and returns a newly allocated view object with the specified frame rectangle.
     
     - parameter frame: The frame rectangle for the view
     
     - returns: An initialized UICollectionViewCell object.
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}

// MARK: - life cicle

extension BasePageCollectionCell {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    private func commonInit() {
        configurationViews()
        shadowView = createShadowViewOnView(frontContainerView)
    }
    
}

// MARK: - Control -

extension BasePageCollectionCell {
    
    /**
     Open or close cell.
     frontContainerView.bounds.size.height ?= itemSize
     
     - parameter isOpen: Contains the value true if the cell should display open state, if false should display close state.
     - parameter animated: Set to true if the change in selection state is animated.
     */
    public func cellIsOpen(isOpen: Bool, animated: Bool = true) {
        /// 设置open时frontContainerView的width
        let openWidth = itemSize.width - open_front_wOffset
        
        if isOpen == isOpened {
            /// 根据frontView大小设置shadowView的shadowPath
            let shadowHeight = itemSize.height - (open_front_yOffset + open_front_hOffset) * 2
            shadowView?.getConstraint(.Width)?.constant = openWidth
            shadowView?.getConstraint(.Height)?.constant = shadowHeight
            shadowView?.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: openWidth, height: shadowHeight), cornerRadius: 0).CGPath
            return
        }
        frontConstraintY.constant = isOpen == true ? -open_front_yOffset: 0
        backConstraintY.constant = isOpen == true ? open_back_yOffset : 0
        frontContainerViewH.constant = isOpen == true ? itemSize.height - open_front_yOffset * 2 + open_front_hOffset : itemSize.height
        frontContainerViewW.constant = isOpen == true ? openWidth : itemSize.width
        
        configurationCell()
        
        if animated == true {
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
                self.contentView.layoutIfNeeded()
                }, completion: nil)
        } else {
            self.contentView.layoutIfNeeded()
        }
        
        isOpened = isOpen
    }
}

// MARK: - Configuration

extension BasePageCollectionCell {
    
    private func configurationViews() {
        backContainerView.layer.masksToBounds = true
        backContainerView.layer.cornerRadius = 5
        frontContainerView.layer.masksToBounds = true
        frontContainerView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
    }
    
    /**
     基于xib的size生成frontView的shadowView
     
     - parameter view: <#view description#>
     
     - returns: <#return value description#>
     */
    private func createShadowViewOnView(view: UIView?) -> UIView? {
        guard let view = view else { return nil }
        
        let shadow = Init(UIView(frame: .zero)) {
            $0.backgroundColor = .clearColor()
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.masksToBounds = false;
            $0.layer.shadowColor = UIColor.blackColor().CGColor
            $0.layer.shadowRadius = 10
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        contentView.insertSubview(shadow, belowSubview: view)
        
        // create constraints
        for info: (attribute: NSLayoutAttribute, scale: CGFloat) in [(NSLayoutAttribute.Width, 0.8), (NSLayoutAttribute.Height, 0.9)] {
            if let frontViewConstraint = view.getConstraint(info.attribute) {
                shadow >>>- {
                    $0.attribute = info.attribute
                    $0.constant = frontViewConstraint.constant * info.scale
                }
            }
        }
        for info: (attribute: NSLayoutAttribute, offset: CGFloat) in [(NSLayoutAttribute.CenterX, 0), (NSLayoutAttribute.CenterY, 30)] {
            (contentView, shadow, view) >>>- {
                $0.attribute = info.attribute
                $0.constant = info.offset
            }
        }
        
        return shadow
    }
    
    /**
     重置Cell
     */
    func configurationCell() {
        // Prevents indefinite growing of the cell issue
        let i: CGFloat = self.isOpened ? 1 : -1
        let superHeight = superview?.frame.size.height ?? 0
        frame.size.height += i * superHeight
        frame.origin.y -= i * superHeight / 2
        frame.origin.x -= i * yOffset / 2
        frame.size.width += i * yOffset
    }
    
    func configureCellViewConstraintsWithSize(size: CGSize) {
        if itemSize.height == 0.0 {
            itemSize.height = size.height
            itemSize.width = size.width
        }
        
        // Opened = false 保持 backContainerView 和 frontContainerView的状态
        // 没必要判断 && frontContainerView.getConstraint(.Width)?.constant != size.width
        guard isOpened == false else { return }
        
        // Opened = true 时重置 frontContainerView = backContainerView = size
        [frontContainerView, backContainerView].forEach {
            let constraintWidth = $0.getConstraint(.Width)
            constraintWidth?.constant = size.width
            let constraintHeight = $0.getConstraint(.Height)
            constraintHeight?.constant = size.height
        }
    }
}

// MARK: - NSCoding -

extension BasePageCollectionCell {
    
    private func highlightedImageFalseOnView(view: UIView) {
        for item in view.subviews {
            if case let imageView as UIImageView = item {
                imageView.highlighted = false
            }
            if item.subviews.count > 0 {
                highlightedImageFalseOnView(item)
            }
        }
    }
    
    private func copyShadowFromView(fromView: UIView, toView: UIView) {
        fromView.layer.shadowPath = toView.layer.shadowPath
        fromView.layer.masksToBounds = toView.layer.masksToBounds
        fromView.layer.shadowColor = toView.layer.shadowColor
        fromView.layer.shadowRadius = toView.layer.shadowRadius
        fromView.layer.shadowOpacity = toView.layer.shadowOpacity
        fromView.layer.shadowOffset = toView.layer.shadowOffset
    }
    
    func copyCell() -> BasePageCollectionCell? {
        highlightedImageFalseOnView(contentView)
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        guard case let copyView as BasePageCollectionCell = NSKeyedUnarchiver.unarchiveObjectWithData(data),
            let shadowView = self.shadowView else {
                return nil
        }
        
        // configure
        copyView.backContainerView.layer.masksToBounds = backContainerView.layer.masksToBounds
        copyView.backContainerView.layer.cornerRadius = backContainerView.layer.cornerRadius
        copyView.frontContainerView.layer.masksToBounds = frontContainerView.layer.masksToBounds
        copyView.frontContainerView.layer.cornerRadius = frontContainerView.layer.cornerRadius
        
        // copy shadow layer
        copyShadowFromView(copyView.shadowView!, toView: shadowView)
        
        for index in 0..<copyView.frontContainerView.subviews.count {
            copyShadowFromView(copyView.frontContainerView.subviews[index], toView: frontContainerView.subviews[index])
        }
        return copyView
    }
    
    /**
     encode Constants
     保存CollectionCell中的View
     
     - parameter coder: NSCoder
     */
    public override func encodeWithCoder(coder: NSCoder) {
        super.encodeWithCoder(coder)
        coder.encodeObject(backContainerView, forKey: Constants.backContainer)
        coder.encodeObject(frontContainerView, forKey: Constants.frontContainer)
        coder.encodeObject(frontConstraintY, forKey: Constants.frontContainerY)
        coder.encodeObject(backConstraintY, forKey: Constants.backContainerY)
        coder.encodeObject(shadowView, forKey: Constants.shadowView)
    }
    
    /**
     decode Constants
     恢复CollectionCell中的View
     
     - parameter coder: NSCoder
     */
    private func configureOutletFromDecoder(coder: NSCoder) {
        if case let shadowView as UIView = coder.decodeObjectForKey(Constants.shadowView) {
            self.shadowView = shadowView
        }
        if case let backView as UIView = coder.decodeObjectForKey(Constants.backContainer) {
            backContainerView = backView
        }
        if case let frontView as UIView = coder.decodeObjectForKey(Constants.frontContainer) {
            frontContainerView = frontView
        }
        if case let constraint as NSLayoutConstraint = coder.decodeObjectForKey(Constants.frontContainerY) {
            frontConstraintY = constraint
        }
        if case let constraint as NSLayoutConstraint = coder.decodeObjectForKey(Constants.backContainerY) {
            backConstraintY = constraint
        }
    }
}
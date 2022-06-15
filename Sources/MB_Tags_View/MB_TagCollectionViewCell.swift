//
//  MB_TagCollectionViewCell.swift
//  FigaroEmploi
//
//  Created by VASILIJEVIC Sebastien on 11/12/2019.
//  Copyright © 2019 FIGARO CLASSIFIEDS. All rights reserved.
//

import UIKit
import SnapKit

class MB_TagCollectionViewCell: UICollectionViewCell {
    
	public class var identifier: String {
		
		return "tagCollectionViewCellIdentifier"
	}
	public var _tag:MB_Tag? {
		
		didSet {
			
			contentView.layer.cornerRadius = _tag?.cornerRadius ?? UI.Margins
			contentStackView.layoutMargins = _tag?.edgeInsets ?? .zero
			
			customView.subviews.forEach({ $0.removeFromSuperview() })
			customView.isHidden = true
			
			if let view = _tag?.customView {
				
				customView.addSubview(view)
				customView.isHidden = false
				
				view.snp.makeConstraints { (make) in
					make.edges.equalToSuperview()
				}
			}
			
			label.isHidden = true
			
			if let text = _tag?.text {
				
				label.isHidden = false
				label.text = text
				label.font = _tag?.font ?? label.font
				label.textColor = _tag?.textColor ?? label.textColor
			}
			
			imageView.isHidden = _tag?.image == nil && _tag?.selectedImage == nil
			imageView.tintColor = _tag?.imageColor ?? imageView.tintColor
			
			isChecked = { isChecked }()
		}
	}
	private lazy var customView:UIView = .init()
	public var isChecked: Bool = false {
		
		didSet{
			
			let animationDuration:Double = 0.15
			
			UIView.transition(with: label, duration: animationDuration, options: [.curveEaseInOut,.transitionCrossDissolve]) {
				
				self.label.textColor = !self.isChecked ? self._tag?.textColor : self._tag?.selectedTextColor
			}
			
			UIView.transition(with: imageView, duration: animationDuration, options: [.curveEaseInOut,.transitionCrossDissolve]) {
				
				self.imageView.image = !self.isChecked ? self._tag?.image : self._tag?.selectedImage
			}
			
			UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut,.transitionCrossDissolve]) {
				
				self.imageView.tintColor = !self.isChecked ? self._tag?.imageColor : self._tag?.selectedImageColor
				self.contentView.backgroundColor = !self.isChecked ? self._tag?.backgroundColor : self._tag?.selectedBackgroundColor
			}
			
			let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
			animation.fromValue = contentView.layer.borderColor
			animation.toValue = !isChecked ? (_tag?.borderColor?.cgColor ?? UIColor.clear.cgColor) : (_tag?.selectedBorderColor?.cgColor ?? UIColor.clear.cgColor)
			animation.duration = animationDuration
			contentView.layer.add(animation, forKey: "borderColor")
			contentView.layer.borderColor = !isChecked ? (_tag?.borderColor?.cgColor ?? UIColor.clear.cgColor) : (_tag?.selectedBorderColor?.cgColor ?? UIColor.clear.cgColor)
		}
	}
	public var maxWidth: CGFloat? = nil {
		
		didSet {
			
			if let maxWidth = maxWidth {
				
				contentView.snp.updateConstraints { (make) in
					make.width.lessThanOrEqualTo(maxWidth)
				}
			}
		}
	}
	private lazy var contentStackView:UIStackView = {
		
		let stackView:UIStackView = .init(arrangedSubviews: [customView,label,imageView])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = UI.Margins/3
		stackView.isLayoutMarginsRelativeArrangement = true
		return stackView
	}()
	private lazy var label:UILabel = {
		
		let label:UILabel = .init()
		label.lineBreakMode = .byTruncatingMiddle
		label.font = Fonts.Content.Bold
		label.textColor = Colors.Text
		return label
	}()
	private lazy var imageView:UIImageView = {
		
		let imageView:UIImageView = .init()
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = Colors.Text
		
		imageView.snp.makeConstraints { (make) in
			make.width.equalTo(1.5*UI.Margins)
		}
		
		return imageView
	}()
	
    override init(frame: CGRect) {
		
        super.init(frame: frame)
		
		contentView.layer.borderWidth = 1.0
		contentView.backgroundColor = Colors.Gray
		contentView.addSubview(contentStackView)
		layer.masksToBounds = false
		
		contentView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.lessThanOrEqualTo(0)
		}
		
		contentStackView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.height.greaterThanOrEqualTo(1.5*UI.Margins)
		}
    }
    
    required init?(coder aDecoder: NSCoder) {
		
        super.init(coder: aDecoder)
    }
	
	public override var isHighlighted: Bool {
		
		didSet {
			
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut,.allowUserInteraction], animations: {
				
				self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
				
			}, completion: nil)
		}
	}
}

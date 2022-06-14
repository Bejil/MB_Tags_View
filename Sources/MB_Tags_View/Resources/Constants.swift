//
//  Constants.swift
//
//
//  Created by BLIN Michael on 26/01/2022.
//

import UIKit

struct UI {
	
	static let Margins:CGFloat = 15.0
	static let CornerRadius:CGFloat = Margins/2
}

struct Colors {
	
	static let Text:UIColor = UIColor(named: "Text")!
	static let Gray:UIColor = UIColor(named: "Gray")!
	static let Secondary:UIColor = UIColor(named: "Secondary")!
}

struct Fonts {
	
	struct Size {
		
		static let Default:CGFloat = 14.0
	}
	
	struct Content {
		
		static let Bold:UIFont = .boldSystemFont(ofSize: Fonts.Size.Default)
	}
}

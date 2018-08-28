//
//  Regularswift
//  ModularTable
//
//  Created by mikun on 2018/8/15.
//  Copyright © 2018 mdk. All rights reserved.
//

import UIKit

class RegularCell: UITableViewCell{

	@IBOutlet weak var titleLabel: UILabel!

	@IBOutlet weak var descriptionLabel: UILabel!

	@IBOutlet weak var iconImageView: UIImageView!


}


struct RegularCellConfigurator {
	static func config(cell:RegularCell ,TableNode node:TableNode ) -> () {
		cell.titleLabel.text = node.title
		cell.descriptionLabel.text = node.desc
		cell.iconImageView.image = node.icon
	}
}

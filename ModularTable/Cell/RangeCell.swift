//
//  Rangeswift
//  ModularTable
//
//  Created by mikun on 2018/8/15.
//  Copyright © 2018 mdk. All rights reserved.
//

import UIKit

class RangeCell: UITableViewCell{

	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var minLabel: UILabel!
	@IBOutlet weak var maxLabel: UILabel!
	@IBOutlet weak var sliderView: UISlider!


}

struct RangeCellConfigurator {
	static func config(cell:RangeCell ,TableNode node:TableNode ) -> () {
		cell.titleLabel.text = node.title
		cell.maxLabel.text = "\(node.max)"
		cell.minLabel.text = "\(node.min)"
		cell.sliderView.maximumValue = Float(node.max)
		cell.sliderView.minimumValue = Float(node.min)
		cell.sliderView.value = Float(node.current)
	}
}

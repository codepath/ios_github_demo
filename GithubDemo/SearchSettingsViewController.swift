//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController, UITableViewDataSource, ValueSliderCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var settings: GithubRepoSearchSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let minStarsCell = tableView.dequeueReusableCellWithIdentifier("ValueSliderCell") as ValueSliderCell
        minStarsCell.configure("Mininum Stars", valueMinimum: 0, valueMaximum: 5000)
        minStarsCell.slider.value = Float(settings.minStars)
        minStarsCell.valueLabel.text = String(settings.minStars)
        minStarsCell.valueIdentifer = "Mininum Stars"
        minStarsCell.delegate = self
        return minStarsCell
    }

    func sliderValueDidChange(cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float) {
        if let identifier = valueIdentifier as? String {
            if identifier == "Mininum Stars" {
                settings?.minStars = Int(newValue)
                tableView.reloadData()
            }
        }

    }
    
}

protocol ValueSliderCellDelegate: class {
    func sliderValueDidChange(cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float)
}

class ValueSliderCell: UITableViewCell {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    var valueIdentifer: AnyObject = ""
    weak var delegate: ValueSliderCellDelegate?
    
    func configure(labelText: String, valueMinimum: Float, valueMaximum: Float) {
        label.text = labelText
        slider.minimumValue = valueMinimum
        slider.maximumValue = valueMaximum
    }
    
    @IBAction func valueDidChange(sender: AnyObject) {
        delegate?.sliderValueDidChange(self, valueIdentifier: valueIdentifer, newValue: slider.value)
    }
}

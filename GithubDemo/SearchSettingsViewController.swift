//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController, UITableViewDataSource, ValueSliderCellDelegate, ToggleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var settings: GithubRepoSearchSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if settings.shouldFilterLanguages {
                return 1 + settings.languages.count
            }
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let minStarsCell = tableView.dequeueReusableCellWithIdentifier("ValueSliderCell") as ValueSliderCell
            minStarsCell.configure("Mininum Stars", valueMinimum: 0, valueMaximum: 5000)
            minStarsCell.slider.value = Float(settings.minStars)
            minStarsCell.valueLabel.text = String(settings.minStars)
            minStarsCell.valueIdentifer = "Mininum Stars"
            minStarsCell.delegate = self
            return minStarsCell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let filterLanguagesCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
                filterLanguagesCell.descriptionLabel.text = "Filter by Language"
                filterLanguagesCell.switchIdentifier = "Filter by Language"
                filterLanguagesCell.onOffSwitch.on = settings.shouldFilterLanguages
                filterLanguagesCell.delegate = self
                return filterLanguagesCell
            } else if indexPath.row <= settings.languages.count {
                let languageCell = tableView.dequeueReusableCellWithIdentifier("CheckMarkCell") as CheckMarkCell
                languageCell.descriptionLabel.text = settings.languages[indexPath.row - 1]
                languageCell.switchIdentifier = "language:" + settings.languages[indexPath.row - 1]
                languageCell.isChecked = settings.includeLanguage[indexPath.row - 1]
                languageCell.delegate = self
                return languageCell
            }
        }
        
        return tableView.dequeueReusableCellWithIdentifier("CheckMarkCell") as CheckMarkCell
    }
    
    func sliderValueDidChange(cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float) {
        if let identifier = valueIdentifier as? String {
            if identifier == "Mininum Stars" {
                settings?.minStars = Int(newValue)
                tableView.reloadData()
            }
        }

    }
    
    func toggleCellDidToggle(cell: UITableViewCell, toggleIdenfifier: AnyObject, newValue:Bool) {
        if let identifier = toggleIdenfifier as? String {
            if identifier == "Filter by Language" {
                settings?.shouldFilterLanguages = newValue
                tableView.reloadData()
            } else if identifier.hasPrefix("language:") {
                // get language identifier and find its index in the array
                let index = identifier.rangeOfString("language:")?.endIndex
                let language = identifier.substringFromIndex(index!)
                let languageIndex = find(settings.languages, language)
                
                if let languageIndex = languageIndex? {
                    settings.includeLanguage[languageIndex] = newValue
                }
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

protocol ToggleCellDelegate: class {
    func toggleCellDidToggle(cell: UITableViewCell, toggleIdenfifier: AnyObject, newValue:Bool)
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!

    var switchIdentifier: AnyObject = ""
    weak var delegate: ToggleCellDelegate?
    
    @IBAction func didToggleSwitch(sender: AnyObject) {
        delegate?.toggleCellDidToggle(self, toggleIdenfifier: switchIdentifier, newValue: onOffSwitch.on)
    }
}

class CheckMarkCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var switchIdentifier: AnyObject = ""
    var isChecked: Bool = false
        {
        didSet {
            if isChecked {
                self.accessoryType = .Checkmark
            } else {
                self.accessoryType = .None
            }
        }
    }
    weak var delegate: ToggleCellDelegate?
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected && !self.selected {
            super.setSelected(true, animated: true)
            isChecked = !isChecked
            delegate?.toggleCellDidToggle(self, toggleIdenfifier: switchIdentifier, newValue: isChecked)
            super.setSelected(false, animated: true)
        }
    }
}

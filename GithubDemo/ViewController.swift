//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()
    var repositories: [GithubRepo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // add search bar to navigation bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        doSearch()
    }
    
    private func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        GithubRepo.fetchRepos(searchSettings, successCallback: { (repos) -> Void in
            self.repositories = repos
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }, error: { (error) -> Void in
            println(error)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingsSegue" {
            // we wrapped our SearchSettingsViewController inside a UINavigationController
            let navController = segue.destinationViewController as UINavigationController
            let settingsVC = navController.topViewController as SearchSettingsViewController
            settingsVC.settings = self.searchSettings
        }
    }
    
    @IBAction func didSaveSettings(segue: UIStoryboardSegue) {
        let settingsVC = segue.sourceViewController as SearchSettingsViewController
        searchSettings = settingsVC.settings
        doSearch()
    }
    
    @IBAction func didCancelSettingChanges(segue: UIStoryboardSegue) {
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GithubRepoCell") as GithubRepoCell
        cell.setContentWithRepo(repositories[indexPath.row])
        return cell
    }
}

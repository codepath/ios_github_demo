//
//  GithubRepoSearchSettings.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation


struct GithubRepoSearchSettings {
    var searchString: String? = nil
    var minStars = 0
    var shouldFilterLanguages = false;
    let languages = ["Java", "JavaScript", "Objective-C", "Python", "Ruby", "Swift"]
    var includeLanguage = [true, true, true, true, true, true]
}
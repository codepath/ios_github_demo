//
//  GithubRepo.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

private let params = []
private let resourceUrl = "https://api.github.com/search/repositories?q=stars:>0&sort=stars&order=desc"

class GithubRepo {
    var name: String?
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var stars: Int?
    var forks: Int?
    
    
    init(jsonResult: NSDictionary) {
        
    }
    
    class func fetchRepos(successCallback: ([GithubRepo]) -> Void, error: ((NSError?) -> Void)?) {
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(resourceUrl, parameters: params, success: { (operation ,responseObject) -> Void in
            if let results = responseObject["items"] as? NSArray {
                var repos: [GithubRepo] = []
                for result in results as [NSDictionary] {
                    repos.append(GithubRepo(jsonResult: result))
                }
                successCallback(repos)
            }
        }, failure: { (operation, requestError) -> Void in
            if let errorCallback = error? {
                errorCallback(requestError)
            }
        })
    }
}
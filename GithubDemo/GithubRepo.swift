//
//  GithubRepo.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation
import AFNetworking

private let reposUrl = "https://api.github.com/search/repositories"
private let clientId: String? = nil
private let clientSecret: String? = nil

class GithubRepo: CustomStringConvertible {
    var name: String?
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var stars: Int?
    var forks: Int?
    
    
    init(jsonResult: NSDictionary) {
        if let name = jsonResult["name"] as? String {
            self.name = name
        }
        
        if let stars = jsonResult["stargazers_count"] as? Int? {
            self.stars = stars
        }
        
        if let forks = jsonResult["forks_count"] as? Int? {
            self.forks = forks
        }
        
        if let owner = jsonResult["owner"] as? NSDictionary {
            if let ownerHandle = owner["login"] as? String {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
    }
    
    class func fetchRepos(settings: GithubRepoSearchSettings, successCallback: ([GithubRepo]) -> Void, error: ((NSError?) -> Void)?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings);
        
        manager.GET(reposUrl, parameters: params, success: { (operation ,responseObject) -> Void in
            if let results = responseObject["items"] as? NSArray {
                var repos: [GithubRepo] = []
                for result in results as! [NSDictionary] {
                    repos.append(GithubRepo(jsonResult: result))
                }
                successCallback(repos)
            }
        }, failure: { (operation, requestError) -> Void in
            if let errorCallback = error {
                errorCallback(requestError)
            }
        })
    }
    
    private class func queryParamsWithSettings(settings: GithubRepoSearchSettings) -> [String: String] {
        var params: [String:String] = [:];
        if let clientId = clientId {
            params["client_id"] = clientId;
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret;
        }
        
        var q = "";
        if let searchString = settings.searchString {
            q = q + searchString;
        }
        q = q + " stars:>\(settings.minStars)";
        params["q"] = q;
        
        params["sort"] = "stars";
        params["order"] = "desc";
        
        return params;
    }

    var description: String {
        return "[Name: \(self.name!)]" +
            "\n\t[Stars: \(self.stars!)]" +
            "\n\t[Forks: \(self.forks!)]" +
            "\n\t[Owner: \(self.ownerHandle!)]" +
            "\n\t[Avatar: \(self.ownerAvatarURL!)]"
    }
}
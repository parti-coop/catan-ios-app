//
//  Poll.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 7..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

class Poll: JSONDecodable {
    required init(json: JSON) throws {
        id = json["id"].intValue
        title = json["title"].stringValue
        votingsCount = json["votings_count"].intValue
        agreedVotingsCount = json["agreed_votings_count"].intValue
        disagreedVotingsCount = json["disagreed_votings_count"].intValue
        
        if let latestAgreedVotingUsersJSON = json["latest_agreed_voting_users"].array {
            latestAgreedVotingUsers = try latestAgreedVotingUsersJSON.decode()
        } else {
            latestAgreedVotingUsers = [User]()
        }
        if let latestDisagreedVotingUsersJSON = json["latest_disagreed_voting_users"].array {
            latestDisagreedVotingUsers = try latestDisagreedVotingUsersJSON.decode()
        } else {
            latestDisagreedVotingUsers = [User]()
        }
        myChoice = json["my_choice"].stringValue
    }
    
    let id: Int
    let title: String
    var votingsCount: Int
    var agreedVotingsCount: Int
    var disagreedVotingsCount: Int
    var latestAgreedVotingUsers: [User]
    var latestDisagreedVotingUsers: [User]
    var myChoice: String
    
    func isAgreed() -> Bool {
        return myChoice == "agree"
    }
    
    func isDisagreed() -> Bool {
        return myChoice == "disagree"
    }
    
    func isVoted() -> Bool {
        return isAgreed() || isDisagreed()
    }
    
    func vote(_ choice: String, by user: User) {
        switch choice {
        case "unsure":
            unsure(by: user)
            break
        case "agree":
            agree(by: user)
            break
        case "disagree":
            disagree(by: user)
            break
        default:
            break
        }
    }
    
    func unsure(by user: User) {
        if !isVoted() { return }
        
        if !isVoted() {
            votingsCount -= 1
        }
        if isAgreed() {
            agreedVotingsCount -= 1
        }
        if isDisagreed() {
            disagreedVotingsCount -= 1
        }
        myChoice = "unsure"
        
        removeVotingUser(user)
    }
    
    func agree(by user: User) {
        if isAgreed() { return }
        
        agreedVotingsCount += 1
        if !isVoted() {
            votingsCount += 1
        }
        if isDisagreed() {
            disagreedVotingsCount -= 1
        }
        myChoice = "agree"
        
        removeVotingUser(user)
        latestAgreedVotingUsers.append(user)
    }
    
    func disagree(by user: User) {
        if isDisagreed() { return }
        
        disagreedVotingsCount += 1
        if !isVoted() {
            votingsCount += 1
        }
        if isAgreed() {
            agreedVotingsCount -= 1
        }
        myChoice = "disagree"
        
        removeVotingUser(user)
        latestDisagreedVotingUsers.append(user)
    }
    
    func removeVotingUser(_ user: User) {
        if let index = latestAgreedVotingUsers.index(where: { $0.id == user.id }) {
            self.latestAgreedVotingUsers.remove(at: index)
        }
        if let index = latestDisagreedVotingUsers.index(where: { $0.id == user.id }) {
            self.latestDisagreedVotingUsers.remove(at: index)
        }
    }
}


//
//  DataManager.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 05/05/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

class SmartSet: NSObject, NSCoding {
    var name: String
    var cover: UIImage
    var about: String
    var knowledge: Double // General knowledge of set
    var timeLastTrainEnd: Double // Time from 1 January 1970 to moment then last training ended
    var words_knowledge: [Double] = [Double]()
    var words_front: [String] = [String]()
    var words_back: [String] = [String]()
    
    
    
    private let setNameKey = "setNameKey"
    private let setCoverKey = "setCoverKey"
    private let setAboutKey = "setAboutKey"
    private let setKnowledgeKey = "setKnowledgeKey"
    private let setTimeLastTrainEndKey = "setTimeLastTrainEndKey"
    private let setWordsKnowledgeKey = "setWordsKnowledgeKey"
    private let setWordsFrontKey = "setWordsFrontKey"
    private let setWordsBackKey = "setWordsBackKey"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: setNameKey)
        aCoder.encode(cover, forKey: setCoverKey)
        aCoder.encode(about, forKey: setAboutKey)
        aCoder.encode(knowledge, forKey: setKnowledgeKey)
        aCoder.encode(timeLastTrainEnd, forKey: setTimeLastTrainEndKey)
        aCoder.encode(words_knowledge, forKey: setWordsKnowledgeKey)
        aCoder.encode(words_front, forKey: setWordsFrontKey)
        aCoder.encode(words_back, forKey: setWordsBackKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: setNameKey) as! String
        self.cover = aDecoder.decodeObject(forKey: setCoverKey) as! UIImage
        self.about = aDecoder.decodeObject(forKey: setAboutKey) as! String
        self.knowledge = aDecoder.decodeDouble(forKey: setKnowledgeKey)
        self.timeLastTrainEnd = aDecoder.decodeDouble(forKey: setTimeLastTrainEndKey)
        self.words_knowledge = aDecoder.decodeObject(forKey: setWordsKnowledgeKey) as! [Double]
        self.words_front = aDecoder.decodeObject(forKey: setWordsFrontKey) as! [String]
        self.words_back = aDecoder.decodeObject(forKey: setWordsBackKey) as! [String]
    }
    
    init(name: String, cover: UIImage, about: String, knowledge: Double, timeLastTrainEnd: Double) {
        self.name = name
        self.cover = cover
        self.about = about
        self.knowledge = knowledge
        self.timeLastTrainEnd = timeLastTrainEnd
    }
}

class DataManager {
    
    private(set) var sets = [SmartSet]() // запрещает модифицировать снаружи, только через собственные методы
    private let setsKey = "setsKey"
    
    init() {
        loadData()
    }
    
    private func loadData() {
        guard let data = UserDefaults.standard.object(forKey: setsKey) as? Data else {
            return
        }
        
        sets = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SmartSet] ?? []
    }
    
    func addSet(name: String, cover: UIImage, about: String, knowledge: Double, timeLastTrainEnd: Double) {
        sets.append(SmartSet(name: name, cover: cover, about: about, knowledge: knowledge, timeLastTrainEnd: timeLastTrainEnd))
        save()
    }
    
    func addCards(at: Int, words_knowledge: [Double], words_front: [String], words_back: [String]) {
        sets[at].words_knowledge = words_knowledge
        sets[at].words_front = words_front
        sets[at].words_back = words_back
        save()
    }
    
    func removeSet(index: Int) {
        sets.remove(at: index)
        save()
    }
    
//    func clearWordsKnowledge(at: Int) {
//        for i in 0..<sets[at].words_knowledge.count {
//            sets[at].words_knowledge[i] = 0
//        }
//        save()
//    }
    
    func changeKnowledge(at: Int, newValue: Double) {
        sets[at].knowledge = newValue
        save()
    }

    func changeTimeLastTrainEnd(at: Int, newValue: Double) {
        sets[at].timeLastTrainEnd = newValue
        save()
    }
    
    func archiveSets(sets: [SmartSet]) -> Data {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: sets as NSArray)
        return archivedObject
    }
    
    private func save() {
        let archivedObject = archiveSets(sets: sets)
        let defaults = UserDefaults.standard
        defaults.set(archivedObject, forKey: setsKey)
    }
}


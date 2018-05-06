//
//  DataManager.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 05/05/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

/* class wordsElement: NSObject, NSCoding {
    var word: (knowledge: Double, front: String, back: String)!
    
    private let wordKnowledgeKey = "wordKnowledgeKey"
    private let wordFrontKey = "wordFrontKey"
    private let wordBackKey = "wordBackKey"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(word.knowledge, forKey: wordKnowledgeKey)
        aCoder.encode(word.front, forKey: wordFrontKey)
        aCoder.encode(word.back, forKey: wordBackKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let knowledge = aDecoder.decodeObject(forKey: wordKnowledgeKey) as! Double
        let front = aDecoder.decodeObject(forKey: wordFrontKey) as! String
        let back = aDecoder.decodeObject(forKey: wordBackKey) as! String
        word = (knowledge, front, back)
    }
    
    init(knowledge: Double, front: String, back: String) {
        self.word.knowledge = knowledge
        self.word.front = front
        self.word.back = back
    }
} */

class SmartSet: NSObject, NSCoding {
    var name: String
    var cover: UIImage
    var about: String
    var words_knowledge: [Double] = [Double]()
    var words_front: [String] = [String]()
    var words_back: [String] = [String]()
    
    private let setNameKey = "setNameKey"
    private let setCoverKey = "setCoverKey"
    private let setAboutKey = "setAboutKey"
    private let setWordsKnowledgeKey = "setWordsKnowledgeKey"
    private let setWordsFrontKey = "setWordsFrontKey"
    private let setWordsBackKey = "setWordsBackKey"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: setNameKey)
        aCoder.encode(cover, forKey: setCoverKey)
        aCoder.encode(about, forKey: setAboutKey)
        aCoder.encode(words_knowledge, forKey: setWordsKnowledgeKey)
        aCoder.encode(words_front, forKey: setWordsFrontKey)
        aCoder.encode(words_back, forKey: setWordsBackKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: setNameKey) as! String
        self.cover = aDecoder.decodeObject(forKey: setCoverKey) as! UIImage
        self.about = aDecoder.decodeObject(forKey: setAboutKey) as! String
        self.words_knowledge = aDecoder.decodeObject(forKey: setWordsKnowledgeKey) as! [Double]
        self.words_front = aDecoder.decodeObject(forKey: setWordsFrontKey) as! [String]
        self.words_back = aDecoder.decodeObject(forKey: setWordsBackKey) as! [String]
    }
    
    init(name: String, cover: UIImage, about: String) {
        self.name = name
        self.cover = cover
        self.about = about
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
    
    func addSet(name: String, cover: UIImage, about: String) {
        sets.append(SmartSet(name: name, cover: cover, about: about))
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


//
//  SuggestionTrie.swift
//  ELDeveloperKeyboard
//
//  Created by Kari Kraam on 2016-04-25.
//  Copyright (c) 2016 Kari Kraam. All rights reserved.
//

import Foundation

/**
    An implementation of the SuggestionProvider protocol that uses a ternary search tree (trie) to store and search for terms.
*/
class SuggestionTrie: SuggestionProvider {
    
    // MARK: Properties

    private var root: SuggestionNode?
    
    // MARK: Constructors
    
    init() {}
    
    // MARK: SuggestionProvider methods

    func suggestionsForPrefix(prefix: String) -> [String] {
        if let node = searchForNodeMatchingPrefix(prefix, rootNode: root) {
            var weightedSuggestions = [WeightedString]()
            findSuggestionsForNode(node.equalKid, suggestions: &weightedSuggestions)
            return weightedSuggestions
                .sort { $0.weight >= $1.weight }
                .map { $0.term }
        }
        return []
    }
    
    func loadWeightedStrings(weightedStrings: [WeightedString]) {
        for ws in weightedStrings {
            insertString(ws.term, weight: ws.weight)
        }
    }
    
    func clear() {
        deleteNode(&root)
    }
    
    // MARK: Helper Methods
    
    private func insertString(s: String, weight: Int) {
        if let node = searchForNodeMatchingPrefix(s, rootNode: root) {
            node.isWordEnd = true
            node.weight = weight
        } else {
            insertString(s, charIndex: 0, weight: weight, node: &root)
        }
    }

    private func insertString(s: String, charIndex: Int, weight: Int, inout node: SuggestionNode?) {
        let charCount = s.characters.count
        if charCount > 0 {
            if node == nil {
                if charCount == charIndex + 1 {
                    node = SuggestionNode(term: s, weight: weight)
                } else {
                    node = SuggestionNode(term: s[0..<charIndex + 1])
                }
            }

            if s[charIndex] < node!.char {
                insertString(s, charIndex: charIndex, weight: weight, node: &node!.loKid)
            } else if s[charIndex] > node!.char {
                insertString(s, charIndex: charIndex, weight: weight, node: &node!.hiKid)
            } else if charCount > charIndex + 1 {
                insertString(s, charIndex: charIndex + 1, weight: weight, node: &node!.equalKid)
            }
        }
    }
    
    private func searchForNodeMatchingPrefix(prefix: String, rootNode: SuggestionNode?) -> SuggestionNode? {
        let charCount = prefix.characters.count
        if rootNode == nil || charCount == 0 {
            return nil
        } else if charCount == 1 && prefix == rootNode!.char {
            return rootNode
        }
        
        if prefix[0] < rootNode!.char {
            return searchForNodeMatchingPrefix(prefix, rootNode: rootNode!.loKid)
        } else if prefix[0] > rootNode!.char {
            return searchForNodeMatchingPrefix(prefix, rootNode: rootNode!.hiKid)
        } else {
            return searchForNodeMatchingPrefix(prefix[1..<charCount], rootNode: rootNode!.equalKid)
        }
    }
    
    private func findSuggestionsForNode(node: SuggestionNode?, inout suggestions: [WeightedString]) {
        if let n = node {
            if n.isWordEnd {
                suggestions.append(WeightedString(term: n.term, weight: n.weight))
            }
            
            findSuggestionsForNode(n.loKid, suggestions: &suggestions)
            findSuggestionsForNode(n.equalKid, suggestions: &suggestions)
            findSuggestionsForNode(n.hiKid, suggestions: &suggestions)
        }
    }
    
    private func deleteNode(inout node: SuggestionNode?) {
        if let n = node {
            deleteNode(&n.loKid)
            deleteNode(&n.equalKid)
            deleteNode(&n.hiKid)
            node = nil
        }
    }
    
    /**
        A SuggestionTrie node, representing a term.
    */
    private class SuggestionNode {
        
        // MARK: Properties

        let term: String
        var weight: Int
        var char: String {
            return term[term.characters.count - 1]
        }
        var isWordEnd: Bool
        
        var loKid: SuggestionNode?
        var equalKid: SuggestionNode?
        var hiKid: SuggestionNode?
        
        // MARK: Constructors
        
        init(term: String, isWordEnd: Bool, weight: Int) {
            self.term = term
            self.isWordEnd = isWordEnd
            self.weight = weight
        }
        
        convenience init(term: String, weight: Int) {
            self.init(term: term, isWordEnd: true, weight: weight)
        }
        
        convenience init(term: String) {
            self.init(term: term, isWordEnd: false, weight: 0)
        }
    }
}
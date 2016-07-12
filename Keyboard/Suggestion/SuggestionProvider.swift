//
//  SuggestionProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Kari Kraam on 2016-04-25.
//  Copyright (c) 2016 Kari Kraam. All rights reserved.
//

import Foundation

/**
    The SuggestionProvider protocol defines an interface for loading an array of weighted terms and providing autosuggest suggestions from those terms.
*/
protocol SuggestionProvider {
    /**
        Returns an array of autosuggest suggestions that begin with the prefix string provided.
    
        - parameter prefix: The prefix string that suggestions begin with.
    
        - returns: An array of autosuggest suggestions.
    */
    func suggestionsForPrefix(prefix: String) -> [String]
    
    /**
        Loads autosuggest terms.
    
        - parameter weightedStrings: An array of WeightedStrings representing autosuggest terms and their relative frequencies.
    */
    func loadWeightedStrings(weightedStrings: [WeightedString])
    
    /**
        Clears previously loaded autosuggest terms.
    */
    func clear()
}
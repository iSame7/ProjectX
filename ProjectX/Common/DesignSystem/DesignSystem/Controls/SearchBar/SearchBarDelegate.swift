//
//  SHSearchBarDelegate.swift
//  Components
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation

public protocol SearchBarDelegate: class {
    /**
     * Controls whether editing should begin or not. Return false to disallow editing.
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - returns: Whether or not to allow begin editing.
     */
    func searchBarShouldBeginEditing(_ searchBar: SearchBar) -> Bool
    
    /**
     * Informs the delegate that editing has begun. The searchbar has become first responder in that case.
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     */
    func searchBarDidBeginEditing(_ searchBar: SearchBar)
    
    /**
     * Controls whether editing should end or not.
     * Return true to allow editing to stop and to resign first responder status.
     * Return false to disallow the editing session to end
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - returns: Whether or not to allow end editing.
     */
    func searchBarShouldEndEditing(_ searchBar: SearchBar) -> Bool
    
    /**
     * Informs the delegate that editing has ended. The searchbar has resigned first responder in that case.
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     */
    func searchBarDidEndEditing(_ searchBar: SearchBar)
    
    /**
     * Controls whether the currently edited character or range of characters should be changed or not.
     * You can use this method to restrict entry of certain characters, e.g. for entering phone numbers.
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - parameter range: The range of the respective characters.
     * - parameter string: The string the characters in 'range' should be replaced with.
     * - returns: False when you don't want to change the characters. True when the change is ok.
     */
    func searchBar(_ searchBar: SearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    /**
     * Called when the clear button is pressed to delete all contents of the searchbar.
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - returns: False when you want to ignore the button press.
     */
    func searchBarShouldClear(_ searchBar: SearchBar) -> Bool
    
    /**
     * Called when the keyboards return button is pressed.
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - returns: False when you want to ignore the button press.
     */
    func searchBarShouldReturn(_ searchBar: SearchBar) -> Bool
    
    /**
     * Called when the text in the searchbar did change
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - parameter text: The new text after the change.
     */
    func searchBar(_ searchBar: SearchBar, textDidChange text: String)
    
    /**
     * Called when the close button in the search bar is tapped
     * - parameter searchBar: The searchbar for which the delegate call was issued.
     * - parameter text: The new text after the change.
     */
    func searchBarDidTapClearButton()
}

public extension SearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: SearchBar) -> Bool {
        true
    }
    
    func searchBarDidBeginEditing(_ searchBar: SearchBar) {}
    
    func searchBarShouldEndEditing(_ searchBar: SearchBar) -> Bool {
        true
    }
    
    func searchBarDidEndEditing(_ searchBar: SearchBar) {}
    
    func searchBar(_ searchBar: SearchBar,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        true
    }
    
    func searchBarShouldClear(_ searchBar: SearchBar) -> Bool {
        true
    }
    
    func searchBarShouldReturn(_ searchBar: SearchBar) -> Bool {
        searchBar.textField.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: SearchBar, textDidChange text: String) {}
    
    func searchBarDidTapClearButton() {} 
}

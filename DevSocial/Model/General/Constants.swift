//
//  Constants.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation

enum ChatCreationState {
	case new
	case existing 
}

enum PostType {
	case projectSearch
	case partnerSearch
}

enum ColorNames {
    static let mainColor          = "mainColor"
    static let primaryTextColor   = "primaryTextColor"
    static let secondaryTextColor = "secondaryTextColor"
}

enum Images {
    static let welcomeImage      	 = "WelcomeImage"
    static let messages          	 = "paperplane"
    static let emptyProfileImage 	 = "emptyProfileImage"
	static let myMessagesEmptyState  = "my_messages_empty_state"
	static let trashcan 			 = "trash"
	static let hiddenChatsEmptyState = "hidden_chats_empty_state"
    static let plus                  = "plus"
    static let magnifyingGlass       = "magnifyingglass"
    static let personPlus            = "person.badge.plus"
	static let xbutton    		     = "xmark.circle.fill"
	static let share     			 = "arrowshape.turn.up.right.fill"
}

enum TabImages {
    static let home     = "house"
    static let explore  = "house"
    static let activity = "house"
    static let profile  = "house"
}

enum Cells {
    static let defaultCell                = "defaultCellID"
    static let messageCell                = "messageCellID"
    static let messagedUserCell           = "messagedUserCellID"
    static let newMessageCell             = "newMessageCellID"
    static let userCell                   = "userCellID"
    static let postSearchCell             = "postSearchCellID"
    static let postRequestCell            = "postRequestCellID"
	static let textFieldCell              = "textFieldCellID"
	static let textViewCell               = "textViewCellID"
	static let embeddedCollectionViewCell = "embeddedCollectionViewCellID"
    static let capsuleCell                = "capsuleCellID"
}

enum SmileyImages {
    static let s_1_unselected = "smiley_1_unselected"
    static let s_1_selected   = "smiley_1_selected"
    static let s_2_unselected = "smiley_2_unselected"
    static let s_2_selected   = "smiley_2_selected"
    static let s_3_unselected = "smiley_3_unselected"
    static let s_3_selected   = "smiley_3_selected"
    static let s_4_unselected = "smiley_4_unselected"
    static let s_4_selected   = "smiley_4_selected"
    static let s_5_unselected = "smiley_5_unselected"
    static let s_5_selected   = "smiley_5_selected"
}

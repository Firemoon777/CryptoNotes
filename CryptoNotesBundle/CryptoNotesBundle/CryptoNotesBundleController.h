//
//  CryptoNotesBundleController.h
//  CryptoNotesBundle
//
//  Created by admin on 21.04.14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import <MessageUI/MessageUI.h>

@interface CryptoNotesBundleController : PSListController <MFMessageComposeViewControllerDelegate>
{
}

- (id)getValueForSpecifier:(PSSpecifier*)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
- (void)followOnTwitter:(PSSpecifier*)specifier;
- (void)visitWebSite:(PSSpecifier*)specifier;
- (void)makeDonation:(PSSpecifier*)specifier;
- (void)write:(PSSpecifier*)specifier;
-(void)checkLocale:(PSSpecifier*)specifier;

@end
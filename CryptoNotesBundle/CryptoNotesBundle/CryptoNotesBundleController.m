//
//  CryptoNotesBundleController.m
//  CryptoNotesBundle
//
//  Created by admin on 21.04.14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CryptoNotesBundleController.h"
#import <Preferences/PSSpecifier.h>

#define kSetting_Example_Name @"NameOfAnExampleSetting"
#define kSetting_Example_Value @"ValueOfAnExampleSetting"

#define kSetting_TemplateVersion_Name @"TemplateVersionExample"
#define kSetting_TemplateVersion_Value @"1.0"

#define kSetting_Text_Name @"TextExample"
#define kSetting_Text_Value @"Go Red Sox!"

#define kUrl_FollowOnTwitter @"https://twitter.com/Firemoon777/"
#define kUrl_VisitWebSite @"http://firemoon777.ru/"
#define kUrl_MakeDonation @"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B3AV9478WPWNC"

#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

@implementation CryptoNotesBundleController

- (id)getValueForSpecifier:(PSSpecifier*)specifier
{
	id value = nil;
	
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	
	// get 'value' with code only
	if ([specifierKey isEqual:kSetting_TemplateVersion_Name])
	{
		value = kSetting_TemplateVersion_Value;
	}
	else if ([specifierKey isEqual:kSetting_Example_Name])
	{
		value = kSetting_Example_Value;
	}
	// ...or get 'value' from 'defaults' plist or (optionally as a default value) with code
	else
	{
		// get 'value' from 'defaults' plist (if 'defaults' key and file exists)
		NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
		#if ! __has_feature(objc_arc)
		plistPath = [plistPath autorelease];
		#endif
		if (plistPath)
		{
			NSDictionary *dict = (NSDictionary*)[self initDictionaryWithFile:&plistPath asMutable:NO];
			
			id objectValue = [dict objectForKey:specifierKey];
			
			if (objectValue)
			{
				value = [NSString stringWithFormat:@"%@", objectValue];
				NSLog(@"read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
			}
			else
			{
				NSLog(@"key '%@' not found in plist '%@'", specifierKey, plistPath);
			}
			
			#if ! __has_feature(objc_arc)
			[dict release];
			#endif
		}
		
		// get default 'value' from code
		if (!value)
		{
			if ([specifierKey isEqual:kSetting_Text_Name])
			{
				value = kSetting_Text_Value;
			}
			else if ([specifierKey isEqual:kSetting_Example_Name])
			{
				value = kSetting_Example_Value;
			}
		}
	}
	
	return value;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
{
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	
	// use 'value' with code only
	if ([specifierKey isEqual:kSetting_Example_Name])
	{
		// do something here with 'value'...
	}
	// ...or save 'value' to 'defaults' plist and (optionally) with code
	else
	{
		// save 'value' to 'defaults' plist (if 'defaults' key exists)
		NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
		#if ! __has_feature(objc_arc)
		plistPath = [plistPath autorelease];
		#endif
		if (plistPath)
		{
			NSMutableDictionary *dict = (NSMutableDictionary*)[self initDictionaryWithFile:&plistPath asMutable:YES];
			[dict setObject:value forKey:specifierKey];
			[dict writeToFile:plistPath atomically:YES];
			#if ! __has_feature(objc_arc)
			[dict release];
			#endif

			NSLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
		}
		
		// use 'value' with code
		if ([specifierKey isEqual:kSetting_Example_Name])
		{
			// do something here with 'value'...
		}
	}
}

- (id)initDictionaryWithFile:(NSMutableString**)plistPath asMutable:(BOOL)asMutable
{
	if ([*plistPath hasPrefix:@"/"])
		*plistPath = [NSString stringWithFormat:@"%@.plist", *plistPath];
	else
		*plistPath = [NSString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
	
	Class class;
	if (asMutable)
		class = [NSMutableDictionary class];
	else
		class = [NSDictionary class];
	
	id dict;	
	if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath])
		dict = [[class alloc] initWithContentsOfFile:*plistPath];	
	else
		dict = [[class alloc] init];
	
	return dict;
}

- (void)followOnTwitter:(PSSpecifier*)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowOnTwitter]];
}

- (void)visitWebSite:(PSSpecifier*)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_VisitWebSite]];
}

- (void)makeDonation:(PSSpecifier *)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MakeDonation]];
}

-(void)write:(PSSpecifier *)specifier
{
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"firemoon@icloud.com"];
    
    MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
    mc.messageComposeDelegate = self;
    [mc setRecipients:toRecipents];
    [mc setBody:@"Thanks for CryptoNotes, Firemoon!\n"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void)checkLocale:(PSSpecifier*)specifier
{
    NSString *locale = [NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] objectAtIndex:0]];
    NSString *stringURL = [NSString stringWithFormat:@"http://firemoon777.ru/strings/CryptoNotesBundle-%@.strings", locale];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSString *dataString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    if(![dataString length])
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@.lproj not found on my server",locale]
                                                       message:[NSString stringWithFormat:@"Transaltion on your language is not availbale now."]
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"OK :(", nil];
        [view show];
        [view release];
        return;
    }
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if(![fileMgr fileExistsAtPath:[NSString stringWithFormat:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle/%@.lproj",locale] isDirectory:nil])
    {
        [fileMgr createDirectoryAtPath:[NSString stringWithFormat:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle/%@.lproj/",locale] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        [fileMgr removeItemAtPath:[NSString stringWithFormat:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle/%@.lproj/CryptoNotesBundle.strings",locale] error:nil];
    }
    [dataString writeToFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle/%@.lproj/CryptoNotesBundle.strings",locale] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@.lproj installed!", locale]
                                                   message:[NSString stringWithFormat:@"You need to restart Settings.app"]
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Close", nil];
    [view show];
    [view release];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (id)specifiers
{
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"CryptoNotesBundle" target:self];
		#if ! __has_feature(objc_arc)
		[_specifiers retain];
		#endif
	}
	
	return _specifiers;
}

- (id)init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	[super dealloc];
}
#endif

@end
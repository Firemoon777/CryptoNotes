#line 1 "/Users/firemoon777/Dropbox/Проекты/CryptoNotesOld/CryptoNotes/CryptoNotes.xm"




#import <UIKit/UIKit.h>
#import "NSString+AESCrypt.h"

@interface NoteContentLayer : UIView
@property(assign, nonatomic) BOOL containsCJK;
@property(readonly, assign) UITextView* textView;
-(id)contentAsPlainText:(BOOL)text;
-(void)setContent:(id)content isPlainText:(BOOL)text isCJK:(BOOL)cjk;
-(void)textViewDidChange:(id)textView;
@end

@interface NotesDisplayController : UINavigationController <UIAlertViewDelegate, UIActionSheetDelegate>
-(void)saveNote;
-(void)createNote;
-(void)setContentFromNote;
-(void)noteContentLayerContentDidChange:(id)noteContentLayerContent updatedTitle:(BOOL)title;
-(void)noteContentLayerContentDidChange:(id)noteContentLayerContent;

-(void)cryptoNote;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

#include <logos/logos.h>
#include <substrate.h>
@class NotesDisplayController; 
static void (*_logos_orig$_ungrouped$NotesDisplayController$loadView)(NotesDisplayController*, SEL); static void _logos_method$_ungrouped$NotesDisplayController$loadView(NotesDisplayController*, SEL); static void (*_logos_orig$_ungrouped$NotesDisplayController$actionSheet$clickedButtonAtIndex$)(NotesDisplayController*, SEL, UIActionSheet *, NSInteger); static void _logos_method$_ungrouped$NotesDisplayController$actionSheet$clickedButtonAtIndex$(NotesDisplayController*, SEL, UIActionSheet *, NSInteger); static void _logos_method$_ungrouped$NotesDisplayController$cryptoNote(NotesDisplayController*, SEL); static void _logos_method$_ungrouped$NotesDisplayController$alertView$clickedButtonAtIndex$(NotesDisplayController*, SEL, UIAlertView *, NSInteger); 

#line 27 "/Users/firemoon777/Dropbox/Проекты/CryptoNotesOld/CryptoNotes/CryptoNotes.xm"

NSDictionary *dict;
bool enabled;
bool autoSaveEnabled;

static void _logos_method$_ungrouped$NotesDisplayController$loadView(NotesDisplayController* self, SEL _cmd) {
    _logos_orig$_ungrouped$NotesDisplayController$loadView(self, _cmd);
    
    dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/ru.firemoon777.CryptoNotesBundle.plist"];
    enabled = [[dict objectForKey:@"enabled"] boolValue];
    autoSaveEnabled = [[dict objectForKey:@"autoSaveEnabled"] boolValue];
    if(!enabled)
        return;
    
    NSMutableArray *rightNavItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    if([rightNavItems count])
    {
        UIBarButtonItem *cryptoItem = [[UIBarButtonItem alloc] initWithTitle:@"Crypto"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(cryptoNote)];
        cryptoItem.
        [rightNavItems addObject:cryptoItem];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:rightNavItems];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"321"
                                                        message:[NSString stringWithFormat:@"%@", self.navigationItem.rightBarButtonItems]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIButton *cryptoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cryptoButton setTitle:@"Crypto" forState:UIControlStateNormal];
        [cryptoButton addTarget:self action:@selector(cryptoNote) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = cryptoButton;
    }
}

static void _logos_method$_ungrouped$NotesDisplayController$actionSheet$clickedButtonAtIndex$(NotesDisplayController* self, SEL _cmd, UIActionSheet * actionSheet, NSInteger buttonIndex) {
    if(actionSheet.tag == 777 && buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *passMsg = @"";
        if(buttonIndex == 0)
        {
            passMsg = NSLocalizedStringFromTableInBundle(@"Create password for encrypting." ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Create password for encrypting.");
        }
        if(buttonIndex == 1)
        {
            passMsg = NSLocalizedStringFromTableInBundle(@"Enter password, which used to encrypting." ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Enter password, which used to encrypting.");
            NoteContentLayer *contentLayer = MSHookIvar<NoteContentLayer*>(self, "_contentLayer");
            NSString *msg = [contentLayer contentAsPlainText:1];
            if([msg rangeOfString:@" "].location != NSNotFound)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Decrypt_warning_title" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Decrypt_warning_title")
                                                                message:NSLocalizedStringFromTableInBundle(@"Help_body" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Decrypt_warning_title")
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedStringFromTableInBundle(@"OK" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"OK"), nil];
                [alert show];
                [alert release];
                return;
            }
        }
        if(buttonIndex == 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Help_title" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Help_title")
                                                            message:NSLocalizedStringFromTableInBundle(@"Help_body" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Help_body")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedStringFromTableInBundle(@"OK" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"OK"), nil];
            [alert show];
            [alert release];
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Enter password:" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Enter password:")
                                                        message:passMsg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Cancel" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Cancel")
                                              otherButtonTitles:NSLocalizedStringFromTableInBundle(@"OK" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"OK"), nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alert.tag = buttonIndex+100;
        [alert show];
        [alert release];
    }
    _logos_orig$_ungrouped$NotesDisplayController$actionSheet$clickedButtonAtIndex$(self, _cmd, actionSheet, buttonIndex);
}


static void _logos_method$_ungrouped$NotesDisplayController$cryptoNote(NotesDisplayController* self, SEL _cmd) {
    
    
    
    UIActionSheet *chose = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"I want to..." ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"I want to...")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Cancel" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Cancel")
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:
                            NSLocalizedStringFromTableInBundle(@"Encrypt" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Encrypt"),
                            NSLocalizedStringFromTableInBundle(@"Decrypt" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Decrypt"),
                            NSLocalizedStringFromTableInBundle(@"Help" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Help"),nil];
    chose.tag = 777;
    if(self.navigationItem.rightBarButtonItems.count)
    {
        [chose showFromBarButtonItem:[self.navigationItem.rightBarButtonItems lastObject] animated:YES];
    }
    else
    {
        [chose showInView:self.view];
    }
}


static void _logos_method$_ungrouped$NotesDisplayController$alertView$clickedButtonAtIndex$(NotesDisplayController* self, SEL _cmd, UIAlertView * alertView, NSInteger buttonIndex) {
    if(alertView.tag / 10 == 10 && alertView.cancelButtonIndex != buttonIndex)
    {
        NoteContentLayer *contentLayer = MSHookIvar<NoteContentLayer*>(self, "_contentLayer");
        NSString *msg = [contentLayer contentAsPlainText:1];
        NSString *pass = [alertView textFieldAtIndex:0].text;
        NSString *cryptoMsg;
        if(alertView.tag == 100)
        {
            cryptoMsg = [msg AES256EncryptWithKey:pass];
        }
        if(alertView.tag == 101)
        {
            cryptoMsg = [msg AES256DecryptWithKey:pass];
        }
        [contentLayer setContent:cryptoMsg isPlainText:1 isCJK:contentLayer.containsCJK];
        if([self respondsToSelector:@selector(noteContentLayerContentDidChange:)])
        {
            [self noteContentLayerContentDidChange:contentLayer];
        }
        else
        {
            [self noteContentLayerContentDidChange:contentLayer updatedTitle:1];
        }
        
        if(autoSaveEnabled)
            [self saveNote];
        






    }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NotesDisplayController = objc_getClass("NotesDisplayController"); MSHookMessageEx(_logos_class$_ungrouped$NotesDisplayController, @selector(loadView), (IMP)&_logos_method$_ungrouped$NotesDisplayController$loadView, (IMP*)&_logos_orig$_ungrouped$NotesDisplayController$loadView);MSHookMessageEx(_logos_class$_ungrouped$NotesDisplayController, @selector(actionSheet:clickedButtonAtIndex:), (IMP)&_logos_method$_ungrouped$NotesDisplayController$actionSheet$clickedButtonAtIndex$, (IMP*)&_logos_orig$_ungrouped$NotesDisplayController$actionSheet$clickedButtonAtIndex$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NotesDisplayController, @selector(cryptoNote), (IMP)&_logos_method$_ungrouped$NotesDisplayController$cryptoNote, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIAlertView *), strlen(@encode(UIAlertView *))); i += strlen(@encode(UIAlertView *)); memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NotesDisplayController, @selector(alertView:clickedButtonAtIndex:), (IMP)&_logos_method$_ungrouped$NotesDisplayController$alertView$clickedButtonAtIndex$, _typeEncoding); }} }
#line 178 "/Users/firemoon777/Dropbox/Проекты/CryptoNotesOld/CryptoNotes/CryptoNotes.xm"

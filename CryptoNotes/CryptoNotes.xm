
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

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

%hook NotesDisplayController
NSDictionary *dict;
bool enabled;
bool autoSaveEnabled;
-(void)loadView
{
    %orig;
    
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    %orig;
}
%new
-(void)cryptoNote
{
    // FIXME:
    // Crypto button doesn't work in first time on iPad
    
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
%new
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        //
        if(autoSaveEnabled)
            [self saveNote];
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Success" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Success")
                                                        message:NSLocalizedStringFromTableInBundle(@"Success_body" ,@"CryptoNotesBundle",[NSBundle bundleWithPath:@"/Library/PreferenceBundles/CryptoNotesBundle.bundle"], @"Success_body")
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];*/
    }
}
%end
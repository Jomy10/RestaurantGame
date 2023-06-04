//
//  keyboardLayout-mac.m
//
//  With the help of the open source community:
//  https://github.com/atom/keyboard-layout/blob/29fe997f608fc2c5904dcf1c2651bb6d990daf4e/src/keyboard-layout-manager-mac.mm#L121
//
//  Created by Jonas Everaert on 04/06/2023.
//

#import <Carbon/Carbon.h>

/// Returns the keyboard's language (e.g. "en", "nl")
const char* mac_getKBLang(void) {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    NSArray* langs = (__bridge NSArray*) TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages);
    NSString* lang = (NSString*) [langs objectAtIndex:0];
    return [lang UTF8String];
}

/// Returns the current keyboard layout (e.g. com.apple.keylayout)
/// All keyboard layouts can be retrieved, see:
///     https://github.com/minoki/InputSourceSelector/blob/7f655017d16ad9f345d36ccaeec11e0a607cb6a1/InputSourceSelector.m#L11-L17
const char* mac_getKBLayout(void) {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    CFStringRef sourceId = (CFStringRef) TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
    return [(__bridge NSString*)sourceId UTF8String];
}

/// Returns the localized name of the keyboard layout
/// e.g. Czech, Belgian, Czech - QWERTY
const char* mac_getKBLocalizedName(void) {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    CFStringRef localizedName = (CFStringRef) TISGetInputSourceProperty(source, kTISPropertyLocalizedName);
    return [(__bridge NSString*)localizedName UTF8String];
}

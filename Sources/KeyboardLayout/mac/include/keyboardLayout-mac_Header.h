//
//  keyboardLayout-mac_Header.h
//  
//
//  Created by Jonas Everaert on 04/06/2023.
//

#ifndef H_KEYBOARDLAYOUT_MAC
#define H_KEYBOARDLAYOUT_MAC

/// Returns the keyboard's language (e.g. "en", "nl")
const char* mac_getKBLang(void);

/// Returns the current keyboard layout (e.g. com.apple.keylayout)
/// All keyboard layouts can be retrieved, see:
///     https://github.com/minoki/InputSourceSelector/blob/7f655017d16ad9f345d36ccaeec11e0a607cb6a1/InputSourceSelector.m#L11-L17
const char* mac_getKBLayout(void);

/// Returns the localized name of the keyboard layout
/// e.g. Czech, Belgian, Czech - QWERTY
const char* mac_getKBLocalizedName(void);

#endif /* H_KEYBOARDLAYOUT_MAC */

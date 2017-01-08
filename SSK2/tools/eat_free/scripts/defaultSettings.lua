-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local defaultSettings = {}

function defaultSettings.get()
	local settings = {}

	settings.deviceResolution 					= "iPhone 5" 
	settings.commonResolution 					= "640 x 960"
	settings.resolution_width 					= "640"
	settings.resolution_height 					= "960"
	settings.smartpixel_ideal_width 			= "320"
	settings.smartpixel_ideal_height 			= "480"
	settings.scaling 							= "letterbox"
	settings.x_align 							= "center"
	settings.y_align 							= "center"
	settings.orientation 						= "Portrait"
	settings.allow_flipping 					= "false"
	settings.resolution_selection_method 		= "Device List"

	settings.dyanamic_image_scaling_en			= "false"
	settings.image_scaling_2x					= "1.5"
	settings.image_scaling_3x					= "2"
	settings.image_scaling_4x					= "3"

	settings.generate_android					= "true"
	settings.generate_ios						= "true"
	settings.generate_apple_tv					= "false"
	settings.generate_desktop_osx				= "false"
	settings.generate_desktop_win32				= "false"
	settings.generate_chromebook				= "false"

	settings.provide_icons						= "no"
	settings.provide_launch_images				= "no"

	
	settings.desktop_default_mode				= "normal"
	settings.desktop_resizable					= "true" 
	settings.desktop_default_width 				= "540"
	settings.desktop_default_height 			= "960"
	settings.desktop_min_width 					= "540"
	settings.desktop_min_height 				= "960"
	settings.desktop_enable_close_button  		= "true"
	settings.desktop_enable_minimize_button 	= "true"
	settings.desktop_enable_maximize_button 	= "true"
	settings.desktop_suspend_when_minimized 	= "true"
	settings.desktop_show_window_title 			= "false"
	settings.desktop_title_text					= ""

	settings.frame_rate 						= "60"
	settings.shader_precision 					= "auto"
	settings.show_runtime_errors  				= "auto"
	settings.never_strip_debug_info 			= "false"
	settings.composer_is_debug 					= "false"
	settings.composer_recycle_on_low_memory 	= "true"
	settings.composer_recycle_on_scene_change	= "false"

	settings.exclude_all						= "*secret.txt,*.pdf"
	settings.exclude_android					= "Icon.png,*@2x.png,music/*.m4a"
	settings.exclude_ios						= "Icon-*dpi.png,music/*.ogg"
	settings.exclude_tvos						= "Icon-*dpi.png,music/*.ogg"
	settings.exclude_osx						= "Default*.png,Icon*.png,Icon*.ico,Icon*.icns"
	settings.exclude_win						= "Default*.png,Icon*.png,Icon*.ico,Icon*.icns"

	settings.android_version_code 				= ""
	settings.android_min_sdk 					= "14"
	settings.android_large_heap 				= "true"
	settings.android_uses_expansion_files 		= "false"
	settings.android_supports_tv 				= "false"
	settings.android_is_game 					= "true"
	settings.android_readonly_file_access 		= "true"
	settings.android_supports_small_screens 	= "auto"
	settings.android_supports_normal_screens	= "auto"
	settings.android_supports_large_screens 	= "auto"
	settings.android_supports_xlarge_screens	= "auto"

	settings.ios_bundle_display_name 			= ""
	settings.ios_bundle_name 					= ""
	settings.ios_min_version 					= "6.0"
	settings.ios_exit_on_suspend 				= "false"
	settings.ios_icon_is_prerendered 			= "true"
	settings.ios_hide_status_bar 				= "true"
	settings.ios_skip_png_crush 				= "false"


	return settings
end

function defaultSettings.getHelp( settingName )
	local help = {}

	help.deviceResolution =
	{
		description 	= "Choose from a list of common device types." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.commonResolution =
	{
		description 	= "Choose from a list of common device resolutions." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.resolution_width =
	{
		description 	= "Type in the exact width you want to design to." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}

	help.resolution_height =
	{
		description 	= "Type in the exact height you want to design to." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}

	help.smartpixel_ideal_width =
	{
		description 	= "When using 'Smart Pixel' to configure content resolution, the algorithm needs a starting resolution to work from.\n\n" ..
		"Tip: 320 x 480 is the 'fundamental' resolution many old-school developers use, but another great resolution is 640 x 960.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.smartpixel_ideal_height =
	{
		description 	= "When using 'Smart Pixel' to configure content resolution, the algorithm needs a starting resolution to work from.\n\n" ..
		"Tip: 320 x 480 is the 'fundamental' resolution many old-school developers use, but another great resolution is 640 x 960.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.scaling =
	{
		description 	= "This option selects how Corona will scale your game to fit devices that don't match the design resolution.\n\n" ..
		" * adaptive - Advanced scaling technique.  For more info click 'Corona Docs'\n\n" .. 
		" * letterbox - Preserves aspect ratio while ensuring all content is visible.  This is the #1 most selected scaling option.  For more info click 'Corona Docs'\n\n" .. 
		" * none - No scaling applied.  For more info click 'Corona Docs'\n\n" .. 
		" * zoomEven - Tries to fill screen, but maintains aspect ratio, so some content may be hidden.  For more info click 'Corona Docs'\n\n" .. 
		" * zoomStretch - Stretches to fit screen.  This can be ugly, but it is the easiest scaling to understand and use.  For more info click 'Corona Docs'\n\n",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#scale",
	}	

	help.x_align =
	{
		description 	= "This option allows you to align the content area to specific position or edge of the screen.\n\n" ..
		"This is an advanced feature and it is suggested you leave this at the default setting.\n\n" ..
		"To learn more, click 'Corona Docs'",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#xalign-yalign",
	}

	help.y_align =
	{
		description 	= "This option allows you to align the content area to specific position or edge of the screen.\n\n" ..
		"This is an advanced feature and it is suggested you leave this at the default setting.\n\n" ..
		"To learn more, click 'Corona Docs'",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#xalign-yalign",
	}	

	help.orientation =
	{
		description 	= "Please choose 'Portrait' -OR- 'Landscape' for your game orientation.\n\nTip: While Corona support auto-oriented apps (portrait & landscape), games rarely do this.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#app-orientation",
	} 

	help.allow_flipping =
	{
		description 	= "If you set this to true, the game will support both normal orientation and the upside-down version.\n\n" ..
		"Tip: This may seem 'cool' at first, but can cause a bad user experience.\n\nIf you set this to 'true' the screen may flip unexpectedly and if users try to play 'upside-down', physical buttons on the device may be in the way.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#auto-orientation",
	}	

	help.resolution_selection_method =
	{
		description 	= "Configure content resolution using: \n\n" ..
		" * Smart Pixel - An advanced (pixel-pefect) technique designed by Sergey Lerg.  Click 'More Info' below.\n\n" ..
		" * Device List - Choose from a list of common devices.\n\n" .. 
		" * Common Resolutions - Choose from a list of common resolutions.\n\n" .. 
		" * User Defined - Specify your own explicit resolution.\n\n" ..
		"Tip: If you are a very new developer, leave this alone for now.  The default settings 'Smart Pixel' will be good enough for most game designs.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "http://spiralcodestudio.com/corona-sdk-pro-tip-of-the-day-36/",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#content-scaling",
	}
	

	help.dyanamic_image_scaling_en =
	{
		description 	= "Corona has the ability to automatically select alternate versions of images for higher resolution screens.  To do this,  you must supply the images and enable the feature.\n\n" ..
		"Tip: If you are new, I suggest you wait to start using this feature.  It is easy to over do it.  I personally, start with a middle of the road resolution like the iPhone 5.  " ..
		"Then, if I determine that some images don't look sharp enough at high-resolution, I use this feature and selectively supply images for those that don't look good.  This keeps the total app size resonable.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#dynamic-image-selection",
	}	

	help.image_scaling_2x =
	{
		description 	= "Use @2X images if the screen size is this many times larger than the scale you chose as your content scale (design resolution)." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/#dynamic-image-selection",
	}	

	help.image_scaling_3x =
	{
		description 	= "Use @3X images if the screen size is this many times larger than the scale you chose as your content scale (design resolution)." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/#dynamic-image-selection",
	}	

	help.image_scaling_4x =
	{
		description 	= "Use @4X images if the screen size is this many times larger than the scale you chose as your content scale (design resolution)." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/#dynamic-image-selection",
	}	


	help.generate_android =
	{
		description 	= "Set this option to 'true' if you indend to deploy your app/game for any of these targets:\n\n" ..
		" * Android Mobile Devices\n" ..
		" * Android TV Devices\n" ..
		" * Android Consoles (like OUYA)\n" ..
		" * Chromebooks\n" ..
		" * ... any other devices running Android.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.generate_ios =
	{
		description 	= "Set this option to 'true' if you indend to deploy your app/game for any of these targets:\n\n" ..
		" * iPhones\n" ..
		" * iPads",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.generate_apple_tv =
	{
		description 	= "Set this option to 'true' if you indend to deploy your app/game to the Apple TV store.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.generate_desktop_osx =
	{
		description 	= "Set this option to 'true' if you indend to deploy your app/game to OS X desktop.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.generate_desktop_win32 =
	{
		description 	= "Set this option to 'true' if you indend to deploy your app/game to Windows 7/8/10 desktop.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.generate_chromebook =
	{
		description 	= "Set this option to 'true' if you intend to deploy your app/game to Chromebook.\n\n" ..
		"Tip: This is an experimental setting.  I have not yet deployed and tested any apps on a Chromebook, so they way EAT supports this may change in the future.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	


	help.provide_icons =
	{
		description 	= "By default EAT ONLY generates code.  However, some folks find it useful to have 'starter' icons too.\n\n" ..
		"If you want starter icons for your app/game, set this option to 'true'." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	

	help.provide_launch_images =
	{
		description 	= "By default EAT ONLY generates code.  However, some folks find it useful to have 'starter' launch images (for iOS) too.\n\n" ..
		"If you want starter launch images for your app/game, set this option to 'true'." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "",
	}	


	help.desktop_default_mode =
	{
		description 	= "Sets how the app window should be launched on startup." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#defaultmode",
	}	

	help.desktop_resizable =
	{
		description 	= "If set to 'true', the user is allowed to resize the app window." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#resizable",
	}	

	help.desktop_default_width =
	{
		description 	= "Select the initial starting width and height of the app on first launch.  This size may be different for future launches if the user previously resized the window." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#defaultviewwidth",
	}	

	help.desktop_default_height =
	{
		description 	= "Select the initial starting width and height of the app on first launch.  This size may be different for future launches if the user previously resized the window." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#defaultviewwidth",
	}	

	help.desktop_min_width =
	{
		description 	= "Select the minimum width and height of the app and limits resizing below this resolution." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#minviewwidth",
	}	

	help.desktop_min_height =
	{
		description 	= "Select the minimum width and height of the app and limits resizing below this resolution." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#minviewwidth",
	}	

	help.desktop_enable_close_button =
	{
		description 	= "If set to 'true', a close button is supplied and the user is allowed to close the app." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#enableclosebutton",
	}	

	help.desktop_enable_minimize_button =
	{
		description 	= "If set to 'true', a minimize button is supplied and the user is allowed to minimize the app." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#enableminimizebutton",
	}	

	help.desktop_enable_maximize_button =
	{
		description 	= "If set to 'true', a maximize button is supplied and the user is allowed to maximize the app." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#enablemaximizebutton",
	}	

	help.desktop_suspend_when_minimized =
	{
		description 	= "If set to 'true', The app will sleep/suspend when minimized.  This is how mobile Corona apps behave, so set this to 'true' maintain the same experience for desktop conversions." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#suspendwhenminimized",
	}	

	help.desktop_show_window_title =
	{
		description 	= "Set this to 'true' to have Corona display a title on the top-bar when in windowed mode." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#showwindowtitle",
	}	

	help.desktop_title_text =
	{
		description 	= "This is the default title for all versions of the app.  You can override this for specific languages by supplying an alternative title for that language." ,
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html#showwindowtitle",
	}	

	help.frame_rate =
	{
		description 	= "Choose your desired frame rate.\n\n" ..
		"To learn more, click 'Corona Docs'",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#frame-rate-fps",
	}

	help.shader_precision =
	{
		description 	= "Choose a value other than 'auto' if you want to override the default shader precision for all OpenGL ES shaders (on device).\n\n" ..
		"To learn more, click 'Corona Docs'",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#shader-precision",
	}

	help.show_runtime_errors =
	{
		description 	= "This rarely used option allows you to turn off error pop-ups in the simulator.  Beginners should leave this set to 'auto' or 'true'.\n\n" ..
		"To learn more, click 'Corona Docs'",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html#frame-rate-fps",
	}

	help.never_strip_debug_info =
	{
		description 	= "By default, debug symbols are stripped for device builds.  This makes the binary smaller and faster.\n\n" ..
		"However, if you are having trouble debugging on device, you may want to turn symbols back on to get more information from error messages in the log.\n\n" ..
		"Just remember to turn this off again (set to 'true') when you build for production/release.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#build-control",
	}

	help.composer_is_debug =
	{
		description 	= "If set to 'true', prints useful debugging information to the Corona Simulator Console in certain situations. This should be set to false (default) before building the project for deployment.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/api/library/composer/isDebug.html",
	}

	help.composer_recycle_on_low_memory =
	{
		description 	= "If the OS issues a low memory warning, Composer will automatically recycle (destroy) the least recently used scene to free up memory.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/api/library/composer/recycleOnLowMemory.html",
	}

	help.composer_recycle_on_scene_change =
	{
		description 	= "By default, when changing scenes, Composer keeps the current scene's view (self.view) in memory, which can improve performance if you access the same scenes frequently.\n\nIf you set composer.recycleOnSceneChange to 'true', the scene's self.view display group will be removed, but its scene object will remain in memory.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/api/library/composer/recycleOnSceneChange.html",
	}	

	help.exclude_all =
	{
		description 	= "Exclude these files from all builds.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/#excluding-files",
	}	

	help.exclude_android =
	{
		description 	= "Exclude these files from Android builds.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/#excluding-files",
	}	

	help.exclude_ios =
	{
		description 	= "Exclude these files from iOS builds.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/#excluding-files",
	}	

	help.exclude_tvos =
	{
		description 	= "Exclude these files from TV OS builds.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/#excluding-files",
	}	

	help.exclude_osx =
	{
		description 	= "Exclude these files from OS X desktop builds.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/#excluding-files",
	}	

	help.exclude_win =
	{
		description 	= "Exclude these files from Win32 desktop builds.",
		video 			= "",
		webpage 		= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/#excluding-files",
	}	

	help.android_version_code =
	{
		description 	= "Manually override the version code chose through the build dialog.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#version-code",
	}

	help.android_min_sdk =
	{
		description 	= "This allows you to keep the app from being installed on devices with older versions of Android",
		video 			= "",
		webpage 		= "http://developer.android.com/guide/topics/manifest/uses-sdk-element.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#minimum-sdk-version",
	}

	help.android_large_heap =
	{
		description 	= "Asks the Android OS to give you more heap memory if it can.",
		video 			= "",
		webpage			= "https://developer.android.com/training/articles/memory.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#large-heap",
	}

	help.android_uses_expansion_files =
	{
		description 	= "Indicates app should be built with expansion files.\n\n" ..
		"This feature is not fully implemented by EAT yet.  Thanks for your patience.\n\n" ..
		"- The Roaming Gamer" ,
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#expansion-files",
	}

	help.android_supports_tv =
	{
		description 	= "This is an Android TV specific setting.  It tells Google Play that this app works on Android TV devices." ,
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#android-tv",
	}

	help.android_is_game =
	{
		description 	= "This is an Android TV specific setting.  It tells Google Play to categorize this as a game and list it in the games section of the on-screen store.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#android-tv",
	}

	help.android_readonly_file_access =
	{
		description 	= "This allows you to block write-access (by external apps) to the private documents folder.  Your app can still read and write it, but to external apps it will be treated as read-only.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#disabling-file-access",
	}

	help.android_supports_small_screens =
	{
		description 	= "This allows you to explicitily specify or limit whether your game supports 'small' screens.\n\nUnless you want to specifically block a screen size, you should leave this as 'auto' or 'true'.",
		video 			= "",
		webpage 		= "http://developer.android.com/guide/topics/manifest/supports-screens-element.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#screen-support",
	}

	help.android_supports_normal_screens =
	{
		description 	= "This allows you to explicitily specify or limit whether your game supports 'normal' screens.\n\nUnless you want to specifically block a screen size, you should leave this as 'auto' or 'true'.",
		video 			= "",
		webpage 		= "http://developer.android.com/guide/topics/manifest/supports-screens-element.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#screen-support",
	}

	help.android_supports_large_screens =
	{
		description 	= "This allows you to explicitily specify or limit whether your game supports 'large' screens.\n\nUnless you want to specifically block a screen size, you should leave this as 'auto' or 'true'.",
		video 			= "",
		webpage 		= "http://developer.android.com/guide/topics/manifest/supports-screens-element.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#screen-support",
	}

	help.android_supports_xlarge_screens =
	{
		description 	= "This allows you to explicitily specify or limit whether your game supports 'extra large' screens.\n\nUnless you want to specifically block a screen size, you should leave this as 'auto' or 'true'.",
		video 			= "",
		webpage 		= "http://developer.android.com/guide/topics/manifest/supports-screens-element.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#screen-support",
	}	

	help.ios_bundle_display_name =
	{
		description 	= "This allows you to specify the display name of your game.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#ios-build-settings",
	}

	help.ios_bundle_name =
	{
		description 	= "This allows you to specify the short app name of your game (16 characters or fewer).",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#ios-build-settings",
	}

	help.ios_min_version =
	{
		description 	= "If you wish to limit your app to a specific iOS version or higher, set this value.  Otherwise leave it blank.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#ios-build-settings",
	}

	help.ios_exit_on_suspend = 
	{
		description 	= "If this is set to 'true', suspending your game on an iPhone/iPad will also exit the game.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#ios-build-settings",
	}

	help.ios_icon_is_prerendered =
	{
		description 	= "If this is set to 'true', it tells Apple not to apply any visual changes to your icon.\n\nIf this is set to 'false', Apple will apply the icon effect dujour (typicaly a shine effect).\n\n" ..
		"Tip: I suggest you leave this set to 'false' and design your icon to fit the current style prefered by Apple.\n\n" ..
		"- The Roaming Gamer",
		video 			= "",
		webpage 		= "https://developer.apple.com/library/ios/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AppIconType.html",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#ios-build-settings",
	}

	help.ios_hide_status_bar =
	{
		description 	= "When set to 'true', this tells iOS to hide the status bar during the launch.",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#ios-build-settings",
	}

	help.ios_skip_png_crush =
	{
		description 	= "If you need to skip the PNG processing step for iOS apps, set this to 'true'.\n\n" ..
		"Tip: Experts (using advanced PNG encoders) may find that the PNG Crush step actually inflates or corrupts their PNGs.  Turning this off will fix the issue.\n" ..
		"If you don't know what this is, leave it set to 'false'.\n\n" .. 
		"- The Roaming Gamer",
		video 			= "",
		coronadocs 		= "https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html#png-processing",
	}
		

	return help[settingName]
end


return defaultSettings
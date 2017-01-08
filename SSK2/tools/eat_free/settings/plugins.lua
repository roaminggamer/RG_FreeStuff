-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local plugins = {}
local settings = {}

settings.plugins_list = 
{
	{ 	name = "Ads / Monetization", 
	    choices =  	    
		{ 
			--{ name = "TBD",							id = "tbd_plugin" }, --NEW
			{ name = "Unity Ads",					id = "unityads_plugin" }, --NEW
			{ name = "Store Kit",					id = "storekit_plugin" }, --NEW
			{ name = "Kiip",							id = "kiip_plugin" }, --NEW
			{ name = "Store View",					id = "storeview_plugin" }, --NEW
			{ name = "Razer Store",					id = "razerstore_plugin" }, --NEW


			{ name = "Amazon IAP", 					id = "iap_amazon_plugin" },
			{ name = "Fortumo", 					id = "iap_fortumo_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "iap_fortumo_service_id", "Fortumo Service ID" },
			  			{ "iap_fortumo_app_secret", "Fortumo Service ID" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Google IAP", 					id = "iap_google_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "iap_google_key", "Google Key" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "IAP Badger", 					id = "iap_badger_plugin",
				config = 
			  	{
			  		all = 
			  		{
			  			{ "iap_badger_salt", "Salt" },
			  			{ "iap_badger_filename", "File Name" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			
			{ name = "Advertising ID", 			id = "util_advertising_id_plugin" },
			{ name = "AdBuddiz", 					id = "monetization_adbuddiz_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_adbuddiz_publisher_key", "AdBuddiz Publisher Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_adbuddiz_publisher_key", "AdBuddiz Publisher Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{			  		
			  	},
			},
			{ name = "AdColony ", 					id = "monetization_adcolony_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_adcolony_api_key", "AdColony API Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_adcolony_api_key", "AdColony API Key [iOS]" },
			  		},
			  	},
				conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "AdMob", 						id = "monetization_admob_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_admob_banner_app_id", "AdMob Banner App ID [Android]" },
			  			{ "ads_android_admob_interstitial_app_id", "AdMob Interstitial App ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_admob_banner_app_id", "AdMob Banner App ID [iOS]" },
			  			{ "ads_ios_admob_interstitial_app_id", "AdMob Interstitial App ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "AppLovin", 					id = "monetization_applovin_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_applovin_sdk_key", "AppLovin SDK Key [Android]" },
			  		},
			  		apple_tv = 
			  		{
			  			{ "ads_apple_tv_applovin_sdk_key", "AppLovin SDK Key [Apple TV]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_applovin_sdk_key", "AppLovin SDK Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Appnext", 					id = "monetization_appnext_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_appnext_placement_id", "Appnext Placement ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_appnext_placement_id", "Appnext Placement ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Appodeal", 					id = "monetization_appodeal_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_appodeal_app_key", "Appodeal App Key [Android]" },
			  		},
			  		apple_tv = 
			  		{
			  			{ "ads_apple_tv_appodeal_app_key", "Appodeal App Key [Apple TV]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_appodeal_app_key", "Appodeal App Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "ChartBoost", 					id = "monetization_chartboost_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_chartboost_api_key", "ChartBoost API Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_chartboost_api_key", "ChartBoost API Key [iOS]" },
			  		},
			  	},
				conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Corona Ads", 					id = "monetization_corona_ads_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_corona_ads_placement_id", "Corona Ads Placement ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_corona_ads_placement_id", "Corona Ads Placement ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Facebook Audience Network", 	id = "monetization_fan_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_fan_placement_id", "FAN Placment ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_fan_placement_id", "FAN Placment ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "inMobi", 						id = "monetization_inmobi_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_inmobi_banner_id", "inMobi Banner ID [Android]" },
			  			{ "ads_android_inmobi_interstitial_id", "inMobi Intersitial ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_inmobi_banner_id", "inMobi Banner ID [iOS]" },
			  			{ "ads_ios_inmobi_interstitial_id", "inMobi Intersitial ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "KIDOZ", 						id = "monetization_kidoz_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_kidoz_publisher_id", "Kidoz Publisher ID [Android]" },
			  			{ "ads_android_kidoz_security_token", "Kiddoz Security Token [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_kidoz_publisher_id", "Kidoz Publisher ID [iOS]" },
			  			{ "ads_ios_kidoz_security_token", "Kiddoz Security Token [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Media Brix",					id = "monetization_mediabrix_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_mediabrix_app_id", "MediaBrix App ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_mediabrix_app_id", "MediaBrix App ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Peanut Labs", 				id = "monetization_peanuts_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_peanutlabs_user_id", "Peanut Labs User ID [Android]" },
			  			{ "ads_android_peanutlabs_app_key", "Peanut Labs App Key [Android]" },
			  			{ "ads_android_peanutlabs_app_id", "Peanut Labs App ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_peanutlabs_user_id", "Peanut Labs User ID [iOS]" },
			  			{ "ads_ios_peanutlabs_app_key", "Peanut Labs App Key [iOS]" },
			  			{ "ads_ios_peanutlabs_app_id", "Peanut Labs App ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Persona.ly", 					id = "monetization_personaly_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_personaly_app_hash", "Persona.ly App Hash [Android]" },
			  			{ "ads_android_personaly_user_id", "Persona.ly User ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_personaly_app_hash", "Persona.ly App Hash [iOS]" },
			  			{ "ads_ios_personaly_user_id", "Persona.ly User ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Poll Fish", 					id = "monetization_pollfish_plugin",			
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_pollfish_api_key", "Pollfish API Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_pollfish_api_key", "Pollfish API Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_admob_plugin"] = "AdMob",
			  		["monetization_adcolony_plugin"] = "AdColony",
			  		["monetization_applovin_plugin"] = "AppLovin",
			  		["monetization_appnext_plugin"] = "Appnext",
			  		["monetization_appodeal_plugin"] = "Appodeal",
			  		["monetization_chartboost_plugin"] = "ChartBoost",
			  		["monetization_corona_ads_plugin"] = "Corona Ads",
			  		["monetization_admob_plugin"] = "AdMob",
			  		["monetization_fan_plugin"] = "Facebook Audience Network",
			  		["monetization_inmobi_plugin"] = "inMobi",
			  		["monetization_kidoz_plugin"] = "KIDOZ",
			  		["monetization_mediabrix_plugin"] = "Media Brix",
			  		["monetization_peanuts_plugin"] = "Peanut Labs",
			  		["monetization_personaly_plugin"] = "Persona.ly",
			  		["monetization_revmob_plugin"] = "RevMob",
			  		["monetization_supersonic_plugin"] = "Supersonic / ironSource",
			  		["monetization_superawesome_plugin"] = "SuperAwesome",
			  		["monetization_trial_pay_plugin"] = "Trial Pay",
			  		["monetization_vungle_plugin"] = "Vungle",
			  	},
			},
			{ name = "RevMob", 						id = "monetization_revmob_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_revmob_app_id", "RevMob App ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_revmob_app_id", "RevMob App ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "SuperAwesome", 				id = "monetization_superawesome_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_superawesome_placement_id", "SuperAwesome Placement ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_superawesome_placement_id", "SuperAwesome Placement ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Supersonic", 					id = "monetization_supersonic_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_supersonic_app_key", "Supersonic App Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_supersonic_app_key", "Supersonic App Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Trial Pay", 					id = "monetization_trial_pay_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_trial_pay_app_key", "Trial Pay App Key [Android]" },
			  			{ "ads_android_trial_pay_sid", "ial Pay SID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_trial_pay_app_key", "Trial Pay App Key [iOS]" },
			  			{ "ads_ios_trial_pay_sid", "Trial Pay SID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
			{ name = "Vungle", 						id = "monetization_vungle_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_vungle_app_key", "Vungle App Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_vungle_app_key", "Vungle App Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{			  		
			  		["monetization_pollfish_plugin"] = "Pollfish",
			  	},
			},
		}
	}, 


	{ 	name = "Analytics / Attribution", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "Facebook Analytics",			id = "facebookanalytics_plugin" }, --NEW
			{ name = "Tune",								id = "tune_plugin" }, --NEW
			{ name = "Kochava Free App Analytics",	id = "kochava_faa_plugin" }, --NEW
			{ name = "Kochava", 							id = "kochava_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "attribution_kochava_android_app_id", "Kochava App ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "attribution_kochava_ios_app_id", "Kochava App ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Game Analytics",					id = "ga_plugin" }, --NEW
			{ name = "Tenjin",							id = "tenjin_plugin" }, --NEW
			{ name = "HockeyApp", 						id = "hockeyapp_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "utilities_android_hockeyapp_app_id", "Hockey App ID  [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "utilities_ios_hockeyapp_app_id", "Hockey App ID  [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Flurry (legacy)", 					id = "flurry_plugin_legacy",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "analytics_android_flurry_legacy_api_key", "Flurry (legacy) Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "analytics_ios_flurry_legacy_api_key", "Flurry (legacy) Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Flurry", 									id = "flurry_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "analytics_android_flurry_api_key", "Flurry Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "analytics_ios_flurry_api_key", "Flurry Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Google Analytics", 						id = "google_analytics_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "analytics_android_google_app_name", "Google Analytics App Name [Android]" },
			  			{ "analytics_android_google_tracking_id", "Google Analytics Tracking ID [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "analytics_ios_google_app_name", "Google Analytics App Name [iOS]" },
			  			{ "analytics_ios_google_tracking_id", "Google Analytics Tracking ID [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
		},
	}, 

	{ 	name = "Business / Data", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "Airprint",					id = "airprint_plugin" }, --NEW
			{ name = "Text Belt",				id = "textbelt_plugin" }, --NEW
			{ name = "Contacts",					id = "contacts_plugin" }, --NEW
			{ name = "Yelp",						id = "yelp_plugin" }, --NEW
			{ name = "Firebase",					id = "firebase_plugin" }, --NEW
			{ name = "PayPal",					id = "paypal_plugin" }, --NEW
			{ name = "Google Drive",			id = "util_googledrive_plugin",
				config = 
			  	{
			  		all = 
			  		{
			  			{ "utilities_googledrive_client_id", "Google Drive Client ID" },
			  			{ "utilities_googledrive_client_secret", "Google Drive Client Secret" },
			  			{ "utilities_googledrive_redirect_url", "Google Drive Client Redirect URL" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Twilio",						id = "util_twilio_plugin" },
			{ name = "Stripe", 						id = "monetization_stripe_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "ads_android_stripe_secret_key", "Stripe Secret Key [Android]" },
			  			{ "ads_android_stripe_publishable_key", "Stripe Public Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "ads_ios_stripe_secret_key", "Stripe Secret Key [iOS]" },
			  			{ "ads_ios_stripe_publishable_key", "Stripe Public Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Parse", 						id = "parse_plugin",
				config = 
			  	{
			  		android = 
			  		{
			  			{ "analytics_android_parse_app_id", "Parse App ID [Android]" },
			  			{ "analytics_android_parse_rest_key", "Parse REST Key [Android]" },
			  		},
			  		ios = 
			  		{
			  			{ "analytics_ios_parse_app_id", "Parse App ID [iOS]" },
			  			{ "analytics_ios_parse_rest_key", "Parse REST Key [iOS]" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "iCloud", 						id = "util_icloud_plugin",
				config = 
			  	{
			  		ios = 
			  		{
			  			{ "utilities_icloud_kvstore_identifier", "iCloud KV Store ID" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "GBC Data Cabinet",			id = "util_gbcdatacabinet_plugin" },
			{ name = "Safari View", 				id = "util_safari_view_plugin" },
			{ name = "Quick Look", 					id = "business_quicklook_plugin" },
			{ name = "Zip", 							id = "util_zip_plugin" },
			{ name = "Address Book", 				id = "business_address_book_plugin" },
			{ name = "Pasteboard", 					id = "business_pasteboard_plugin" },
		},
	}, 


	{ 	name = "Gaming", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "Game Center (Scott H.)",	id = "gamecenter_plugin" }, --NEW
			{ name = "PlayFab Client",				id = "playfab_client_plugin" }, --NEW
			{ name = "PlayFab Server",				id = "playfab_server_plugin" }, --NEW
			{ name = "PlayFab Combo",				id = "playfab_combo_plugin" }, --NEW
			{ name = "Steam Works",					id = "util_steamworks_plugin",
				config = 
			  	{
			  		desktop = 
			  		{
			  			{ "utilities_steamworks_appname", "Steam AppName" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Google Play Game Services", 	id = "gaming_google_plugin" },			
			{ name = "Dreamlo", 					id = "gaming_dreamlo_plugin" },
			{ name = "GameKit", 					id = "gaming_gamekit_plugin" },
			{ name = "Ouya", 						id = "gaming_ouya_plugin" },
			{ name = "Apple Game Center", 			id = "gaming_apple_plugin" },
			{ name = "Amazon Game Circle", 			id = "gaming_amazon_plugin" },
			{ name = "Photon Cloud", 				id = "gaming_photon_plugin" },

		},
	}, 


	{ 	name = "Hardware", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "QR Scanner",					id = "util_qrscanner_plugin" },			
			{ name = "Proximity Sensor",			id = "proximitysensor_plugin" }, --NEW
			{ name = "Bluetooth",					id = "bluetooth_plugin" }, --NEW
			{ name = "Voice To Text",				id = "voicetotext_plugin" }, --NEW
			{ name = "Bonbonbear Thermometer",	id = "util_bbbthermometer_plugin" },
			{ name = "NFC",							id = "util_nfc_plugin" },
			{ name = "Flashlight",					id = "util_flashlight_plugin" },
			{ name = "Vibrator",						id = "util_vibrator_plugin" },

		},
	}, 

	{ 	name = "Marketing", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "ROKO Mobi (rokolabs)",		id = "rokomobi_plugin" }, --NEW
			{ name = "One Signal", 					id = "gaming_one_signal_plugin" },

		},
	}, 

	{ 	name = "Media", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "Screen Recorder",			id = "screenrecorder_plugin" }, --NEW
			{ name = "Music Streaming",			id = "musicstreaming_plugin" }, --NEW
			{ name = "Replay Kit",					id = "replaykit_plugin" }, --NEW
			{ name = "iTunes Media", 				id = "itunes_media_plugin" },

		},
	}, 


	{ 	name = "Security", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "Open SSL", 		id = "other_openssl_plugin" },
			{ name = "Touch ID",			id = "touchid_plugin" }, --NEW
			{ name = "1Password",		id = "onepasswd_plugin" }, --NEW
		},
	}, 

	{ 	name = "Social", 
		choices =  
		{ 
			--{ name = "TBD",			id = "tbd_plugin" }, --NEW
			{ name = "Facebook V4",					id = "social_facebookv4_plugin" },
			{ name = "Social Popup", 				id = "social_popup_plugin" },
			{ name = "Twitter", 					id = "social_twitter_plugin" },
			{ name = "VK",						id = "util_vk_plugin",
				config = 
			  	{
			  		all = 
			  		{
			  			{ "utilities_vk_scheme", "VK Scheme" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Activity Popup",			id = "util_activity_popup_plugin" },

		},
	}, 

	{ 	name = "Utilities", 
		choices =  
		{ 
			--{ name = "TBD",							id = "tbd_plugin" }, --NEW
			{ name = "GBC Language Cabinet",		id = "util_gbclanguagecabinetr_plugin" },
			{ name = "Math 2D",						id = "util_math2d_plugin" },
			{ name = "Face Detector",				id = "facedetector_plugin" }, --NEW
			{ name = "UI Framework",				id = "uiframework_plugin" }, --NEW
			{ name = "Volume Control",				id = "volumecontrol_plugin" }, --NEW
			{ name = "Quick Action",				id = "quickaction_plugin" }, --NEW
			{ name = "Mouse Cursor",				id = "mousecursor_plugin" }, --NEW
			{ name = "Taptic Engine",				id = "tapticengine_plugin" }, --NEW
			{ name = "More Info",					id = "moreinfo_plugin" }, --NEW
			{ name = "Splash Screen Control",	id = "utilities_corona_splash_control_plugin",
				config = 
			  	{
			  		all = 
			  		{
			  			{ "utilities_corona_splash_control_enable", "Enable Corona Splash" },
			  			{ "utilities_corona_splash_control_image", "Splash Screen Image" },
			  		},
			  	},
			  	conflicts = 
			  	{
			  	},
			},
			{ name = "Lua Proc",						id = "luaproc_plugin" }, --NEW
			{ name = "Physics Body Editor",		id = "util_physicsbodyeditor_plugin" },
			{ name = "Memory Bitmap",				id = "util_memorybitmap_plugin" }, 
			{ name = "On Demand Resources",		id = "util_ondemandresources_plugin" },
			{ name = "UTF-8",							id = "util_utf8_plugin" },
			{ name = "Tween Train",					id = "util_tweentrain_plugin" },
			{ name = "Quaternion",					id = "util_quaternion_plugin" },
			{ name = "Page Curl",					id = "util_pagecurl_plugin" },
			{ name = "delta Tima",					id = "deltatime_plugin" }, --NEW
			{ name = "Collision Calculator",		id = "util_cc_plugin" },
			{ name = "Text To Speech",				id = "util_textospeech_plugin" },
			{ name = "Stable Array",				id = "util_stablearray_plugin" },
			{ name = "MWC RNG",						id = "util_mwc_plugin" },
			{ name = "Toast",							id = "util_toast_plugin" },
			{ name = "awcolor",						id = "util_awcolor_plugin" },
			--{ name = "Corona Viewer",			id = "util_coronaviewer_plugin" },
			{ name = "Notifications", 				id = "util_notifications_plugin" },
			{ name = "Open UDID", 					id = "util_openudid_plugin" },
			{ name = "BitOp", 						id = "util_bit_plugin" },
			{ name = "Photo Lib Plus",				id = "util_photolibplus_plugin" },
			{ name = "Pebble",						id = "pebble_plugin" },
		},
	}, 

}

local function compare(a,b)
   return tostring(string.lower(a.name)) < tostring(string.lower(b.name))
end
for k,v in pairs( settings.plugins_list ) do
	table.sort(v.choices,compare)
end
--table.dump(settings.plugins_list[18],nil, "BOBO")

--table.print_r(settings)


function plugins.attach( dst )
	for k,v in pairs( settings ) do
		dst[k] = v
	end
end

function plugins.get(  )
	return settings.plugins_list
end
return plugins

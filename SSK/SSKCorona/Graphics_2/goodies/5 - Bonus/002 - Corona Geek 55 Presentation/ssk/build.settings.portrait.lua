-- For more details on this file and what you can do with it, look here:
-- https://docs.coronalabs.com/guide/distribution/buildSettings/index.html
--
_G.build_settings = {

   orientation = {
      default = "portrait",
      --content = "portrait", -- Un-comment to lock to this orientation on iOS ONLY
      supported = { "portrait", "portraitUpsideDown", },
   },
   
   android = {
   
      -- The version code must be an integer — it cannot contain any decimal points.
      versionCode = "11", 

      -- Increase heap size from 32MB to device max (this setting is for Android 3.0 and higher. 
      -- Android 2.x  devices will still run the app but they'll ignore this setting.)
      largeHeap = true, 

      usesPermissions = {
         "android.permission.INTERNET",
         "android.permission.WRITE_EXTERNAL_STORAGE",
         --"android.permission.ACCESS_FINE_LOCATION",
         --"android.permission.ACCESS_COURSE_LOCATION",
         -- Find more permissions here: http://developer.android.com/reference/android/Manifest.permission.html
      },

      usesFeatures = {
         --{ name = "android.hardware.camera", required = true },
         --{ name = "android.hardware.location", required = false },
         --{ name = "android.hardware.location.gps", required = false },
         -- Find more features here: http://developer.android.com/guide/topics/manifest/uses-feature-element.html#features-reference
      }
   },

   iphone = {
      plist = {
         UIAppFonts = { "Harrowprint.ttf", },
         UIStatusBarHidden = true,
         UIPrerenderedIcon = false,
         --CFBundleIconFiles = { },
         --MinimumOSVersion = "5.1.0",

      },
   },

}

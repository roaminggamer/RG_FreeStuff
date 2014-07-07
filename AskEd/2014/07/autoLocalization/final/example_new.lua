-- =============================================================
-- This is how I used to localize functions
-- =============================================================
local mAbs,mRand,mDeg,mRad,mCos,mSin,mAcos,mAsin,mSqrt,mCeil,mFloor,mAtan2,mPi,mMin,mMax,getInfo,getTimer,strMatch,strFormat,pairs;require("autoLoc").run()

-- Much shorter now, and if you look at the log, you'll see that the autoLoc.lua file prints out the proper usage string as you update it.
-- i.e. If you add new locals to the file, the usage string is updated.  Then, you can copy and paste it here.
--
-- Lastly, don't need to include the whole usage string.  You can localize just the parts you want, in any order:
-- 
-- local mRand,getTimer;require("autoLoc").run()

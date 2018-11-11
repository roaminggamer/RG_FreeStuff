-- =============================================================
-- !!!         THIS FILE IS GENERATED DO NOT EDIT            !!!
-- =============================================================
--
local mgr         = require 'ssk2.core.interfaces.buttons'

-- =============================================================
-- ======= BASE PARAMS
-- =============================================================
local base_params = {}
base_params.strokeColor = { 1, 0.398, 0, 1 }
base_params.strokeWidth = 3

-- ============================
-- ======= VARIATIONS__BASIC Button
-- ============================
local params = table.shallowCopy( base_params )
params.w                 = 315
params.h                 = 140
params.unselImgSrc       = "images/variations/basic.png"
params.selImgSrc         = "images/variations/basic.png"

mgr:addButtonPreset( "variations_basic", params )

-- ============================
-- ======= VARIATIONS__THREESTATEA Button
-- ============================
local params = table.shallowCopy( base_params )
params.w                 = 316
params.h                 = 140
params.unselImgSrc       = "images/variations/threestateA_unsel.png"
params.selImgSrc         = "images/variations/threestateA_sel.png"
params.lockedImgSrc      = "images/variations/threestateA_locked.png"

mgr:addButtonPreset( "variations_threestateA", params )

-- ============================
-- ======= VARIATIONS__THREESTATEB Button
-- ============================
local params = table.shallowCopy( base_params )
params.w                 = 316
params.h                 = 140
params.unselImgSrc       = "images/variations/threestateB_unsel.png"
params.selImgSrc         = "images/variations/threestateB_sel.png"
params.toggledImgSrc     = "images/variations/threestateB_toggled.png"

mgr:addButtonPreset( "variations_threestateB", params )

-- ============================
-- ======= VARIATIONS__FOURSTATE Button
-- ============================
local params = table.shallowCopy( base_params )
params.w                 = 316
params.h                 = 140
params.unselImgSrc       = "images/variations/fourstate_unsel.png"
params.selImgSrc         = "images/variations/fourstate_sel.png"
params.toggledImgSrc     = "images/variations/fourstate_toggled.png"
params.lockedImgSrc      = "images/variations/fourstate_locked.png"

mgr:addButtonPreset( "variations_fourstate", params )

-- ============================
-- ======= VARIATIONS__HOME Button
-- ============================
local params = table.shallowCopy( base_params )
params.w                 = 172
params.h                 = 173
params.unselImgSrc       = "images/variations/home_unsel.png"
params.selImgSrc         = "images/variations/home_sel.png"

mgr:addButtonPreset( "variations_home", params )

-- ============================
-- ======= VARIATIONS__SOUND Button
-- ============================
local params = table.shallowCopy( base_params )
params.w                 = 200
params.h                 = 200
params.unselImgSrc       = "images/variations/sound_off.png"
params.selImgSrc         = "images/variations/sound_on.png"

mgr:addButtonPreset( "variations_sound", params )


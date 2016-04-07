-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  config.lua
-- =============================================================
-- https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html
-- =============================================================

application = {
   content = {
      width              = 640,
      height             = 960,
      scale              = "letterbox",
      fps                = 30,
      xAlign             = "center",
      yAlign             = "center",
      showRuntimeErrors  = true,
      shaderPrecision    = "highp",
      imageSuffix = {
         ["@2x"]  = 2.0,
         ["@3x"]  = 3.0,
         ["@4x"]  = 4.0,
         ["@5x"]  = 5.0,
         ["@6x"]  = 6.0,
      },
   },
}
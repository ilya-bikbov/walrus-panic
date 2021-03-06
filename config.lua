--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

-- http://coronalabs.com/blog/2013/09/10/modernizing-the-config-lua/
-- calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
   content = {
      width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ),
      height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ),
      scale = "letterbox",
      fps = 30,
      imageSuffix = {
        ["@2x"] = 1.5,
         ["@4x"] = 3.0,
       },
   },
}

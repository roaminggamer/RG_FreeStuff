io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Only run one at a time:
require("ex3")
--require("composer").gotoScene("ex4", {time = 500,effect = "fromLeft"})
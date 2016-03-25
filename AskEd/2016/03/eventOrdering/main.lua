io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

--require "timerTest" -- Unexpected result: alpha and bravo are NOT strictly ordered.

--require "enterFrameTest" -- Worked as expected.  enterFrame events are  strictly ordered.

--require "timerTest2" -- Unexpected result: alpha and bravo are NOT strictly ordered.  (Note: Better w/o closure)

require "timer_enterFrameTest" -- Worked as expected: Timers are defered to next frame and never precede enterFrame in processing.

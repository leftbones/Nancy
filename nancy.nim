# Nancy - Experimental TUI library for Nim
# github.com/leftbones/nancy
# Nim + ANSI = Nancy

import terminal, strformat, strutils
import input

type
    NancyError* = object of CatchableError

var code: string = "\x1b"
var nancyInitialized: bool = false

proc setCursor(x, y: Natural) =
    # Set the cursor's position directly
    stdout.write fmt"{code}[{y};{x}H"


proc clearLine() =
    # Clear the current line
    stdout.write code & "[2K"

proc clearLine(x, y: Natural) =
    # Move the cursor to a position and clear the line
    setCursor(x, y)
    stdout.write code & "[2K"

proc nancyStart(hide_cursor: bool = true) =
    # Initialize Nancy
    if nancyInitialized:
        raise newException(NancyError, "Nancy already initialized")

    if hide_cursor:
        stdout.write code & "[?25l"

    consoleInit()

    stdout.write code & "[?1049h"
    setCursor(0, 0)
    nancyInitialized = true

proc nancyExit() =
    # Return the terminal to it's previous state
    consoleDeinit()

    stdout.write code & "[?25h"
    stdout.write code & "[?1049l"


# TESTING
# =========================

nancyStart()
stdout.write("Press any key")

var exit = false
while not exit:
    var key = getKey()
    case key
    of Key.Escape:
        exit = true
        break
    else:
        if key != Key.None:
            clearLine(0, 2)
            stdout.write fmt"{key} ({int(key)})"

nancyExit()
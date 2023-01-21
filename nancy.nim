# Nancy - Experimental TUI library for Nim
# github.com/leftbones/nancy
# Nim + ANSI = Nancy

import strformat
import input

type
    NancyError* = object of CatchableError

var esc: string = "\x1b"
var nancyInitialized: bool = false

proc setCursor(x, y: Natural) =
    # Set the cursor's position directly
    stdout.write fmt"{esc}[{y};{x}H"

proc clearLine() =
    # Clear the current line
    stdout.write esc & "[2K"

proc clearLineAt(x, y: Natural) =
    # Move the cursor to a position and clear the line
    setCursor(x, y)
    clearLine()

proc write(x, y: Natural, s: string) =
    clearLineAt(x, y)
    echo s

proc nancyStart(hide_cursor: bool = true) =
    # Initialize Nancy
    if nancyInitialized:
        raise newException(NancyError, "Nancy already initialized")

    if hide_cursor:
        stdout.write esc & "[?25l"

    stdout.write esc & "[?1049h"
    setCursor(0, 0)
    nonblock(true)
    nancyInitialized = true

proc nancyExit() =
    # Return the terminal to it's previous state
    stdout.write esc & "[?25h"
    stdout.write esc & "[?1049l"
    nonblock(false)


# TESTING
# =========================

nancyStart()
write(0, 1, "Press Any Key")

var exit = false
while not exit:
    var key = getKey()
    case key
    of Key.Escape:
        exit = true
        break
    else:
        if key != Key.None:
            write(0, 2, fmt"{key} ({int(key)})")

nancyExit()
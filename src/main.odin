package main

import "engine"

main :: proc() {
    engine.init()
    defer engine.shutdown()

    for engine.running() {
        engine.render()
    }
}

package pkg 

import "core:encoding/json"
import "core:os"
import "core:fmt"

GameSettings :: struct {
	window : struct {
    	width:  int,
    	height: int,
    	title:  string,
	},
}

settings : GameSettings

init_settings :: proc() {
    settings_data, ok := os.read_entire_file_from_filename("game_settings.json")
    if !ok {
        panic("Failed to load game_settings.json")
    }
	defer delete(settings_data)

	err := json.unmarshal(settings_data, &settings)
	if err != nil {
		fmt.println(err)
		panic("Failed to unmarshal game_settings")
	}
}


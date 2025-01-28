package render

import "core:strings"
import "core:fmt"

STAGE_FOLDER_PATH :: ""

load_stage :: proc(stage_num: int) {
	sb := strings.builder_make()
    defer strings.builder_destroy(&sb)
	strings.write_string(&sb, "../stages/")
	strings.write_int(&sb, stage_num)
	strings.write_string(&sb, ".dat")

	file_path := strings.to_string(sb)
	fmt.println(file_path)
}

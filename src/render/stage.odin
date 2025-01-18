package render

import "core:strings"
import "core:fmt"

STAGE_FOLDER_PATH :: "../stages/"

load_stage :: proc(stage_num: int) {
	builder: strings.Builder
	_, err := strings.builder_init_len(&builder, 13)
	strings.write_string(&builder, STAGE_FOLDER_PATH)
	strings.write_int(&builder, stage_num)

	file_path := strings.to_string(builder)
	fmt.println(file_path)
}

/*
 *  conv.h
 *  mac_cmd_vocoder
 *
 *  Created by easystudio on 10/24/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "config.h"

extern char *vocode_modulator_filename, *vocode_carrier_filename, *vocode_output_filename;
extern size_t vocode_window_length, vocode_window_overlap;
extern int vocode_band_count;
extern VREAL vocode_volume;


extern VINT vocode_modulator_rate;

extern void (*vocode_start_status_cb)(VINT num_frames);
extern VBOOL (*vocode_update_status_cb)(VINT frame_no);
extern void (*vocode_finish_status_cb)(void);
void conv(char *output_filepath, char* vocode_modulator_filename);



/*
 *  conv.c
 *  mac_cmd_vocoder
 *
 *  Created by easystudio on 10/24/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include <stdio.h>
#include <math.h>
#include "fft.h"
#include "config.h"
#include "error.h"
#include "wave.h"
#include "conv.h"
#include "vocode.h"

static size_t read_zero(WAVE_FILE *source, SAMPLE *dest, size_t length);
static void wave_close_if_open(WAVE_FILE **pp);

static void allocate_memory(void);
//static void free_memory(void);

char *vocode_carrier_filename, *vocode_output_filename;
size_t vocode_window_length, vocode_window_overlap;
int vocode_band_count;
VREAL vocode_volume;
VBOOL vocode_normalize;

static WAVE_FILE *modulator_file = NULL, *carrier_file = NULL, *output_file = NULL;
static SAMPLE modulator_max_magnitude, carrier_max_magnitude,
output_max_magnitude;
static VINT modulator_length;
VINT vocode_modulator_rate;

static SAMPLE *modulator_sample_buffer = NULL, *carrier_sample_buffer = NULL,
*output_sample_buffer1 = NULL, *output_sample_buffer2 = NULL;
static VREAL *modulator = NULL;

static double *fft_c, *fft_s;
static int *fft_rev;

void (*vocode_start_status_cb)(VINT num_frames);
VBOOL (*vocode_update_status_cb)(VINT frame_no);
void (*vocode_finish_status_cb)(void);


/*
 @Ray:
 */
void conv(char *output_filepath, char* vocode_modulator_filename)
{
	/* INI for reading wav file
	 */
	WAVE_INFO wave_info;
	size_t i;
	VINT num_frames, frame_no;
	

	modulator_file = wave_open(vocode_modulator_filename, &wave_info);
	if (wave_info.channels != 1)
		error_display("modulator must be mono (1 channel)");
	modulator_max_magnitude = (1 << (wave_info.bits - 1)) - 1;
	modulator_length = wave_info.length;
	vocode_modulator_rate = wave_info.rate;
	output_file = wave_create(output_filepath, &wave_info);
	output_max_magnitude = (1 << (wave_info.bits - 1)) - 1;
	vocode_window_length = ipow(2, ilog2(vocode_modulator_rate / 15));//15 derived from DEFAULT WINDOW TIME
	vocode_window_overlap = vocode_window_length / 2;
	vocode_volume = 1.0;
	vocode_band_count = 16;	
	vocode_normalize=1;
	allocate_memory();

	
	//=== Reading input wave ========//
	num_frames = (modulator_length - vocode_window_overlap) /
	(vocode_window_length - vocode_window_overlap);
	frame_no = 0;
	vocode_start_status_cb(num_frames);
	
	
	read_zero(modulator_file, modulator_sample_buffer, vocode_window_length);
	convolve(modulator_sample_buffer);
	int idx=1;
	while (read_zero(modulator_file, modulator_sample_buffer +
					 vocode_window_overlap, vocode_window_length - vocode_window_overlap))
    {
		if (vocode_update_status_cb(frame_no)) break;
		convolve(modulator_sample_buffer);
		wave_write(output_file, modulator_sample_buffer +vocode_window_overlap, vocode_window_length - vocode_window_overlap);
		++frame_no;
		++idx;
    }
	
	wave_write(output_file, modulator_sample_buffer + vocode_window_length - vocode_window_overlap,
			   vocode_window_overlap);
	wave_close_if_open(&output_file);
	wave_close_if_open(&modulator_file);
	wave_close_if_open(&carrier_file);
	vocode_cleanup();
}

static size_t read_zero(WAVE_FILE *source, SAMPLE *dest, size_t length)
{
	size_t i, n = wave_read(source, dest, length);
	for (i = n; i < length; ++i)
		dest[i] = 0;
	return n;
}

static void wave_close_if_open(WAVE_FILE **pp)
{
	if (*pp != NULL)
	{
		wave_close(*pp);
		*pp = NULL;
	}
}

static void allocate_memory(void)
{
	modulator_sample_buffer = error_malloc(sizeof(SAMPLE) * vocode_window_length);
	carrier_sample_buffer = error_malloc(sizeof(SAMPLE) * vocode_window_length);
	output_sample_buffer1 = error_malloc(sizeof(SAMPLE) * vocode_window_length);
	output_sample_buffer2 = error_malloc(sizeof(SAMPLE) * vocode_window_length);
	modulator = error_malloc(sizeof(VREAL) * vocode_window_length);
	//output = error_malloc(sizeof(VREAL) * 2 * vocode_window_length);
}

void convolve(SAMPLE *modulator_sample_buffer)
{	
	int size_mask=((1-(-1))/.05+1);
	SAMPLE Arr_Mask[size_mask];
	for (int index=0; index<size_mask; index++)
	{
		SAMPLE x=-1+.05*index;
		Arr_Mask[index]=exp(-5*pow(x,2))*cos(4*PI*x);
		//printf("arrmask #%d: %f\n",index,Arr_Mask[index]);
	}
	SAMPLE *COutput;
 
	COutput = (SAMPLE *)malloc((vocode_window_length+size_mask-1)* sizeof(SAMPLE));
 
	int sizeOutput = vocode_window_length+size_mask-1;
 
 
	//Convolution Algorithm
	for (int i=0; i<sizeOutput; i++) 
	{
		COutput[i]=0;
 
		for (int j=0; j<size_mask; j++) 
		{
			int idx=i-j/2;
			if (idx > 0) 
			{
				COutput[i] += modulator_sample_buffer[idx] * Arr_Mask[j];
				//printf("arrmask #%d: %f\n",j,Arr_Mask[j]);
			}
		}
	}
 
	SAMPLE min=0;
	for (int i=0; i<vocode_window_length; i++)
	{
		int shift=size_mask/2;
		if (modulator_sample_buffer[i]<min)
			min=modulator_sample_buffer[i];
		//printf("arrmask #%d: %lf\n",i,modulator[i]);
		modulator_sample_buffer[i]=COutput[i+shift];
 
		//printf("arrmask #%d: %f\n",i,modulator[i]);
	}
}

/*
static void free_memory(void)
{
	//free_if_not_null((void **)&output);
	free_if_not_null((void **)&modulator);
	free_if_not_null((void **)&output_sample_buffer1);
	free_if_not_null((void **)&output_sample_buffer2);
	free_if_not_null((void **)&carrier_sample_buffer);
	free_if_not_null((void **)&modulator_sample_buffer);
}*/


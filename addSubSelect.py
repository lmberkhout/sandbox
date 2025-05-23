#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright 2025 gr-casperpipe author.
#
# SPDX-License-Identifier: GPL-3.0-or-later
#


import numpy as np
from gnuradio import gr
import sys, time, struct
import numpy as np
from numpy import fft
import matplotlib.pyplot as plt
import matplotlib.animation as anim
import casperfpga

class addSubSelect(gr.sync_block):
    """
    docstring for block addSubSelect
    """
    def __init__(self, hostname="10.1.23.137", fpgfile='/mnt/c/Users/libby/src/tutorials_devel/rfsoc/tut_spec/prebuilt/rfsoc4x2/rfsoc4x2_tut_spec.fpg', acclen=2*(2**28)//2048, adc_chan=0):  # only default arguments here
        """arguments to this function show up as parameters in GRC"""
        gr.sync_block.__init__(
            self,
            name='Casper Device Block',   # will show up in GRC
            in_sig=[],
            out_sig=[(np.float32,2048)]
        ) 
        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).

        
        fpga = casperfpga.CasperFpga(hostname)
        fpga.upload_to_ram_and_program(fpgfile)
        params = fpga.listdev()
        print(params)
        fpga.write_int('acc_len', acclen)
        fpga.write_int('adc_chan_sel', adc_chan)
        fpga.write_int('cnt_rst',1) 
        fpga.write_int('cnt_rst',0) 
        print("Ready for BRAM read!")
        self.fpga = fpga


    def work(self, input_items, output_items):
        """example: multiply with constant"""
        nchannels=4
        nfft=2**12//2
        acc_n = self.fpga.read_uint('acc_cnt')
        print("acc_n is ", acc_n)
        chunk = nfft//nchannels
        raw = np.zeros((nchannels, chunk))
        for i in range(nchannels):
             raw[i,:] = struct.unpack('>{:d}Q'.format(chunk), self.fpga.read('q{:d}'.format((i+1)),chunk*8,0))

        interleave_q = []
        for i in range(chunk):
            for j in range(nchannels):
                interleave_q.append(raw[j,i])
        print(len(interleave_q))
        output_items[0][0] =  np.array(interleave_q, dtype=np.float32)

        return len(output_items[0])

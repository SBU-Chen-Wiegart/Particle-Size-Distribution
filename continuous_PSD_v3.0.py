#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb  3 16:03:20 2022

@author: karenchen-wiegart
"""


import numpy as np
import matplotlib.pyplot as plt
from scipy import ndimage as ndi
from skimage import io
import time
import cv2
from scipy import signal
import pandas as pd


'''
Parameters need to be changed
'''
# dir = '/home/karenchen-wiegart/ChenWiegartgroup/Xiaoyin/2021_FXI/'
# fn = 'recon_scan_99267_bin2_seg_cleaned.tiff'
dir = '/media/karenchen-wiegart/20210709_FXI/XIAOYANG_Proposal_307818/'
fn = 'recon_scan_100030_bin4_cleaned_seg.tiff'
scanid = 100030
step = 1
bin_size = step*4*23.33
# dir = '/media/karenchen-wiegart/20210709_FXI/XIAOYANG_Proposal_307818/miss_data/'
# fn = 'recon_scan_100256_bin4_cleaned_seg.tiff'


'''
1 pixel= 23.33 nm
since we usually do bin=4 
1 feature size is 23.33x4
'''
img = io.imread(dir+fn)
img[img==np.nan] = 0
img = (img>0)*1
mask = img>0
distance = ndi.distance_transform_edt(img)
io.imsave(dir+fn[:-5]+'_distance.tiff', distance)

rl = np.array(range(1, int(distance.max())+3, step))
R_dil_l = []


for rs in rl:
    # Select all the pixels with its value larger than r in distance
    center = distance>=rs
    # Dilate with a sphere kernel
    x, y, z = np.indices((2*rs+1, 2*rs+1, 2*rs+1))
    kernel = (x-rs)**2+(y-rs)**2+(z-rs)**2<rs**2
    dilation = signal.fftconvolve(center, kernel, mode='same')
    dilation[mask==False] = 0
    dilation = dilation>0.5
    R_dil = dilation.sum()-center.sum()
    R_dil_l.append(R_dil)

R_dil_l = np.array(R_dil_l)
q = R_dil_l[:-1]-R_dil_l[1:]
q_positive = q[q>=0]
q_positive = q_positive/np.sum(q_positive)
q_positive = q_positive/bin_size

r_positive = rl[-int(len(q_positive)):]*bin_size
plt.figure()
plt.plot(r_positive, q_positive)
plt.xlabel('Feature size / nm', fontsize=24, weight='bold')
plt.ylabel('Volume Fraction / bin size', fontsize=24, weight='bold')

df = pd.DataFrame({'Feature size / nm': r_positive, 'Volume Fraction / bin size': q_positive})
df.to_csv(f'Feature size distribution_{scanid}_test.csv')
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  9 16:33:29 2021

@author: karenchen-wiegart
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import ndimage as ndi
from skimage import io
import time


dir = '/home/karenchen-wiegart/ChenWiegartgroup/Xiaoyin/2021_FXI/'
fn = 'recon_scan_99267_bin2_seg_cleaned.tiff'
img = io.imread(dir+fn)
distance = ndi.distance_transform_edt(img)

rs_list =[x for x in range(0, 22, 2)]
volume_cumulative = []

for rs in rs_list:
    t1 = time.time()
    markers = distance>rs
    # plt.figure()
    # plt.imshow(img[239])
    # plt.figure()
    # plt.imshow(markers[239])
    '''generate a sphere for dilation'''
    x, y, z = np.indices((2*rs+1, 2*rs+1, 2*rs+1))
    s = (x-rs)**2+(y-rs)**2+(z-rs)**2<rs**2
    dilation = ndi.binary_dilation(markers, structure=s, iterations=1)
    v = dilation.sum()
    volume_cumulative.append(v)
    t2 = time.time()
    print(f'{rs} is finished. Time used {t2-t1}')
    
    # plt.figure()
    # plt.imshow(dilation[239])

volume_cumulative = np.array(volume_cumulative)
PSD = volume_cumulative[1:]-volume_cumulative[:-1]
np.save(dir+'PSD_99267', PSD)
# a = np.zeros((200, 200))
# a[100, 100] = 1

# row, col = np.indices((200,200))
# q = (row-100)**2+(col-100)**2<400
# dilation = ndi.binary_dilation(a, structure=q, iterations=2)
# plt.figure()
# plt.imshow(q)

# plt.figure()
# plt.imshow(dilation)
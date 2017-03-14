# Zedboard_Canny_Edge_Detector
An algorithm using pure convolutional patterns to filter the input video stream and output it to show on a VGA cable. Only PL part of the Zedboard is used.

Target input from OV7670 VGA resolution camera.
The pixels stream is acquired in raw RGB data to FPGA and a Sobel kernel is applied to get gradient value.

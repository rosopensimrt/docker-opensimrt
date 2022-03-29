#Ar_test


we need to run the opencv calibration:


rosrun camera_calibration cameracalibrator.py --size 10x7 --square 0.025 image:=/usb_cam/image_raw camera:=/usb_cam

save the file and then do:

rosservice call /usb_cam/set_camera_info < head_camera.yaml

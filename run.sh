raspivid -n -t 0 -w 640 -h 480 -fps 30 -b 2000000 --profile baseline --intra 15 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=1 pt=100 ! udpsink host=127.0.0.1 port=8000 sync=false &
janus -F /etc/janus/ &
python3 app.py
killall janus
killall raspivid


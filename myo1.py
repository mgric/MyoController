import myo
from myo.lowlevel import pose_t, stream_emg
from myo.six import print_
import win32api, win32con
import time
import random

myo.init()
SHOW_OUTPUT_CHANCE = 0.01

class Listener(myo.DeviceListener):
    # return False from any method to stop the Hub

    def on_connect(self, myo, timestamp):
        print_("Connected to Myo")
        myo.vibrate('short')
        myo.request_rssi()

    def on_rssi(self, myo, timestamp, rssi):
        print_("RSSI:", rssi)

    def on_event(self, event):
        r""" Called before any of the event callbacks. """

    def on_event_finished(self, event):
        r""" Called after the respective event callbacks have been
        invoked. This method is *always* triggered, even if one of
        the callbacks requested the stop of the Hub. """

    def on_pair(self, myo, timestamp):
        print_('Paired')
    

    def on_disconnect(self, myo, timestamp):
        print_('on_disconnect')

    def on_pose(self, myo, timestamp, pose):
        print_('on_pose', pose)
        if pose == pose_t.double_tap:
            print_("Enabling EMG")
            print_("Spreading fingers disables EMG.")
            print_("=" * 80)
            myo.set_stream_emg(stream_emg.enabled)
            myo.mouseControlEnabled()
            myo.controlMouse(enabled)
        elif pose == pose_t.fingers_spread:
            print_("=" * 80)
            print_("Disabling EMG")
            myo.set_stream_emg(stream_emg.disabled)
            myo.controlMouse(disabled)

    def on_unlock(self, myo, timestamp):
        print_('unlocked')

    def on_lock(self, myo, timestamp):
        print_('locked')

    def on_sync(self, myo, timestamp):
        print_('synced')

    def on_unsync(self, myo, timestamp):
        print_('unsynced')
        
    def on_emg(self, myo, timestamp, emg):
        show_output('emg', emg)

i=1
def show_output(message, data):
    
    print_(message + ':' + str(data))
    time.sleep(1)




def main():
    hub = myo.Hub()
    hub.set_locking_policy(myo.locking_policy.none)
    hub.run(1000, Listener())

    # Listen to keyboard interrupts and stop the
    # hub in that case.
    try:
        while hub.running:
            myo.time.sleep(0.2)
    except KeyboardInterrupt:
        print_("Quitting ...")
        hub.stop(True)

if __name__ == '__main__':
    main()
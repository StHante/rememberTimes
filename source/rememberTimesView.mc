import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Timer;

class rememberTimesView extends WatchUi.View {

    private var _updateTimer = new Timer.Timer();

    function initialize() {
        View.initialize();
    }

    function timerCallback() {
        WatchUi.requestUpdate();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        var timerDurationMilliseconds = 30000;
        var repeatTimer = true;
        _updateTimer.start(method(:timerCallback), timerDurationMilliseconds, repeatTimer);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        for (var counter = 0; counter < getApp().timesLabels.size(); counter ++) {
            var timeLabel = View.findDrawableById(getApp().timesLabels[counter]) as Text;
            if (getApp().timesValid[counter]) {
                setLabelFromMoment(timeLabel, getApp().times[counter]);
            }
            else {
                timeLabel.setText("--:--");
            }
        }
    }

    private function setLabelFromMoment(label as Text, moment as Moment) {
        var systemTime = System.getClockTime();
        var offset = new Duration(systemTime.timeZoneOffset + systemTime.dst);
        var info = Gregorian.utcInfo(moment.add(offset), Time.FORMAT_SHORT);
        label.setText(Lang.format("$1$:$2$", [info.hour, info.min.format("%02d")]));        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var timeLabel = View.findDrawableById("timeCurrent") as Text;
        setLabelFromMoment(timeLabel, Time.now());
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}

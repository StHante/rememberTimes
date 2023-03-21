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
        var beginOfToday = getApp().findBeginOfDay(Time.now());

        for (var counter = 0; counter < getApp().min(getApp().timesLabels.size(), getApp().times.size()); counter ++) {
            var timesLabel = getApp().getEntryFromEnd(getApp().timesLabels, counter);
            var time = getApp().getEntryFromEnd(getApp().times, counter); 

            var timeLabel = View.findDrawableById(timesLabel) as Text;
            getApp().setLabelFromMoment(timeLabel, time);
            
            var differenceDays = getApp().numberOfDaysBefore(beginOfToday, time);
            var timeDaysLabel = View.findDrawableById(format("$1$Days", [timesLabel])) as Text;

            if (differenceDays != 0) {
                timeDaysLabel.setText(format("$1$d", [(-differenceDays).format("%+d")]));
            } else {
                timeDaysLabel.setText("");
            }
        }
        for (var counter = getApp().times.size(); counter < getApp().timesLabels.size(); counter ++) {
            var timesLabel = getApp().getEntryFromEnd(getApp().timesLabels, counter);

            var timeLabel = View.findDrawableById(timesLabel) as Text;
            timeLabel.setText("--:--");
            
            var timeDaysLabel = View.findDrawableById(format("$1$Days", [timesLabel])) as Text;

            timeDaysLabel.setText("");
        }

        for (var counter = 1; counter < getApp().min(getApp().timesLabels.size(), getApp().times.size()); counter++) {
            var timesLabel = getApp().getEntryFromEnd(getApp().timesLabels, counter);
            var time = getApp().getEntryFromEnd(getApp().times, counter); 
            var previousTime = getApp().getEntryFromEnd(getApp().times, counter-1);

            var timeExtraLabel = View.findDrawableById(format("$1$Extra", [timesLabel])) as Text;
            setLabelFromDuration(timeExtraLabel, time.subtract(previousTime));
        }
        for (var counter = getApp().times.size(); counter < getApp().timesLabels.size(); counter++) {
            var timesLabel = getApp().getEntryFromEnd(getApp().timesLabels, counter);            
            var timeExtraLabel = View.findDrawableById(format("$1$Extra", [timesLabel])) as Text;
            timeExtraLabel.setText("");
        }
    }

    private function formatDuration(duration as Duration) {
        var minutesPerHour = Gregorian.SECONDS_PER_HOUR / Gregorian.SECONDS_PER_MINUTE;
        var hours = duration.value() / Gregorian.SECONDS_PER_HOUR;
        var minutes = (duration.value() / Gregorian.SECONDS_PER_MINUTE) % minutesPerHour;

        return format("$1$:$2$", [hours, minutes.format("%02d")]);
    }

    private function setLabelFromDuration(label as Text, duration as Duration) {
        //var systemTime = System.getClockTime();
        //var offset = new Duration(systemTime.timeZoneOffset + systemTime.dst);
        //var info = Gregorian.utcInfo(momdur.add(offset), Time.FORMAT_SHORT);
        label.setText(formatDuration(duration));        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var timeLabel = View.findDrawableById("timeCurrent") as Text;
        getApp().setLabelFromMoment(timeLabel, Time.now());
        
        if (getApp().times.size() > 0) {
            var extra1Label = View.findDrawableById("time1Extra") as Text;
            var duration = Time.now().subtract(getApp().getLastEntry(getApp().times));
            setLabelFromDuration(extra1Label, duration);  
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}

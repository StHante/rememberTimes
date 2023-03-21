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

    private function min(a, b) {
        if (a < b) {
            return a;
        }
        return b;
    }

    private function findBeginOfDay(moment as Moment) {
        var gregInfo = Gregorian.info(moment, Time.FORMAT_SHORT);
        return Gregorian.moment({:day=>gregInfo.day, :month=>gregInfo.month, :year=>gregInfo.year, :hour=>0, :min=>0, :sec=>0});
    }

    private function numberOfDaysBefore(beginOfToday as Moment, moment as Moment) {
        var beginOfMomentsDay = findBeginOfDay(moment);
        var offsetToAvoidLeapSeconds = new Duration(1024);
        var difference = beginOfToday.add(offsetToAvoidLeapSeconds).subtract(beginOfMomentsDay);
        return difference.value() / Gregorian.SECONDS_PER_DAY;

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var beginOfToday = findBeginOfDay(Time.now());

        for (var counter = 0; counter < self.min(getApp().timesLabels.size(), getApp().times.size()); counter ++) {
            var timesLabel = getEntryFromEnd(getApp().timesLabels, counter);
            var time = getEntryFromEnd(getApp().times, counter); 

            var timeLabel = View.findDrawableById(timesLabel) as Text;
            setLabelFromMoment(timeLabel, time);
            
            var differenceDays = numberOfDaysBefore(beginOfToday, time);
            var timeDaysLabel = View.findDrawableById(format("$1$Days", [timesLabel])) as Text;

            if (differenceDays != 0) {
                timeDaysLabel.setText(format("$1$d", [-differenceDays]));
            } else {
                timeDaysLabel.setText("");
            }
        }
        for (var counter = getApp().times.size(); counter < getApp().timesLabels.size(); counter ++) {
            var timesLabel = getEntryFromEnd(getApp().timesLabels, counter);

            var timeLabel = View.findDrawableById(timesLabel) as Text;
            timeLabel.setText("--:--");
            
            var timeDaysLabel = View.findDrawableById(format("$1$Days", [timesLabel])) as Text;

            timeDaysLabel.setText("");
        }

        for (var counter = 1; counter < min(getApp().timesLabels.size(), getApp().times.size()); counter++) {
            var timesLabel = getEntryFromEnd(getApp().timesLabels, counter);
            var time = getEntryFromEnd(getApp().times, counter); 
            var previousTime = getEntryFromEnd(getApp().times, counter-1);

            var timeExtraLabel = View.findDrawableById(format("$1$Extra", [timesLabel])) as Text;
            setLabelFromDuration(timeExtraLabel, time.subtract(previousTime));
        }
        for (var counter = getApp().times.size(); counter < getApp().timesLabels.size(); counter++) {
            var timesLabel = getEntryFromEnd(getApp().timesLabels, counter);            
            var timeExtraLabel = View.findDrawableById(format("$1$Extra", [timesLabel])) as Text;
            timeExtraLabel.setText("");
        }
    }

    private function setLabelFromMoment(label as Text, moment as Moment) {
        //var systemTime = System.getClockTime();
        //var offset = new Duration(systemTime.timeZoneOffset + systemTime.dst);
        //var info = Gregorian.utcInfo(momdur.add(offset), Time.FORMAT_SHORT);
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        label.setText(Lang.format("$1$:$2$", [info.hour, info.min.format("%02d")]));       
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

    function getEntryFromEnd(array, index) {
        return array[array.size() - index - 1];
    }

    function getLastEntry(array) {
        return getEntryFromEnd(array, 0);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var timeLabel = View.findDrawableById("timeCurrent") as Text;
        setLabelFromMoment(timeLabel, Time.now());
        
        if (getApp().times.size() > 0) {
            var extra1Label = View.findDrawableById("time1Extra") as Text;
            var duration = Time.now().subtract(getLastEntry(getApp().times));
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

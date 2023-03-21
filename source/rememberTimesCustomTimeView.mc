import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;

class rememberTimesCustomTimeView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        getApp().dcDimensions[0] = dc.getWidth();
        getApp().dcDimensions[1] = dc.getHeight();
        getApp().customTime = Time.now();
        setLayout(Rez.Layouts.CustomTimeLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var timeLabel = View.findDrawableById("customTime") as Text;
        getApp().setLabelFromMoment(timeLabel, getApp().customTime);

        var beginOfToday = getApp().findBeginOfDay(Time.now());
        var differenceDays = getApp().numberOfDaysBefore(beginOfToday, getApp().customTime);
        var timeDaysLabel = View.findDrawableById("customTimeDays") as Text;

        if (differenceDays != 0) {
            timeDaysLabel.setText(format("$1$d", [(-differenceDays).format("%+d")]));
        } else {
            timeDaysLabel.setText("");
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

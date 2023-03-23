import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Application.Storage;

class rememberTimesApp extends Application.AppBase {

    var times = [] as Array<Moment>;
    var timesLabels = ["time5", "time4", "time3", "time2", "time1"];
    var timesListSymbols = [] as Array<Symbol>;

    var dcDimensions = new [2] as Array<Number>;

    var customTime = Time.now();    

    function initialize() {               
        AppBase.initialize();
    }

    function addNewEntry(moment as Moment) {
        times.add(moment);

        storeTimes();
    }

    function deleteLastEntry() {
        times = times.slice(0, -1);

        storeTimes();
    }

    function deleteAllEntries() {
        times = [] as Array<Moment>;

        storeTimes();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        var storedTimes = Storage.getValue("times") as Array<Number>;
        if (storedTimes) {
            for (var counter = 0; counter < storedTimes.size(); counter++) {
                times.add(new Moment(storedTimes[counter]));
            }
        }
    }

    function storeTimes() as Void {
        var storedTimes = new Array[times.size()] as Array<Number>;
        for (var counter = 0; counter < times.size(); counter++) {
            storedTimes[counter] = times[counter].value();
        }
        Storage.setValue("times", storedTimes);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new rememberTimesView(), new rememberTimesDelegate() ] as Array<Views or InputDelegates>;
    }

        function getEntryFromEnd(array, index) {
        return array[array.size() - index - 1];
    }

    function getLastEntry(array) {
        return getEntryFromEnd(array, 0);
    }

    function min(a, b) {
        if (a < b) {
            return a;
        }
        return b;
    }

    function findBeginOfDay(moment as Moment) {
        var gregInfo = Gregorian.info(moment, Time.FORMAT_SHORT);
        return Gregorian.moment({:day=>gregInfo.day, :month=>gregInfo.month, :year=>gregInfo.year, :hour=>0, :min=>0, :sec=>0});
    }

    function numberOfDaysBefore(beginOfToday as Moment, moment as Moment) {
        var beginOfMomentsDay = findBeginOfDay(moment);
        var offsetToAvoidLeapSeconds = 1024;
        var difference = beginOfToday.compare(beginOfMomentsDay);
        if (difference > 0) {
            difference += offsetToAvoidLeapSeconds;
        } else {
            difference -= offsetToAvoidLeapSeconds;
        }
        return difference / Gregorian.SECONDS_PER_DAY;
    }

    function setLabelFromMoment(label as Text, moment as Moment) {
        //var systemTime = System.getClockTime();
        //var offset = new Duration(systemTime.timeZoneOffset + systemTime.dst);
        //var info = Gregorian.utcInfo(momdur.add(offset), Time.FORMAT_SHORT);
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        label.setText(Lang.format("$1$:$2$", [info.hour, info.min.format("%02d")]));       
    }
}

function getApp() as rememberTimesApp {
    return Application.getApp() as rememberTimesApp;
}
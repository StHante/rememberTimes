import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Application.Storage;

class rememberTimesApp extends Application.AppBase {

    var times = new [5] as Array<Moment>;
    var timesValid = [false, false, false, false, false];
    var timesLabels = ["time5", "time4", "time3", "time2", "time1"];

    function initialize() {
        for (var counter = 0; counter < times.size(); counter++) {
            times[counter] = new Moment(0);
        }                
        AppBase.initialize();
    }

    function addNewEntry(moment as Moment) {
        times = times.slice(1, null).add(moment);
        timesValid = timesValid.slice(1,null).add(true);

        storeTimes();
    }

    function deleteLastEntry() {
        times = [new Moment(0)].addAll(times.slice(0, -1));
        timesValid = [false].addAll(timesValid.slice(0, -1));

        storeTimes();
    }

    function deleteAllEntries() {
        for (var counter = 0; counter < times.size(); counter++) {
            times[counter] = new Moment(0);
        }
        timesValid = [false, false, false, false, false];     

        storeTimes();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        var storedTimes = Storage.getValue("times");
        var storedTimesValid = Storage.getValue("timesValid");
        if (storedTimes) {
            for (var counter = 0; counter < times.size(); counter++) {
                times[counter] = new Moment(storedTimes[counter]);
            }
        }
        if (storedTimesValid) {
            timesValid = storedTimesValid;
        }
    }

    function storeTimes() as Void {
        var storedTimes = new Array[times.size()];
        for (var counter = 0; counter < times.size(); counter++) {
            storedTimes[counter] = times[counter].value();
        }
        Storage.setValue("times", storedTimes);
        Storage.setValue("timesValid", timesValid);

    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new rememberTimesView(), new rememberTimesDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as rememberTimesApp {
    return Application.getApp() as rememberTimesApp;
}
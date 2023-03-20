import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Application.Storage;

class rememberTimesApp extends Application.AppBase {

    var times = [] as Array<Moment>;
    var timesLabels = ["time5", "time4", "time3", "time2", "time1"];

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

}

function getApp() as rememberTimesApp {
    return Application.getApp() as rememberTimesApp;
}
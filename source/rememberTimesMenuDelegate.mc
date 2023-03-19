import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class rememberTimesMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :cancel) {
            //System.println("cancelled");
        } else if (item == :saveCurrentTime) {
            getApp().addNewEntry(Time.now());
        } else if (item == :deleteLastTime) {
            getApp().deleteLastEntry();
        } else if (item == :deleteAllTimes) {
            getApp().deleteAllEntries();
        }
    }

}
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ConfirmDeleteLastDelegate extends WatchUi.ConfirmationDelegate {
    function initialize() {
        WatchUi.ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
        if (response == CONFIRM_YES) {
            getApp().deleteLastEntry();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        return true;
    }
}

class ConfirmDeleteAllDelegate extends WatchUi.ConfirmationDelegate {
    function initialize() {
        WatchUi.ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
        if (response == CONFIRM_YES) {
            getApp().deleteAllEntries();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        return true;
    }
}

class rememberTimesMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :cancel) {
            //System.println("cancelled");
        } else if (item == :saveCurrentTime) {
            getApp().addNewEntry(Time.now());
        } else if (item == :saveCustomTime) {
            WatchUi.pushView(new rememberTimesCustomTimeView(), new rememberTimesCustomTimeDelegate(), WatchUi.SLIDE_UP);           
        } else if (item == :deleteLastTime) {
            WatchUi.pushView(new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.confirmDeleteLast)), new ConfirmDeleteLastDelegate(), WatchUi.SLIDE_IMMEDIATE);
        } else if (item == :deleteAllTimes) {
            WatchUi.pushView(new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.confirmDeleteAll)), new ConfirmDeleteAllDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }

}
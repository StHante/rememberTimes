import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Communications;

class rememberTimesListMenu extends WatchUi.Menu {
    function initialize() {
        Menu.initialize();
        for (var counter = getApp().timesListSymbols.size()-1; counter < getApp().times.size(); counter++) {
            getApp().timesListSymbols.add(new Symbol());
        }
        Menu.setTitle((WatchUi.loadResource($.Rez.Strings.listTitle) as String));
        for (var counter = 0; counter < getApp().times.size(); counter++) {
            var info = Gregorian.info(getApp().times[counter], Time.FORMAT_SHORT);
            var itemTitle = format("$1$.$2$. $3$:$4$", [info.day, info.month, info.hour, info.min.format("%02d")]);
            addItem(itemTitle, getApp().timesListSymbols[counter]);
        }
    }
}

class rememberTimesListMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
    }

}
import Toybox.Lang;
import Toybox.WatchUi;

class rememberTimesDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    /*
    function onTap(ClickEvent) as Boolean {
        System.println("Tap");    
        return true;
    }
    */

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new rememberTimesMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
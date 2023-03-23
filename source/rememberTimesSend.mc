import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application.Properties;

class rememberTimesSendView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function send() {
        var url = format("$1$:8080", [Properties.getValue("ipToSend")]);

        var timesToSend = new [getApp().times.size()] as Array<String>;
        for (var counter = 0; counter < timesToSend.size(); counter++) {
            var info = Gregorian.info(getApp().times[counter], Time.FORMAT_SHORT);
            timesToSend[counter] = format("$1$.$2$.$3$ $4$:$5$", [info.day, info.month, info.year, info.hour, info.min.format("%02d")]);
        }

        var json = {
            "timesList" => timesToSend
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
        };

        Communications.makeWebRequest(url, json, options, method(:onReceive));
    }

    function onReceive(responseCode as Lang.Number, data as Lang.Dictionary or Lang.String or Null) as Void {
        var message = findDrawableById("message") as Text;
        if (responseCode == 200) {
            message.setText(loadResource($.Rez.Strings.successSend));
        } else {
            message.setText(format("$1$:\n$2$", [loadResource($.Rez.Strings.failSend), responseCode]));
        }
        WatchUi.requestUpdate();
    } 

    // Resources are loaded here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SendLayout(dc));
        var message = findDrawableById("message") as Text;
        message.setText(loadResource($.Rez.Strings.attemptSend));
    }

    // onShow() is called when this View is brought to the foreground
    function onShow() {
        send();
    }

    // onUpdate() is called periodically to update the View
    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    // onHide() is called when this View is removed from the screen
    function onHide() {
    }
}

class rememberTimesSendDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onTap(ClickEvent) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class rememberTimesCustomTimeDelegate extends WatchUi.BehaviorDelegate {

    private const _minute = new Duration(Gregorian.SECONDS_PER_MINUTE);
    private const _consecutiveTapsForNextIncrement = 3;
    private const _maxDurationBetweenConsecutiveTaps = new Duration(1);    
    private var _increment = _minute as Duration;
    private var _lastTapTime = null as Moment;
    private var _lastTapDirection = 0;
    private var _consecutiveTaps = 0;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function isTopRight(coords as Array<Number>) {
        var diagM = (getApp().dcDimensions[1] - 1).toFloat() / (getApp().dcDimensions[0] - 1);
        return coords[1] < diagM * coords[0];
    }

    function isTopLeft(coords as Array<Number>) {
        var diagM = -(getApp().dcDimensions[1] - 1).toFloat() / (getApp().dcDimensions[0] - 1);
        var diagN = getApp().dcDimensions[1] - 1;
        return coords[1] < diagM * coords[0] + diagN;
    }    

    private function handleIncrements(direction) as Void {
        var now = Time.now() as Moment;

        if (_lastTapTime) {
            if (_lastTapDirection != direction) {
                _increment = _minute;
                _consecutiveTaps = 0;
            } else {
                var durationFromLastTap = now.subtract(_lastTapTime) as Duration;
                if (!durationFromLastTap.greaterThan(_maxDurationBetweenConsecutiveTaps)) {
                    if (_consecutiveTaps >= _consecutiveTapsForNextIncrement) {
                        _increment = _increment.multiply(2);
                        _consecutiveTaps = 0;
                    } else {
                        _consecutiveTaps++;
                    }
                } else {
                    _increment = _minute;
                    _consecutiveTaps = 0;
                }
            }
        }
        
        _lastTapTime = now;
        _lastTapDirection = direction;
    }

    function onTap(event as ClickEvent) as Boolean {
        if (isTopRight(event.getCoordinates())) {
            if (isTopLeft(event.getCoordinates())) {
                handleIncrements(1);
                getApp().customTime = getApp().customTime.add(_increment);
                WatchUi.requestUpdate();
            } else {
                getApp().addNewEntry(getApp().customTime);
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            }
        } else {
            if (isTopLeft(event.getCoordinates())) {
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            } else {
                handleIncrements(-1);
                getApp().customTime = getApp().customTime.subtract(_increment);
                WatchUi.requestUpdate();
            }
        }
        return true;
    }
}
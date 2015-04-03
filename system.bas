CONST screensaver = 0
s& = _SCREENIMAGE
f& = _LOADFONT(ENVIRON$("SYSTEMROOT") + "\fonts\verdana.ttf", 72)
f2& = _LOADFONT(ENVIRON$("SYSTEMROOT") + "\fonts\verdana.ttf", 20)
SCREEN _NEWIMAGE(_WIDTH(s&), _HEIGHT(s&), 32)
_FULLSCREEN _SQUAREPIXELS 'there is something wrong if there are black bars
_FREEIMAGE s&
b& = _LOADIMAGE("background.png")
o& = _LOADIMAGE("overlay.png")
ON TIMER(10) update
CALL update
DIM SHARED btc, btcerror, ltc, ltcerror, doge, dogeerror, drk, drkerror
frame = 0
DO
    _PRINTMODE _KEEPBACKGROUND
    _SOURCE b&
    bgcolor& = POINT(frame, 0)
    CLS , bgcolor&
    _PUTIMAGE (0, 0)-(_WIDTH, _HEIGHT), o&
    _FONT f&: COLOR _RGB(128, 255, 0)
    _PRINTSTRING (30, 30), "CryptoTicker 1.0-qb64"
    _FONT f2&: COLOR _RGB(255, 0, 0)
    _PRINTSTRING (30, 130), "These values will update every ten (10) seconds."
    _FONT f&: COLOR _RGB(255, 128, 0)
    IF btcerror THEN
        _PRINTSTRING (30, 170), "Could not get BITCOIN price. "
    ELSE
        _PRINTSTRING (30, 170), "BITCOIN to US Dollar: " + STR$(btc)
    END IF
    COLOR _RGB(192, 192, 192)
    IF ltcerror THEN
        _PRINTSTRING (30, 270), "Could not get LITECOIN price. "
    ELSE
        _PRINTSTRING (30, 270), "LITECOIN to US Dollar: " + STR$(ltc)
    END IF
    COLOR _RGB(255, 215, 0)
    IF dogeerror THEN
        _PRINTSTRING (30, 370), "Could not get DOGECOIN price. "
    ELSE
        _PRINTSTRING (30, 370), "kiloDOGECOIN to US Dollar: " + STR$(doge)
    END IF
    COLOR _RGB(90, 90, 150)
    IF drkerror THEN
        _PRINTSTRING (30, 470), "Could not get DASH price. "
    ELSE
        _PRINTSTRING (30, 470), "DASH to US Dollar: " + STR$(drk)
    END IF


    _DISPLAY
    frame = frame + 1
    IF frame = _WIDTH(b&) THEN frame = 0
    IF INKEY$ = CHR$(27) THEN doexit = -1
    IF screensaver THEN
        DO WHILE _MOUSEINPUT 'check for mouse movement
            mx = mx + _MOUSEMOVEMENTX
            my = my + _MOUSEMOVEMENTY
        LOOP
        IF INKEY$ <> "" OR mx <> 0 OR my <> 0 THEN doexit = -1
    END IF

LOOP UNTIL doexit
IF _FILEEXISTS("last") THEN KILL "last"
IF _FILEEXISTS("ltc_usd") THEN KILL "ltc_usd"
IF _FILEEXISTS("doge_usd") THEN KILL "doge_usd"
IF _FILEEXISTS("drk_usd") THEN KILL "drk_usd"
SYSTEM


SUB update
SHELL _HIDE "wget --no-check-certificate https://api.bitcoinaverage.com/ticker/USD/last"
SHELL _HIDE "wget http://api.cryptocoincharts.info/tradingPair/ltc_usd"
SHELL _HIDE "wget http://api.cryptocoincharts.info/tradingPair/doge_usd"
SHELL _HIDE "wget http://api.cryptocoincharts.info/tradingPair/drk_usd"
IF _FILEEXISTS("last") THEN
    OPEN "last" FOR INPUT AS #1

    LINE INPUT #1, price$
    btc = VAL(price$)
    btcerror = 0

ELSE
    btcerror = -1
END IF
IF _FILEEXISTS("ltc_usd") THEN
    OPEN "ltc_usd" FOR INPUT AS #2

    LINE INPUT #2, price$
    ltc = VAL(MID$(price$, 27, 10))

    ltcerror = 0
ELSE
    ltcerror = -1
END IF
IF _FILEEXISTS("doge_usd") THEN
    OPEN "doge_usd" FOR INPUT AS #3

    LINE INPUT #3, price$
    doge = VAL(MID$(price$, 28, 10)) * 1000
    dogeerror = 0
ELSE
    dogeerror = -1
END IF
IF _FILEEXISTS("drk_usd") THEN
    OPEN "drk_usd" FOR INPUT AS #4

    LINE INPUT #4, price$
    drk = VAL(MID$(price$, 27, 10))
    drkerror = 0
ELSE
    drkerror = -1
END IF
CLOSE #1: CLOSE #2: CLOSE #3: CLOSE #4
KILL "last"
KILL "ltc_usd"
KILL "doge_usd"
KILL "drk_usd"

END SUB



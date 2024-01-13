(
OSCdef(\player1, { |msg, time| //second player
	~dx7.value(40, 127, 5.1, 9393);
}, \pozyxPlayerPos);
)

(
m = NetAddr("127.0.0.1", 57120); // loopback

m.sendMsg("/pozyxPlayerPos", "asds");
)

~dx7.value(40, 127, 5.1, 9393);
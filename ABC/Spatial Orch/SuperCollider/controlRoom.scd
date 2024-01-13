~player1.set("amp", 1);


OSCdef(\test, {|msg, time, addr, recvPort| msg.postln}, '/chat', n); // def style


m = NetAddr("127.0.0.1", 57120); // loopback
m.sendMsg("/sceneboot", 1);
m.sendMsg("/sceneboot1", 1);
m.sendBundle(0.2, ["/pozyxPlayerPos", 0, 49, 1, 1]);
m.sendBundle(0.2, ["/pozyxPlayerPos", 1, 4, 1, 2]);
n.sendBundle(0.2, ["/playerPos", 1, 3, 1]);

~global[0,0]
~global[0,2]



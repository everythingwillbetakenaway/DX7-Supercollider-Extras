~player1.set("amp", 1);


OSCdef(\test, {|msg, time, addr, recvPort| msg.postln}, '/chat', n); // def style


m = NetAddr("127.0.0.1", 57120); // loopback


m.sendMsg("/sceneboot", 1);
m.sendBundle(0.2, ["/playerPos", 0, 2 , 2]);
m.sendBundle(0.2, ["/playerPos", 1, 3, 1]);
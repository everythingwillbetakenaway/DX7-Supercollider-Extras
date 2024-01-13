(
~player1 = Bus.audio(s,1);
~player2 = Bus.audio(s,1);
~player3 = Bus.audio(s,1);
~player4 = Bus.audio(s,1);

~global = Array2D.new(3,4); //object sayisi kadar genis \(.)/ array

~disCal = { arg a1,b1; (a1.squared + b1.squared).sqrt};

OSCdef(\initialOSC, { |msg, time|
	~global[msg[2],0] = msg[0];
	~global[msg[2],1] = msg[1];
}, \objectPos);
)

(
~player1_Spat_Bus = Bus.audio(s,1);
~player2_Spat_Bus = Bus.audio(s,1);
~player3_Spat_Bus = Bus.audio(s,1);
~player4_Spat_Bus = Bus.audio(s,1);

~global = Array2D.new(4,4); //object sayisi kadar genis \(.)/ array

~disCal = { arg a1,b1; (a1.squared + b1.squared).sqrt};
~nova = Group.new;



OSCdef(\initialOSC, { |msg, time|
	~global[msg[1],0] = msg[2];
	~global[msg[1],1] = msg[3];
	~global[msg[1],2] = msg[4];
}, \objectPos);
)
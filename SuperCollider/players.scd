(
//key-follow++++envelope _EKLE
var noteArray = Array.newClear(128),
nova = ParGroup.new,
abc = Bus.audio(s,1),
playerz = Array2D.new(5,3),
vr = Array.fill(128, 63),
defme,folder;
SynthDef(\Player,{ arg out = 0,  bufnum = ~smple[62],  busMe, amp = 0, gate = 1;
	var inMe = In.ar(busMe,1) * amp;
	Out.ar(0,[inMe,inMe]);

}).add;
OSCdef(\x, { |msg, time|
	~player1 = Synth(\Player,[\busMe, ~player1_Spat_Bus]);
	~player2 = Synth(\Player,[\busMe, ~player2_Spat_Bus]);
	~player3 = Synth(\Player,[\busMe, ~player3_Spat_Bus]);
	~player4 = Synth(\Player,[\busMe, ~player4_Spat_Bus]);
}, \sceneboot);
)
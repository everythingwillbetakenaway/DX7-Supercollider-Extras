(
//key-follow++++envelope _EKLE
var noteArray = Array.newClear(128),
nova = ParGroup.new,
abc = Bus.audio(s,1),
playerz = Array2D.new(5,3),
vr = Array.fill(128, 63),
defme,folder;
SynthDef(\player,{ arg out = 0,  bufnum = ~smple[62],  busMe, amp = 1, gate = 1, busOut;
	var inMe = In.ar(busMe,1) * amp;
	Out.ar(busOut, inMe);
}).add;
OSCdef(\playerX, { |msg, time|
	~player1 = Synth.after(~nova, \player,[\busMe, ~player1_Spat_Bus,\busOut, 2, \amp, 1]);
	~player2 = Synth.after(~nova, \player,[\busMe, ~player2_Spat_Bus,\busOut, 3, \amp, 1]);
	~player3 = Synth(\player,[\busMe, ~player3_Spat_Bus,\busOut, 0, \amp, 0]);
	~player4 = Synth(\player,[\busMe, ~player4_Spat_Bus,\busOut, 0, \amp, 0]);
}, \sceneboot1);
)
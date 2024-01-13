(
SynthDef(\movingSound, {arg abc = 1;
    Out.ar(0,
      HPF.ar(
		CombC.ar(
			SinOscFB.ar(
				LFNoise1.ar(
					1, // LFO
					0, // range in MIDI
					LFSaw.ar(
						[8,7.23],//second LFO
						0,
						[0,2,4,1].choose, // range in MIDI
						30 // offset in MIDI
				) ).midicps,[0.2,0.4,0.5,0.3].choose,
				0.24,
				0 ),
			0.2, // max delay
				Lag.kr(Fold.kr(abc,0.028,0.4)),//[0.2,0.21,0.18].choose, // actual delay
				//!!! it sounds different without lag.kr
			[3,2,4,8].choose
	), 79, 8)
    )
}).add;
a = Synth(\movingSound);
)

{ MouseX.kr(0,1).poll(Impulse.kr(20), \test2) }.play(s);
0.088 , 0.2


33.6.fold(0,1)

x = 20;
(
OSCdef(\player0, { |msg, time| //first player
	x = x - msg[1];
	a.set(\abc,x/1000);
	((x/1000).fold(0.088,2)).postln;
}, \playerPos);
)

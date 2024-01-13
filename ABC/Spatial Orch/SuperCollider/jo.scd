(
x = 20;
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
		), 79, 1)
	)
}).add;
a = Synth(\movingSound);
OSCdef(\playerMove, { |msg, time| //first player
	//msg[1].postln;
	if(msg[1] == 0, {
		x = x - msg[2];
		a.set(\abc,x/1000);
		//((x/1000).fold(0.088,2)).postln;
});
}, \pozyxPlayerPos);
)

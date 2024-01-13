[4,2,41,4].choose

Select.ar


(
// select everything between the two parentheses
{
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
			MouseX.kr(0,1),//[0.2,0.21,0.18].choose, // actual delay
			[3,2,4,8].choose
), 79, 100)}.play
)

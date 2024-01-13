(
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme,
abc = Bus.audio(s,1);
SynthDef(\SOSsnare,
	{arg out = 0, sust = 0.1, drmLvl = 0.25,
		snrLvl = 40, tight = 1000,totVol = 0.5,
		freq = 405, amp = 0.8;
		var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
		var snare_noise, snare_brf_1, snare_brf_2, snare_brf_3, snare_brf_4, snare_reson;
		var snare_env;
		var snare_drum_mix;

		drum_mode_env = EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		drum_mode_sin_1 = SinOscFB.ar(freq*0.53, 0.5, drum_mode_env * 0.5);
		drum_mode_sin_2 = SinOscFB.ar(freq, 0.5, drum_mode_env * 0.5);
		drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.85),
			184,
			0.5/1.3,
			mul: drum_mode_env*5,
			add: 0);
		drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drmLvl;

		// choose either noise source below
		//	snare_noise = Crackle.ar(1.2, 1);
		snare_noise = LFNoise0.ar(20000, 0.1);
		snare_env = EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		snare_brf_1 = BRF.ar(in: snare_noise, freq: 8000, mul: 0.5, rq: 0.1);
		snare_brf_2 = BRF.ar(in: snare_brf_1, freq: 5000, mul: 0.5, rq: 0.1);
		snare_brf_3 = BRF.ar(in: snare_brf_2, freq: 3600, mul: 0.5, rq: 0.1);
		snare_brf_4 = BRF.ar(in: snare_brf_3, freq: 2000, mul: snare_env, rq: 0.0001);
		snare_reson = Resonz.ar(snare_brf_4, tight, mul: snrLvl) ;
		snare_drum_mix = Mix.new([drum_mode_mix, snare_reson]) * amp;
		snare_drum_mix = snare_drum_mix.clip2(1) * totVol;
		Out.ar(abc, snare_drum_mix);
		Out.ar(out, [snare_drum_mix, snare_drum_mix]);

	}
).add;
defme = { arg a1,b1,c1; var a =
	[
		\snrLvl,  vr[0].linexp(0,127,0.4,4000),
		\drmLvl,   vr[1].linexp(0,127,0.0025,25),
		\sust,   vr[2].linexp(0,127,0.01,1),
		\tight, vr[3].linexp(0,127,100,10000),
		\totVol, vr[7].linexp(0,127,0.02,1),
		\rel,    vr[5].linexp(0,127,0.01,30)
	];
	if(a1 == 1) { [\freq, b1.midicps, \amp, c1.linexp(0,127,0.1,5)] ++ a} {a}};
MIDIdef.noteOn(\SOSsnareController, {arg vel, note;
	Synth(\SOSsnare,defme.value(1, note, vel),nova);
	~test_SOSsnare = 1;
},srcID:~midiInINST1,chan: 5).permanent_(true);
MIDIdef.cc(\SOSsnareCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..10),srcID:~midiInINST1,chan:5).permanent_(true);
SynthDef(\SOSsnareDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)


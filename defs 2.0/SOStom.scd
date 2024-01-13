(
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme,
abc = Bus.audio(s,1);
SynthDef(\SOStom,
	{arg out = 0, sust = 0.4, drmLvl = 0.25,
		freq = 90, timbre = 1.0, amp = 0.8, totVol = 0.9;
		var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
		var stick_noise, stick_env;
		var drum_reson, tom_mix;

		drum_mode_env = EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		drum_mode_sin_1 = SinOscFB.ar(freq*0.8, 0.2, drum_mode_env * 0.5);
		drum_mode_sin_2 = SinOscFB.ar(freq, 0.2, drum_mode_env * 0.5);
		drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
			freq*0.85,
			timbre/1.3,
			mul: drum_mode_env*5,
			add: 0);
		drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drmLvl;
		stick_noise = Crackle.ar(2.01, 1);
		stick_env = EnvGen.ar(Env.perc(0.005, 0.01 * 2.5 * sust), 1.0) * 3;
		tom_mix = Mix.new([drum_mode_mix, stick_env]) * 2 * amp;
		tom_mix = tom_mix.clip2(1) * totVol;
		Out.ar(abc, tom_mix);
		Out.ar(out, [tom_mix, tom_mix])

	}
).add;
defme = { arg a1,b1,c1; var a =
	[
		\drmLvl,  vr[0].linexp(0,127,0.025,2.5),
		\timbre,   vr[1].linexp(0,127,0.1,10),
		\sust,      vr[2].linexp(0,127,0.04,4),
		\trigRt, vr[3].linexp(0,127,1,400),
		\attk,   vr[4].linexp(0,127,0.0001,5),
		\rel,    vr[5].linexp(0,127,0.01,30),
		//
		\totVol, vr[7].linexp(0,127,0.03,1)];
	if(a1 == 1) { [\freq, b1.midicps, \amp, c1.linexp(0,127,0.1,2)] ++ a} {a}};
MIDIdef.noteOn(\SOStomController, {arg vel, note;
	Synth(\SOStom,defme.value(1, note, vel),nova);
	~test_SOStom = 1;
},srcID:~midiInINST1,chan: 6).permanent_(true);
MIDIdef.cc(\SOStomCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..10),srcID:~midiInINST1,chan:6).permanent_(true);
SynthDef(\SOStomDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)

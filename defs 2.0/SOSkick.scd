(
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme,
abc = Bus.audio(s,1);
SynthDef(\SOSkick,
	{ arg out = 0, freq = 50, modFrq = 3, modInd = 4, sust = 0.01, amp = 0.8, noiseL = 0.025, vol=0.25,rez=1;
		var pitch_contour, drum_osc, drum_lpf, drum_env;
		var beater_source, beater_hpf, beater_lpf, lpf_cutoff_contour, beater_env;
		var kick_mix;
		pitch_contour = Line.ar(freq*2, freq, 0.02);
		drum_osc = PMOsc.ar(	pitch_contour,
			modFrq,
			modInd/1.3,
			mul: 1,
			add: 0);
		drum_lpf = LPF.ar(in: drum_osc, freq: 1000, mul: 1, add: 0);
		drum_env = drum_lpf * EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		beater_source = WhiteNoise.ar(noiseL);
		beater_hpf = BHiPass4.ar(in: beater_source, freq: 500, mul: 1, add: 0, rq:rez);
		lpf_cutoff_contour = Line.ar(6000, 500, 0.03);
		beater_lpf = BLowPass4.ar(in: beater_hpf, freq: lpf_cutoff_contour, mul: 1, add: 0, rq:rez);
		beater_env = beater_lpf * EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		kick_mix = Mix.new([drum_env, beater_env]) * amp;
		kick_mix = kick_mix.clip2(1) * vol;
		Out.ar(abc, kick_mix);
		Out.ar(0, [kick_mix, kick_mix])
	}
).add;
defme = { arg a1,b1,c1; var a =
	[
		\modFrq,    vr[0].linexp(0,127,0.1,260),
		\modInd,    vr[1].linexp(0,127,0.01,2000),
		\sust,      vr[2].linlin(0,127,0.01,1),
		\noiseL,    vr[3].linexp(0,127,0.0025,0.25),
		\vol,       vr[7].linexp(0,127,0.03,1),
		\rez,       vr[4].linexp(0,127,0.1,10)];
	if(a1 == 1) { [\freq, b1.midicps, \amp, c1.linexp(0,127,0.1,2)] ++ a} {a}};
MIDIdef.noteOn(\SOSkickSeat, {arg vel, note;
	Synth(\SOSkick,defme.value(1, note, vel),nova);
	~test_SOSkick = 1;
},srcID:~midiInINST1,chan: 4).permanent_(true);
MIDIdef.cc(\SOSkickCC, {arg ...args;
		vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..10),srcID:~midiInINST1,chan:4).permanent_(true);
SynthDef(\SOSkickDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)



(//multitrack support
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme,
abc = Bus.audio(s,1);
SynthDef(\Sumanguru, {arg freq,amp,
	feedB,rand,reverb,trigRt,attk,rel,
	totVol;
	var triggerSpeed = (freq/trigRt);
	var trigger = Impulse.ar(triggerSpeed);
	var simpleEnv = Env.perc(attackTime:attk,releaseTime: rel).ar(2);
	var main = SinOscFB.ar(TExpRand.kr(freq/rand,freq*rand,trigger),feedB,
		mul:EnvGen.ar(Env.perc(0.5/triggerSpeed, 0.5/triggerSpeed),trigger));
	var out = FreeVerb.ar(main,mix:reverb,room:reverb,damp:0.5);
	out = out *((totVol + amp -15).dbamp) * simpleEnv;
	Out.ar(abc, out );
	Out.ar([0,1],out)
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\feedB,  vr[0].linexp(0,127,0.01,3000),
		\rand,   vr[1].linexp(0,127,0.75,1.33966),
		\reverb, vr[2].linlin(0,127,0.01,1),
		\trigRt, vr[3].linexp(0,127,1,400),
		\attk,   vr[4].linexp(0,127,0.0001,5),
		\rel,    vr[5].linexp(0,127,0.01,30),
		//
		\totVol, vr[7].linlin(0,127,-24,24)];
	if(a1 == 1) { [\freq, b1.midicps, \amp, c1.linlin(0,127,-12,12)] ++ a} {a}};
MIDIdef.noteOn(\SumanguruController, {arg vel, note;
	Synth(\Sumanguru,defme.value(1, note, vel),nova);
	~test_Sumanguru = 1;
},srcID:~midiInINST4,chan: 0).permanent_(true);
MIDIdef.cc(\SumanguruCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..10),srcID:~midiInINST4,chan:0).permanent_(true);
SynthDef(\SumanguruDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)


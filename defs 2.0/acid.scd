(
var
vr = Array.fill(128, 63),
defme,
noteArrayAcid = Array.newClear(128),
abc = Bus.audio(s,1);
SynthDef(\Acid, {
	arg outBus=0, gate=1, pitch=50, amp=0.1, totVol,
	fltAtk,fltDec,fltSus,fltRel,fltAmt,fltRz,
	volAtk,volDec,volSus,volRel,volAmt;
	var env1, env2, out , tenv;
	env1 = EnvGen.ar(
		Env.adsr(
			attackTime:volAtk,
			decayTime:volDec,
			sustainLevel:gate * volSus,
			releaseTime:volRel,
	), gate, 1,doneAction:2);
	env2 = EnvGen.ar(Env.adsr(fltAtk, fltDec, fltSus, fltRel, fltAmt, -4), gate);
	out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);
	out = BLowPass4.ar(out, ((pitch + env2).clip2(124)).midicps, fltRz,0.1);
	//out = RLPF.ar(out, (pitch + env2).midicps, fltRz);
	out = out * env1* ((totVol + amp -15).dbamp);
	Out.ar(abc, out);
	Out.ar(outBus, out.dup);
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\fltAtk,  vr[0].linexp(0,127,0.0005,0.01),
		\fltDec,  vr[1].linexp(0,127,0.01,20),
		\fltSus,  vr[2].linlin(0,127,0,1),
		\fltRel,  vr[3].linexp(0,127,0.01,10),
		\fltAmt,   vr[4],
		\fltRz,    vr[5].linexp(0,127,1,0.001),
		//
		\volAtk,  vr[6].linexp(0,127,0.0001,1),
		\volDec,  vr[8].linexp(0,127,0.01,20),
		\volSus,  vr[9].linlin(0,127,0,1),
		\volRel,  vr[10].linexp(0,127,0.01,10),
		\totVol, vr[7].linlin(0,127,-24,24)];
	if(a1 == 1) { [\pitch, b1, \amp, c1.linlin(0,127,-12,12)] ++ a} {a}};
MIDIdef.noteOn(\AcidController, {arg vel, note;
	if(noteArrayAcid[note] !== nil,noteArrayAcid[note].free);
	noteArrayAcid[note] = Synth(\Acid,defme.value(1, note, vel),~novaAcid);
	~test_Acid = 1;
},srcID:~midiInINST2,chan: 8).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyAcid, {arg vel, note;
	noteArrayAcid[note].set(\gate,0);
	noteArrayAcid[note] = nil;
},srcID:~midiInINST2,chan:8).permanent_(true);
MIDIdef.cc(\AcidCC, {arg ...args;
	vr[args[1]] = args[0];
	~novaAcid.setControls(defme.value(0));
},(0..10),srcID:~midiInINST2,chan:8).permanent_(true);
SynthDef(\AcidDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)

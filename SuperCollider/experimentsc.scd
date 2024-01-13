(
var numChannels = ~dirt.numChannels;


SynthDef(\ChicagoPad, { |out, note, note2=48, note3=44, cpcutoff=500, velocity = 0.2, gate=1, speed=1, sustain=0.8, decay=0, pan, begin=0, end=1, up = 0 |

  var freq,freq2,freq3,snd, env, envGen, line;

  decay = decay * 0.1;
  freq = (note + up).midicps;
  freq2 = (note2 + up).midicps;
  freq3 = (note3 + up).midicps;
  freq = freq + SinOsc.kr(freq*1/2, 0, freq/2, 0);
  snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;
  snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr(7.13).range(0.00,0.1))*0.1;
  snd = Mix(snd);
  snd = FreeVerb.ar(snd, 0.51,10,0.1)*2;
  snd = snd *8;
  snd = RLPF.ar(snd, SinOsc.kr([0.1,4.2],  0, [1700,480], [4000,700,5000])/[20.51,20], SinOsc.ar(0.1,1.5*pi)+1.05)/3;
  snd = Mix(snd);
  snd = MoogFF.ar(snd, SinOsc.kr(0.08, 0.5, cpcutoff/10, cpcutoff), 3, 0);
  line = Line.ar(begin, end, sustain, doneAction:2);
  env = Env([0, 1, 0],[1,5], curve:2);
  envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
  snd = [snd , AllpassC.ar(snd, decay, 0.05+SinOsc.ar(0.11).range(0,0.045), 0.3)];
  //snd = snd.tanh*2;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, envGen));
}).add;


SynthDef(\donk, {
    |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
    var line = Line.ar(begin, end, sustain, doneAction:2);
    var env = Env([0, 1, 0], [0.01, 1], curve:-3);
    var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
    var modulator = (SinOsc.ar(freq*[1.0001,0.9999]*abs(speed))*2).tanh;
    var carrier = (SinOsc.ar((freq/4)+(modulator*1000*envGen))*0.8).tanh;
    var sound = DirtPan.ar(carrier, ~dirt.numChannels, pan, envGen);
    OffsetOut .ar(out, sound);
}).add;

SynthDef(\wub, {
  |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
  var line = Line.ar(begin, end, sustain, doneAction:2);
  var env = Env([0, 1, 0],[1,5], curve:2);
  var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
  // --- //
  var speedFreq = freq*abs(speed)/4;
  var mod = Latch.ar((SinOsc.ar(speedFreq*[7,11,13,5])*5).tanh*2000*envGen, Saw.ar(21000*envGen));
  var car =  Latch.ar(((SinOsc.ar(speedFreq+mod)*10)+(SinOsc.ar(speedFreq)!2)).tanh, Saw.ar(21000*envGen));
  var sound = LPF.ar(car, DC.ar(20000)*envGen+DC.ar(10))*(-11.dbamp);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;

SynthDef(\sawpluck, {
  |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
  var line = Line.ar(begin, end, sustain, doneAction:2);
  var env = Env([0, 1, 0.333, 0],[5, 70, 1000]);
  var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
  var sound = Saw.ar(freq*abs(speed));
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;

SynthDef(\vibsawpluck, {
  |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
  var line = Line.ar(begin, end, sustain, doneAction:2);
  var env = Env([0, 1, 0.333, 0],[5, 70, 1000]);
  var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
  var sound = Saw.ar(freq*abs(speed)+(SinOsc.ar(10)*(freq*0.06)*line*line));
  sound = RLPF.ar(sound, Clip.ar(envGen*freq*48, 0, 20000), 0.5);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;

SynthDef(\wob, {
  |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
  var line = Line.ar(begin, end, sustain, doneAction:2);
  var env = Env([0, 1, 0],[1, 1]);
  var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
  // --- //
  var speedFreq = freq*abs(speed)/4;
  var mod = Latch.ar((SinOsc.ar(speedFreq*[7,11,13,5])*5).tanh*2000*envGen, Saw.ar(21000*envGen));
  var car =  Latch.ar(((SinOsc.ar(speedFreq+mod)*10)+(SinOsc.ar(speedFreq)!2)).tanh, Saw.ar(21000*envGen));
  var sound = car*(-10.dbamp);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;

SynthDef(\noisebuild, {
  |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
  var line = Line.ar(begin, end, sustain, doneAction:2);
  var env = Env([0, 1, 0],[127, 1],curve:4);
  var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
  // --- //
  var sound = HPF.ar(BPF.ar(WhiteNoise.ar()*envGen, 10+(20000*envGen), 0.8), 1000);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;


SynthDef(\bpfsaw, { |attack=2, sustain=0, release=3, ts=1, c1=1, c2=(-1),
  freq=500, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3, accelerate=500,
  cfmin= 200, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out|
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[attack,sustain,release],[c1,0,c2]),timeScale:ts,doneAction:2);
	sig = Saw.ar(freq*{LFNoise1.kr(0.5,detune)}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,accelerate,0.5,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*amp;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan,env))
}).add;


//Latest SynthDefs ---------------------------------------------------------------




SynthDef(\supers, {|out, pan, freq=440,sustain=0.1, accelerate=0.2 |
  var snd, env, ctrl,bank,v;
  snd = SinOscFB.ar([freq,freq+10],accelerate,3).tanh;
  snd = snd + BrownNoise.ar(accelerate * XLine.kr(1,0.001,0.05));
  snd = BPF.ar(snd, freq+50, 0.9);
  snd = LeakDC.ar(snd);
  env = EnvGen.ar(Env.perc(0.01,sustain), doneAction:2 );
  bank = (0.01, 0.015 ..0.07);
  v = LFTri.kr(0.015).range(0.0001, 0.0003);
  snd = MembraneHexagon.ar(snd,accelerate.range(0.001,0.4),mul:v);
  OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan,env))
}).add;

SynthDef(\supersfb, {|out, pan, freq=440,sustain=0.1, accelerate=0.2 |
  var snd, env, ctrl;
  snd = SinOscFB.ar([freq,freq+10],accelerate,3).tanh;
  snd = snd + BrownNoise.ar(accelerate * XLine.kr(1,0.001,0.05));
  snd = BPF.ar(snd, freq+50, 0.9);
  snd = LeakDC.ar(snd);
  env = EnvGen.ar(Env.perc(0.01,sustain), doneAction:2 );
  OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan,env))
}).add;

SynthDef(\superphy, {|out, pan, freq,sustain=1,accelerate=2 |
  var attrel = (sustain/2).clip(0,1);
	var env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
  var n = SinOsc.ar(freq)*env;
  var bank = (0.01, 0.015 ..0.07);
  var v = LFTri.kr(bank.scramble[5..7]).range(0.0001, 0.0003);
  var excit = LFSaw.kr(0.01,rrand(0.01, accelerate/10), 0.42);
  var sound = MembraneHexagon.ar(n,excit,mul:v);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan,env))
}).add;

SynthDef(\superphy2, {|out, pan, freq,sustain=1,accelerate=0.04 |
  var delayTime = (1 / freq)+accelerate;
  var attrel = (sustain).clip(0,0.8);
	var env = EnvGen.ar(Env.linen(attrel, sustain-(1.5*attrel), attrel), doneAction:2);
  var n = PinkNoise.ar(freq);
  var bank = (0.01, 0.015 ..0.07);
  var v = LFTri.kr(0.015).range(0.0001, 0.0003);
  var sound = MembraneHexagon.ar(n,accelerate.range(0.001,0.4),mul:v);
  sound = CombL.ar(sound,delayTime.range(0.01, 0.5),delayTime.range(0.02,0.4),4);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan,env))
}).add;

//--------------------------------------------------------------------------------



SynthDef(\superfork, {|out, speed=1, sustain=1, decay=0, pan, freq, voice=0 |
	var sound, env;
	env = EnvGen.ar(Env.linen(0.001, 0.998, 0.001), timeScale:sustain, doneAction:2);
	sound = SinOsc.ar(freq) * XLine.ar(0.3, 1e-4, sustain*4);
	sound = SinOsc.ar(6.1*freq) * XLine.ar(1, 1e-7, sustain*4) + sound;
	sound = SinOsc.ar(16.7*freq) * XLine.ar(1.3, 1e-6, sustain/2) + sound;
	sound = SinOsc.ar(20.1*freq) * XLine.ar(2, 1e-7, sustain/3) + sound;
	sound = sound * 0.2;
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;


SynthDef(\superhammond, {|out, speed=1, sustain=1, decay=0, pan, freq, vibrato=0.5, vrate=7,
	voice=0, perc=0, percf=2 |
	var freqs, amps, sound, click, env, ampscale, attrel;
	attrel = (sustain/2).clip(0,0.005);
	env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
	freqs = [0.5, 1.4988, 1, 2, 2.9976, 4, 5.0409, 5.9953, 8] * freq;
	freqs = 2**(freqs < 63) * freqs; // fold up bottom register
	freqs = freqs / (2**(freqs > 6000)); // fold down high harmonics
	freqs = freqs / (2**(freqs > 6000)); // do it again for the really high notes
	amps = SelectX.kr(voice, [
		[1, 4, 5, 4, 3, 1, 0, 0, 0], // 0: bass violin 16'
		[0, 0, 8, 0, 4, 0, 0, 0, 0], // 1: tibia 8'
		[0, 7, 8, 1, 2, 0, 0, 0, 0], // 2: bassoon 8'
		[0, 0, 7, 8, 8, 8, 8, 7, 2], // 3: french trumpet 8'
		[4, 0, 5, 5, 4, 5, 3, 3, 6], // 4: string ensemble
		[8, 8, 5, 3, 2, 4, 5, 8, 8], // 5: Blues
		[8, 8, 8, 0 ,0, 0, 0, 0, 3], // 6: Jazz 1
		[8, 8, 8, 8, 8, 8, 8, 8, 8], // 7: Full Shout
		[8, 0, 0, 0, 0, 0, 8, 8, 8], // 8: Bro' Jack
		[0, 0, 8, 8, 0, 0, 0, 0, 0]  // 9: Jazz 2
	]);
	amps = amps - [0, 0, 0, 0, 0, 0, 0.5, 1, 1.5]; // damp brilliance a bit
	amps = 2**(amps-8);
	click = WhiteNoise.ar(1) * XLine.ar(1,1e-6, 0.1);
	sound = 0.5 * Mix.ar( SinOsc.ar(freqs*(2*click+1), (2pi ! 9).rand, amps/amps.sum) );
	sound = perc * 0.5 * SinOsc.ar(freq*percf, 2pi.rand) * XLine.ar(1,1e-6,2*decay+1) + sound;
	sound = sound + BAllPass.ar(sound, 1000*LFTri.kr(vrate,0,vibrato/2,1));
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

// vibraphone simulator, adapted with some help from Kevin Larke's thesis Real Time Vibraphone Pitch and Timbre Classification
SynthDef(\supervibe, {|out, speed=1, sustain=1, decay=0, pan, freq, accelerate=0, velocity=1,
	modamp=1, modfreq=7.0, detune=0 |
	// most envelope shaping is done with XLines later, this envelope is just to clean up overall
	var env = EnvGen.ar(Env.linen(0.001, 0.998, 0.001), timeScale:sustain, doneAction:2);
	var sound, mod, freqs, hifreqs, decays;
	freqs = freq * Line.kr(1, 1+accelerate, sustain) * [1, 4, 10, 13.75+detune];
	hifreqs = freq * Line.kr(1, 1+accelerate, sustain) * [19.2, 20, 21.2];
	mod = SinOsc.kr(modfreq, Rand(0,2pi)).range(1-([0.5,0.3,0.3,0.5]*modamp),1);
	sound = 0.3 * [1, 1.1*velocity, 0.6*velocity*velocity, 0.5*velocity] * SinOsc.ar(freqs);
	decays = [1, 0.7*exp(-1.0*decay), 0.5*exp(-1.0*decay), 0.4*exp(-1.0*decay)]; // use `decay` to damp harmonics
	sound = XLine.ar(1e-6, 1, 1/freqs) * XLine.ar(1, 1e-6, decays*4*sustain) * sound * mod; // main attacks and decays
	sound = (XLine.ar(0.3*(velocity+1e-6),1e-6,0.02) * SinOsc.ar(hifreqs)).sum + sound.sum; // hi frequency onset
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;


SynthDef(\super303, {|out, speed=1, sustain=1, decay=0, pan, freq, accelerate=0, voice=0.0, slide=0,
	pitch1=1, pitch2=1, pitch3=1, fattack=0, fhold=1, frelease=0, fenv=0, cutoff=10000, resonance=0|
	var env = EnvGen.ar(Env.pairs([[0,0],[0.1,1],[0.2,1-decay],[0.9,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var sound, glide, basefreq, env2, mix;
    //env = EnvGen.ar(Env.perc(0.003, (1-decay)*2, 1, -3), timeScale:sustain, doneAction:2);
	env2= EnvGen.ar(Env.linen(fattack, fhold*sustain, frelease));
	glide = EnvGen.ar(Env.perc(0.05, 0.5, 1, \lin), timeScale:sustain) * (-1*slide/4) + 1;
	basefreq = freq * glide * Line.kr(1, 1+accelerate, sustain);
	//sound = clip(VarSaw.ar(basefreq, 0, 0.98) * (voice*20+1), -1, 1);
	sound = tanh(VarSaw.ar(basefreq, 0, 0.98)*(voice*20+1));
	sound = 3*RLPFD.ar(sound, clip(basefreq*pitch1+(fenv*env2),2,20000), pitch2, pitch3);
	//sound = 3*RLPFD.ar(sound, clip((cutoff*pitch1)+(fenv*env2*pitch2),2,10000), resonance, pitch3);
  sound = LeakDC.ar(sound);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;



SynthDef(\super302, {|out, speed=1, sustain=1, decay=0, pan, freq, accelerate=0, voice=0.0, slide=0,
	pitch1=1, pitch2=1, pitch3=1, sfattack=0, sfrelease=0, sfenv=0, sfcutoff=1000, sfresonance=0, vcfegint=0|
	var sound, glide, basefreq, env, env2, resq, loresq;
	env = EnvGen.ar(Env.new([1e-6,1,(1-decay)*0.5,1e-6], [0.003, 0.9, 0.007], 'exp'), timeScale:sustain, doneAction:2);
	// env2= EnvGen.ar(Env.perc(sfattack, sfrelease, 1, [-4,4]));
	env2 = EnvGen.ar(Env.linen(sfattack, 0, sfrelease));
	glide = EnvGen.ar(Env.perc(0.05, 0.5, 1, \lin), timeScale:sustain) * (-1*slide/4) + 1;
	basefreq = freq * glide * Line.kr(1, 1+accelerate, sustain);
	sound = tanh(VarSaw.ar(basefreq, 0, 0.98)+PinkNoise.ar(0.01*exp(voice))*(voice*50+1));
	resq = 1.0 + (26 * sfresonance);
	// loresq = 1.0 + (26*4.67*sfresonance);
	loresq = 1.0 + (26*sfresonance);
	 sound = BPF.ar(sound, clip(sfcutoff/10*pitch2+(sfenv/10*env2*pitch2), 20,11000), rq:2.9-(2.8*vcfegint));
	// sound = sound * (1.2 + (1.2*vcfegint));
	//sound = RHPF.ar(sound, clip(sfcutoff/100*pitch1+(sfenv/10000*env2*pitch1), 8,8000), rq:1/loresq);
	sound = RLPF.ar(sound, clip(sfcutoff+(sfenv*env2), 20, 11000), rq:1/clip(resq*1000/sfcutoff,1,52));
	//sound = ((sfresonance * sound)**3 + sound) / (max(1,sfresonance)**3);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;


SynthDef(\superbass, {|out, speed=1, sustain=1, decay=0, pan, freq, accelerate=0, voice=0, pitch1=0 |
	var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain) * XLine.ar(3,1,sustain/3);
	var fenv = EnvGen.ar(Env.pairs([[0,0],[0.01,2],[0.2,1.5],[0.8,1],[1,0.9]], -1), levelScale:4*(1+voice), timeScale:sustain, doneAction:2);
	var filterfreq = freq + 100 + (900*pitch1);
	var sound = Pulse.ar(basefreq, Line.kr(0,1,sustain));
	//var sound = Pulse.ar(basefreq, SinOsc.ar(basefreq/4));
	sound = MoogFF.ar(sound, filterfreq * fenv, 3.0);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\supercomb, {|out, speed=1, sustain=1, decay=0, pan, freq, accelerate=0, voice=0 |
	var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain) * SinOsc.ar(freq,0,0.1,1);
	var sound =LFTri.ar(basefreq, 0) * LFTri.ar(basefreq+2, 0.25);
	voice = max(voice, -0.99);
	sound = sound + CombN.ar(sound, 1, 1.01/basefreq, 1) + CombN.ar(sound, 1, (1.00+voice)/basefreq, -0.5);
	sound = MoogFF.ar(sound, XLine.kr(10000, 100/speed, sustain), 1);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\superphase, {|out, speed=1, sustain=1, decay=0, pan, freq, accelerate=0, voice=0 |
	var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var fadj = [0.005, 0.007] * (voice+1) + 1.0;
	var fadj2 = 1.0 - ([0.005, 0.007] * (voice+1));
	var sound = Saw.ar(basefreq*fadj[0]) - DelayC.ar(Saw.ar(basefreq*fadj[1]), 0.2, SinOsc.kr(0.5).range(0.2,0.4)/basefreq);
	var fenv = EnvGen.ar(Env.perc(0.01, 1, 1, -1), timeScale:sustain);
	sound = sound + Saw.ar(basefreq*fadj2[0]) - DelayC.ar(Saw.ar(basefreq*fadj2[1]), 0.2, SinOsc.kr(0.5).range(0.2,0.4)/basefreq);
	sound = sound + PMOsc.ar(basefreq, basefreq*1.01, Line.kr(6.28,0));
	sound = sound - BAllPass.ar(sound, XLine.kr(4400,44,sustain), 2);
	sound = MoogFF.ar(sound/2, fenv*XLine.kr(10000, 500/speed, sustain), 1);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;


SynthDef(\bgongo,{|out, speed=1, begin=0, end=1, pan, freq |
	var dur = (end-begin)/speed;
	var basefreq = freq;
	// lowest modes for free circular plate
	var freqlist =[ 1.000,  2.188,  5.091,  8.529,  8.950,  9.305, 13.746, 14.653, 19.462, 22.003, 24.888, 25.991,
		26.085, 30.509, 33.608, 35.081, 40.125, 42.023, 46.527, 49.481]**1.0;
	var tscale = 100.0 / basefreq / (freqlist**1);
	var ascale = 1.0 / (freqlist**0);
	var sound = Mix.arFill(15, {arg i; EnvGen.ar(Env.perc(0.01*tscale[i], 0.5*tscale[i], 0.5*ascale[i] ), timeScale:dur*5)
		* SinOsc.ar(basefreq * freqlist[i])});
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;

SynthDef(\bgong,{|out, speed=1, begin=0, end=1, pan, accelerate, freq |
	var dur = (end-begin)/speed;
	var env = EnvGen.ar(Env.perc(0.001/speed, 1/speed, 0.5, -4), timeScale:dur, doneAction:2);
	var basefreq = freq;
	var freqlist = [1.0, 3.893, 8.722, 2.081, 5.954, 3.414];
	var sound = Mix.arFill(4, {arg i; XLine.ar(1, 0.01, 10/freqlist[i]**4) * SinOsc.ar(basefreq * freqlist[i])});
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\nonlin, {|out, freq, pan, begin=0, end=1, accelerate, speed|
	var dur = (end-begin)/speed;
	var env = EnvGen.ar(Env.linen(0.01, dur, 0.01, 0.5, -3), timeScale:dur, doneAction:2);
	var source = Decay.ar(Impulse.ar(0), 0.1) * SinOsc.ar(freq);
	var sound = WeaklyNonlinear2.ar(source, 0, 1, 1, freq, 0, 0, -0.001, 3);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\sinelong, { |out, speed=1, sustain=1, pan, accelerate, freq, voice=0, offset |
	var env, sound, dur, basefreq;
	dur = sustain;
	basefreq = freq * speed;
	env = EnvGen.ar(Env.linen(0.02, dur, 0.02, 0.5, -3), timeScale:dur, doneAction:2);
	sound = SinOscFB.ar(basefreq*(1.0+ Sweep.kr(1,accelerate)), voice);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

//Experimental  - not ready
/*SynthDef(\gbk, {|out, begin=0, end=1, speed = 1, sustain = 1 , pan , freq, amp|
  var env, sig,line,envGen;
  freq = (freq.cpsmidi - 12).midicps;
  sig = GbmanL.ar(freq,speed,2.1);
  line = Line.ar(begin, end, sustain, doneAction:2);
  env = Env.linen(0.01, sustain, 0.5, 1, -3);
  envGen = IEnvGen.ar(env, Line.ar(begin * sustain, end * sustain, sustain));
  sig = Latch.ar(PMOsc.ar(
		Line.kr(freq, freq/4, max(0, 0.2 - begin)),(LFNoise1.ar(50).range(0.995, 1.001)),
	   SinOsc.ar(2.5).range(0.995, 1.005)),Saw.ar(21000*envGen));
  sig = LeakDC.ar(sig);
  sig = BHiPass.ar(sig, Lag3.kr(sustain * 2, 0.07), 0.2);
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan));
}).add;*/

SynthDef(\ak, { |out, begin=0, end=1, freq=261.626, noise=0.125, pan, sustain=0.3|
    var drum, btr, env, sound;
    var attack = 0.05, release = 0.95;
    var phase = begin * sustain;
    freq = (freq.cpsmidi - 12).midicps;
    drum = PMOsc.ar(Line.kr(freq, freq/2, max(0, 0.02 - begin)), 6, 6, phase);
    drum = (PMOsc.ar(Line.kr(freq, freq/4, max(0, 0.2 - begin)), 3, 6, phase) / 2) + drum;
    drum = LPF.ar(drum, 1000);
    btr = HPF.ar(WhiteNoise.ar(noise), 500);
    btr = LPF.ar(btr, Line.kr(6000, 500, attack * sustain));
    env = Env.perc(attack * sustain, release * sustain);
    env = IEnvGen.ar(env, Line.ar(begin * sustain, end * sustain, sustain));
    sound = (drum + btr) * env;
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan));
}).add;

SynthDef(\ornament, {|out, sustain=1, pan, speed=1, accelerate, freq, slide=0, pitch1=1, pitch2=1 |
	var env = EnvGen.ar(Env.perc(0.010, 0.9, 1, -3), timeScale:sustain, doneAction:2);
	var sound = VarSaw.ar(freq*Line.kr(1,1+accelerate), 0, Line.kr(0,speed*0.2,sustain), 0.4);
	sound = sound + Formant.ar(freq, XLine.kr(freq*5*pitch1, freq*(10*max(slide,-0.49)+5)*pitch1), pitch2*200, 0.6);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;


SynthDef(\abass, { |out, begin=0, accelerate=1, end=1, freq=261.626, offset, pan, pbend=0.5, pdecay=0.5, sustain=1, wattack=0.01, wrelease=0.8|
    var bass, bass2, env, sound;
    // var rsustain = sustain / absdif(begin, end);
    var rsustain = accelerate / absdif(begin, end);
    pdecay = pdecay * rsustain;
    wattack = wattack * rsustain;
    wrelease = wrelease * rsustain;
    bass = SinOsc.ar(Line.kr(freq, freq * (1-pbend), pdecay));
    bass2 = SinOsc.ar(freq);
    bass = bass + bass2;
    bass = LPF.ar(bass, freq);
    env = Env.linen(wattack, rsustain - wattack - wrelease, wrelease, curve: \sine);
    // env = IEnvGen.ar(env, Line.ar(begin, end, sustain));
    env = IEnvGen.ar(env, Line.ar(begin, end, accelerate));
    sound = bass.tanh * env;
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan));
}).add;

////// IVM ////////
// drum
SynthDef(\dm, { |out, begin= 0 , end = 1, sustain=1, accelerate=0.01, pan, freq=440, voice=0|
  var sig, env, kick, snare, hat;
  var attack = 0.05, release = 0.95;
  var phase = begin * sustain;
  env = Env.perc(attack * sustain, release * sustain);
  env = IEnvGen.ar(env, Line.ar(begin * sustain, end * sustain, sustain));
  kick = XLine.kr(start:freq, end:freq*accelerate, dur:release, mul: sustain, doneAction:2);
  kick = LPF.ar(Ringz.ar(Impulse.ar(1), accelerate, sustain, sustain), 800);
  snare = HPF.ar(WhiteNoise.ar(1), freq);
  hat = RHPF.ar(WhiteNoise.ar(1), (freq+10000), 0.25);
  sig = SelectX.kr(voice, [kick, snare, hat]);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan));
}).add;



///////////////////////////////////////////////////////////////////////////////////////////////////
//// custom effects ////////////////////////////////////////////////////////////////////////////////

// delightfully crunchy
~dirt.addModule('distort', { |dirtEvent| dirtEvent.sendSynth("dirt_distort" ++ ~dirt.numChannels,
			[distort: ~distort, out: ~out])}, { ~distort.notNil});
SynthDef("dirt_distort" ++ ~dirt.numChannels, {|out, distort=0|
	var signal, mod ;
	signal = In.ar(out, ~dirt.numChannels);
	mod = CrossoverDistortion.ar(signal, amp:0.2, smooth:0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000+SinOsc.ar(62,mul:100)],nil,[0.1, 0.1, 0.05, 0.01]], signal));
	mod = (mod.cubed * 8).softclip * 0.5;
	mod = SelectX.ar(distort, [signal, mod]);
	ReplaceOut.ar(out, mod);
}).add;


~dirt.addModule('rectify', { |dirtEvent|
	dirtEvent.sendSynth('dirt_rectify' ++ ~dirt.numChannels,
		[rect: ~rect, rectoff: ~rectoff, out: ~out])}, { ~rect.notNil});
SynthDef("dirt_rectify" ++ numChannels, { |out, rect, rectoff=0 |
	var signal;
	signal = In.ar(out, numChannels);
	ReplaceOut.ar(out, signal.fold(rectoff-rect, rect+rectoff) / rect);
}).add;

~dirt.addModule('wrap', { |dirtEvent|
	dirtEvent.sendSynth('dirt_wrap' ++ ~dirt.numChannels,
		[wrap: ~wrap, wrapoff: ~wrapoff, out: ~out])}, { ~wrap.notNil});
SynthDef("dirt_wrap" ++ numChannels, { |out, wrap, wrapoff=0 |
	var signal;
	signal = In.ar(out, numChannels);
	ReplaceOut.ar(out, signal.wrap(wrapoff-wrap, wrap+wrapoff) / wrap);
}).add;

// not actually a saw anymore, just a "chopper"
~dirt.addModule('envsaw', { |dirtEvent|
	dirtEvent.sendSynth('dirt_envsaw' ++ ~dirt.numChannels,
		[envsaw: ~envsaw, envsawf: ~envsawf, out: ~out])}, { ~envsaw.notNil;});
SynthDef("dirt_envsaw" ++ numChannels, { |out, envsaw, envsawf=10 |
	var signal, mod;
	signal = In.ar(out, numChannels);
	mod = Lag.ar(LFPulse.ar(envsawf, iphase:0, width:0.5), 0.050) * envsaw + 1.0 - envsaw;
	// mod = ((Saw.ar(envsawf) * (-1)) + 1.0) * 0.5 * envsaw + 1.0 - envsaw;
	ReplaceOut.ar(out, signal * mod);
}).add;

// reverb, tails will be cut off
// this is really rough on the CPU if you stack it up, cut things off!
~dirt.addModule('boom', { |dirtEvent| dirtEvent.sendSynth("dirt_boom" ++ ~dirt.numChannels,
			[boom: ~boom, out: ~out])}, { ~boom.notNil});
SynthDef("dirt_boom" ++ ~dirt.numChannels, {|out, boom=0|
	var signal, wet;
	signal = In.ar(out, ~dirt.numChannels);
	wet = JPverb.ar(signal, 0.1, damp:0.5, size:0.5, earlyDiff:1, modDepth:0.7, modFreq:2, low:1, mid:0.1, high:0.1);
	ReplaceOut.ar(out, SelectX.ar(boom, [signal, wet]));
}).add;

// an alternative to boom, might be less CPU-hungry
~dirt.addModule('gboom', { |dirtEvent| dirtEvent.sendSynth("dirt_gboom" ++ ~dirt.numChannels,
			[gboom: ~gboom, out: ~out])}, { ~gboom.notNil});
SynthDef("dirt_gboom" ++ ~dirt.numChannels, {|out, gboom=0|
	var signal, wet;
	signal = In.ar(out, ~dirt.numChannels);
	//wet = (abs(Amplitude.ar(signal, 0.01, 0.1)) > 0.2) * signal;
	wet = (abs(signal) > 0.2) * signal;
	wet = FreeVerb.ar(signal, 1, 0.1, 1);
	ReplaceOut.ar(out, SelectX.ar(gboom, [signal, wet]));
}).add;

// Sonic Pi's krush
// moified a bit so krush "0" is the same as dry signal
~dirt.addModule('krush', { |dirtEvent| dirtEvent.sendSynth("dirt_krush" ++ ~dirt.numChannels,
			[krush: ~krush, kcutoff: ~kcutoff, out: ~out])}, { ~krush.notNil});
SynthDef("dirt_krush" ++ ~dirt.numChannels, {|out, krush, kcutoff|
	var orig, signal, freq;
	freq = Select.kr(kcutoff > 0, [DC.kr(4000), kcutoff]);
	orig = In.ar(out, ~dirt.numChannels);
	signal = (orig.squared + (krush*orig)) / (orig.squared + (orig.abs * (krush-1.0)) + 1.0);
	signal = RLPF.ar(signal, clip(freq, 20, 10000), 1);
	signal = SelectX.ar(krush*2.0, [orig, signal]);
	ReplaceOut.ar(out, signal);
}).add;

// ringmod
~dirt.addModule('ring', { |dirtEvent| dirtEvent.sendSynth("dirt_ring" ++ ~dirt.numChannels,
			[ring: ~ring, ringf: ~ringf, out: ~out])}, { ~ring.notNil});
SynthDef("dirt_ring" ++ ~dirt.numChannels, {|out, ring=0, ringf=0|
	var signal, mod;
	signal = In.ar(out, ~dirt.numChannels);
	mod = ring * SinOsc.ar(clip(ringf, 2, 20000));
	signal = ring1(signal, mod);
	ReplaceOut.ar(out, signal);
}).add;

// Sonic Pi's octaver
~dirt.addModule('octer', { |dirtEvent| dirtEvent.sendSynth("dirt_octer" ++ ~dirt.numChannels,
	[octer: ~octer, octersub: ~octersub, octersubsub: ~octersubsub, out: ~out])},
    { ~octer.notNil or: {~octersub.notNil } or: {~osctersubsub.notNil}});
SynthDef("dirt_octer" ++ ~dirt.numChannels, {|out, octer, octersub, octersubsub|
	var signal, oct1, oct2, oct3, sub;
	signal = In.ar(out, ~dirt.numChannels);
	oct1 = 2.0 * LeakDC.ar( abs(signal) );
	sub = LPF.ar(signal, 440);
	oct2 = ToggleFF.ar(sub);
	oct3 = ToggleFF.ar(oct2);
	signal = SelectX.ar(octer, [signal, octer*oct1, DC.ar(0)]);
	signal = signal + (octersub * oct2 * sub) + (octersubsub * oct3 * sub);
	ReplaceOut.ar(out, signal);
}).add;

// trying a limiter/depopper/shaper
~dirt.addModule('wall', { |dirtEvent| dirtEvent.sendSynth("dirt_wall" ++ ~dirt.numChannels,
			[wall: ~wall, walllev: ~walllev, out: ~out])}, { ~wall.notNil});
SynthDef("dirt_wall" ++ ~dirt.numChannels, {|out, wall=0, walllev=0.5|
	var signal, mod;
	signal = In.ar(out, ~dirt.numChannels);
	mod = signal - signal.clip2(walllev/2+0.5);
	signal = signal.clip2(walllev/2+0.5) + ((1.0-wall)*mod);
	ReplaceOut.ar(out, signal);
}).add;

// add envelope to lpf
~dirt.addModule('lpf',{ |dirtEvent| dirtEvent.sendSynth("dirt_lpf" ++ ~dirt.numChannels,
			[cutoff: ~cutoff, resonance: ~resonance, out: ~out, fattack:~fattack, fhold:~fhold, frelease:~frelease,
		    fenv:~fenv, flfo:~flfo, flfof:~flfof])}, { ~cutoff.notNil });
SynthDef("dirt_lpf" ++ numChannels, { |out, cutoff = 440, resonance = 0, fattack=0, fhold=1, frelease=0, fenv=0, flfo,flfof,sustain|
	var signal = In.ar(out, numChannels);
	var env = Lag.ar(EnvGen.ar(Env.linen(fattack, fhold, frelease, 1, 0)), 0.01);
	var lfo = flfo * SinOsc.kr(flfof,0) + 1;
	// signal = RLPF.ar(signal, clip(cutoff+(env*fenv),2,20000), resonance.linexp(0, 1, 1, 0.001));
	signal = BLowPass4.ar(signal, clip(lfo*(cutoff + (env*fenv)), 2, 20000), resonance.linexp(0,1,1,0.001));
	ReplaceOut.ar(out, signal)
}, [\ir, \ir, \ir]).add;

// delightfully crunchy
~dirt.addModule('distort', { |dirtEvent| dirtEvent.sendSynth("dirt_distort" ++ ~dirt.numChannels,
			[distort: ~distort, out: ~out])}, { ~distort.notNil});
SynthDef("dirt_distort" ++ ~dirt.numChannels, {|out, distort=0|
	var signal, mod ;
	signal = In.ar(out, ~dirt.numChannels);
	mod = CrossoverDistortion.ar(signal, amp:0.2, smooth:0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000+SinOsc.ar(62,mul:100)],nil,[0.1, 0.1, 0.05, 0.01]], signal));
	mod = (mod.cubed * 8).softclip * 0.5;
	mod = SelectX.ar(distort, [signal, mod]);
	ReplaceOut.ar(out, mod);
}).add;

// this compressor is per-voice, so no memory from one sample to the next, would need a global effect for that
~dirt.addModule('comp', { |dirtEvent|
		dirtEvent.sendSynth("dirt_comp" ++ ~dirt.numChannels,
			[comp: ~comp, compa: ~compa, compr: ~compr, out: ~out])},
{ ~comp.notNil});
SynthDef("dirt_comp" ++ ~dirt.numChannels, {|out, comp=0, compa=0, compr=0|
	var signal, mod, inlev, cgain;
	signal = In.ar(out, ~dirt.numChannels);
	inlev = Amplitude.ar(HPF.ar(signal, 600, 1.5), 0.01+compa, 0.02+compr);
	mod = signal / max( inlev, 0.1) * 0.3;
	mod = SelectX.ar(comp, [signal, mod]);
	ReplaceOut.ar(out, mod);
}).add;

// fm with a sine wave
~dirt.addModule('fm', { |dirtEvent|
	dirtEvent.sendSynth('dirt_fm' ++ ~dirt.numChannels,
		[fm: ~fm,	fmf: ~fmf,  out: ~out	]
	)
}, { ~fm.notNil or: { ~fmf.notNil } }); // play synth only if at least one of the two was given
SynthDef("dirt_fm" ++ numChannels, { |out, fm, fmf |
	var signal, mod;
	signal = In.ar(out, numChannels);
	mod = SinOsc.ar(fmf * (1.0 + fm * signal), mul:fm);
	ReplaceOut.ar(out, mod + (1.0-fm)*signal);
}).add;
)

(
s.waitForBoot{
	fork{

		var nummics = 2;
		var g0 = Group.new;
		var g1 = Group.after(g0);
		var micbus = {Bus.audio (s,2)}!nummics;
		var iMicIdx = 2000;

		//SYNTH DEFS ///////////////////
		SynthDef(\micin, {
		arg ich = 0, obs = 0, inamp = 1, gate = 1;

			var source,env;
			env = EnvGen.ar(Env.asr(release:0.08),gate);
			source=SinOsc.ar(440,0,1)*inamp;
			Out.ar(obs,source);

		}).add;


		SynthDef(\amplify, {

			var ibs = 0, obs =0 , amp = 1, gate = 1;
			var sig, env;

			env = EnvGen.ar(Env.asr(release:0.08),gate , doneAction:2);
			sig = In.ar(ibs);
			sig = ibs * env;
			Out.ar(obs,sig*amp);
		}).add;



		//
		// //OSC DEFS ///////////////////////
		// //Seperate OSC practice

		OSCdef(\amplify, {
			arg msg;
			var pl = msg [1].asInteger;
			var mode = msg [2].asInteger;
			var amp = msg [3].asFloat ? 1;

			if(mode == 1,
				{s.sendMsg(\s_new, \amplify, 3000 + pl, 0 , g1.nodeID, \ibs , micbus[pl].index, \obs, micbus[pl].index, \amp, amp)},

				{s.sendMsg(\n_set, 3000 + pl, \gate , 0) }

			);

		}, "/Amplify");


		0.1.wait;

		//Create Mics
		nummics.do {|ix| s.sendMsg(\s_new, \micin, iMicIdx + ix, 0 , g0.nodeID, \ich , ix, \obs, micbus[ix])};




	}//end of fork
} //end of wait for boot
)

n = NetAddr("127.0.0.1",57120);
n.sendMsg("/Amplify", 1,1,1);
n.sendMsg("/Amplify",  0, 0,0.1);

s.queryAllNodes


// Her insan !>SUM GROUP<!

Player
->> Output of Player -> Hem kendi inputuna, hemde diger playerlarin inputuna
->> Input of Player (Summing EMIT) -> Headphone & Ambisonic
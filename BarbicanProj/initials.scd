(
Server.scsynth;


s.options.hardwareBufferSize = 256;//orj
s.options.maxNodes = 2048;
s.options.numWireBufs = 1024;
s.options.memSize = 131072 * 16;
s.options.sampleRate = 44100;
s.options.blockSize = 32;//orjj
s.options.numBuffers = 2048;
s.latency = 0.02;
//s.recSampleFormat = float
//s.options.verbosity = -2;
s.boot;
s.waitForBoot({

	"variables.scd".loadRelative;
	"spat.scd".loadRelative;

	//Routine {5.5.wait;"z-Metronome.scd".loadRelative(action: {"a".speak;})}.play;


});


)

/*
OSCDEF notes:


*/
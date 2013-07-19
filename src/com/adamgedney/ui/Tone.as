package com.adamgedney.ui
	
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	
	public class Tone
	{
		protected const RATE:Number = 44100;
		protected var _position:int = 0;
		protected var _sound:Sound;
		protected var _numSamples:int = 2048;
		public var samples:Vector.<Number>;
		protected var _isPlaying:Boolean = false;
		
		protected var _frequency:Number;
		
		public function Tone(frequency:Number)
		{
			_frequency = frequency;
			_sound = new Sound();
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			samples = new Vector.<Number>();
			createSamples();
			
			
		}
		
		protected function createSamples():void
		{
			var amp:Number = 1.0;
			var i:int = 0;
			var mult:Number = _frequency / RATE * Math.PI * 2;
			while(amp > 0.01)
			{
				samples[i] = Math.sin(i * mult) * amp;
				amp *= 0.9998;
				i++;
			}
			samples.length = i;
		}
		
		public function play():void
		{
			if(!_isPlaying)
			{
				_position = 0;
				
				//uses sound channel from MantissaView for volume manipulation
				MantissaView.sc = _sound.play();
				_isPlaying = true;
			}
		}
		
		public function onSampleData(event:SampleDataEvent):void
		{
			for (var i:int = 0; i < _numSamples; i++)
			{
				if(_position >= samples.length)
				{
					_isPlaying = false;
					return;
				}
				
				//handles effects processor functions
				var processed:Number = processor(samples[_position]);
				
				//writes processed sound bites to speakers
				event.data.writeFloat(processed);
				event.data.writeFloat(processed);
				_position++;
				//trace(processed);
			}
		}
		
		public function set frequency(value:Number):void
		{
			_frequency = value;
			createSamples();
		}
		public function get frequency():Number
		{
			return _frequency;
		}
		
		
		//---------------------------------------------------------------------------
		//added processor function to steal byteArray to send to effects processors
		//---------------------------------------------------------------------------
		private function processor(position:Number):Number{
			var processed:Number = position;
			
			//static var instance of moog, process function run to interupt bitstream
			var moogProcess:Number;
			if(MantissaView.moogKnobValue != 0){
				moogProcess = MantissaView.moog.process(processed);
			}else{
				moogProcess = processed
			}
			//static var instance of LowpassFilter. Process function run to interupt bitstream
			var cutoffProcess:Number = MantissaView.lpf.process(moogProcess);
			
			return cutoffProcess;
		}
	}
}
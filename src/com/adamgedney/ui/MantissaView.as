package com.adamgedney.ui
{
	import com.adamgedney.reusable.ui.KnobRotation;
	import com.adamgedney.reusable.ui.SliderManagerVerticle;
	import com.anttikupila.media.filters.LowpassFilter;
	import com.anttikupila.media.filters.MoogFilter;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class MantissaView extends MantissaBase
	{
		
		public static var pitch:int;
		public static var lpf:LowpassFilter;
		public static var moog:MoogFilter;
		public static var moogKnobValue:uint;
		
		
		private var _tone:Tone;	
		public static var sc:SoundChannel = new SoundChannel();
		public static var st:SoundTransform;
		
		private var _attackSc:SoundChannel = new SoundChannel();
		private var _attackSt:SoundTransform;
		
		private var _position:int = 0;
		private var _mouseCutoff:Boolean;
		private var _playing:Boolean = false;
		private var _stage:Stage;
		
		private var _octaveKnob:KnobRotation;
		private var _octaveKnobValue:uint;
		private var _cutoffKnob:KnobRotation;
		private var _cutoffKnobValue:uint;
		private var _pitchKnob:KnobRotation;
		private var _pitchKnobValue:uint;
		private var _delayKnob:KnobRotation;
		private var _delayKnobValue:uint;		
		private var _moogKnob:KnobRotation;
		
		private var _pitchArray:Array;
		private var _pitchIndex:int = 49;
		
		private var _vSlide:SliderManagerVerticle;
		
		public function MantissaView(stage:Stage)
		{
			super();
			//grabs stage from Main
			_stage = stage;
			
			//listens for reset button click
			mc_reset.addEventListener(MouseEvent.MOUSE_DOWN, reset);
			mc_reset.addEventListener(MouseEvent.MOUSE_UP, resetUP);
			
			//runs program init
			init();
		}
		
		
		private function init():void{
			
			//sets tool tips to 0 alpha
			mc_tips.alpha = 0;
			
			//Enter Frame for realtime slider/knob control
			addEventListener(Event.ENTER_FRAME, update);
			
			//info button
			mc_info.addEventListener(MouseEvent.MOUSE_DOWN, infoButtonDown);
			mc_info.addEventListener(MouseEvent.MOUSE_UP, infoButtonUp);
			
			//controls volume ramp-up to remove attack clicking
			if(_playing){
				for(var i:int=0; i<_tone.samples.length;i++){
					
					//>>shifts i right by one bit creating a range of 1-samples.length instead of 0-samples.length
					var i2: int = i >> 1;
					if(i < i2){
						_attackSt.volume -= 1 / i2;
					}
				}
			}
			
			_attackSt = new SoundTransform();
			_attackSc.soundTransform = _attackSt;
			
			//instantiates lpf, delay, moog(warp)
			lpf = new LowpassFilter();
			moog = new MoogFilter();
			
			//array of pitches
			_pitchArray = [16,17,18,20,21,22,23,25,26,28,29,31,
				33,35,37,39,41,44,46,49,52,55,58,62,
				65,69,73,78,82,87,93,98,104,110,117,124,
				131,139,147,156,165,175,185,196,208,220,233,247,
				262,278,294,311,330,349,370,392,415,440,466,494,
				523,554,587,622,659,699,740,784,831,880,932,988,
				1047,1109,1175,1245,1319,1397,1475,1568,1661,1760,1865,1976,
				2093,2218,2349,2489,2637,2794,2960,3136,3322,3520,3729,3951,
				4186,4435,4699,4978,5274,5588,5920,6272,6645,7040,7459,7902];
			
			//stops animations in clips
			stopAnimations();
			
			//controls knob/slider functionality and values
			knobs();
			sliders();
			
			//listens for key up/ key down
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			
			
		}
		
		
		
		//------------------------------------------------------START Mouse Events-------------------------------
		
		
		private function keyDown(event:KeyboardEvent):void
		{
			/*
			Keyboard mapping directory
			a-65 - c | w-87 - c# | s-83 - d | e-69 - d# | d-68 - e
			f-70 - f | t-84 - f# | g-71 - g | y-89 - g# | h-72 - a
			u-85 - a# | j-74 - b
			*/
			
			if(event.keyCode == 65){
				mc_cKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "C";
				
				//sets pitch according to pitch array index
				pitch = _pitchArray[_pitchIndex];
				
				//plays tone
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 87){
				mc_c1Key.gotoAndStop(2);
				_playing = true;
				tf_note.text = "C#";
				
				pitch = _pitchArray[_pitchIndex + 1];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 83){
				mc_dKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "D";
				
				pitch = _pitchArray[_pitchIndex + 2];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 69){
				mc_d1Key.gotoAndStop(2);
				_playing = true;
				tf_note.text = "D#";
				
				pitch = _pitchArray[_pitchIndex + 3];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 68){
				mc_eKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "E";
				
				pitch = _pitchArray[_pitchIndex + 4];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 70){
				mc_fKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "F";
				
				pitch = _pitchArray[_pitchIndex + 5];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 84){
				mc_f1Key.gotoAndStop(2);
				_playing = true;
				tf_note.text = "F#";
				
				pitch = _pitchArray[_pitchIndex + 6];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 71){
				mc_gKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "G";
				
				pitch = _pitchArray[_pitchIndex + 7];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 89){
				mc_g1Key.gotoAndStop(2);
				_playing = true;
				tf_note.text = "G#";
				
				pitch = _pitchArray[_pitchIndex + 8];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 72){
				mc_aKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "A";
				
				pitch = _pitchArray[_pitchIndex + 9];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 85){
				mc_a1Key.gotoAndStop(2);
				_playing = true;
				tf_note.text = "A#";
				
				pitch = _pitchArray[_pitchIndex + 10];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}if(event.keyCode == 74){
				mc_bKey.gotoAndStop(2);
				_playing = true;
				tf_note.text = "B";
				
				pitch = _pitchArray[_pitchIndex + 11];
				
				_tone = new Tone(pitch);
				_tone.play();
				
			}
		}
		
		//on keyboard key up
		private function keyUp(event:KeyboardEvent):void
		{
			
			if(event.keyCode == 65){
				mc_cKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 87){
				mc_c1Key.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 83){
				mc_dKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 69){
				mc_d1Key.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 68){
				mc_eKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 70){
				mc_fKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 84){
				mc_f1Key.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 71){
				mc_gKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 89){
				mc_g1Key.gotoAndStop(1); 
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 72){
				mc_aKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 85){
				mc_a1Key.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}if(event.keyCode == 74){
				mc_bKey.gotoAndStop(1);
				_playing = false;
				tf_note.text = "";
				
			}	
		}
		
		//------------------------------------------------------END Mouse Events---------------------------------
		
		//stops animations & controls button modes
		private function stopAnimations():void
		{
			mc_cKey.stop();
			mc_c1Key.stop();
			mc_dKey.stop();
			mc_d1Key.stop();
			mc_eKey.stop();
			mc_fKey.stop();
			mc_f1Key.stop();
			mc_gKey.stop();
			mc_g1Key.stop();
			mc_aKey.stop();
			mc_a1Key.stop();
			mc_bKey.stop();
			
			mc_reset.stop();
			mc_reset.buttonMode = true;
			
			
			mc_info.stop();
			mc_info.buttonMode = true;
			mc_info.mouseChildren = false;
			volSlider.mc_handle.buttonMode = true;
			
		}
		
		//instantiates and positions knobs
		private function knobs():void
		{
			var octaveKnobBase:Knob = new Knob();
			addChild(octaveKnobBase);
			octaveKnobBase.x = 135;
			octaveKnobBase.y = 207;
			
			octaveKnobBase.buttonMode = true;
			_octaveKnob = new KnobRotation(octaveKnobBase, _stage, -25);
			
			var cutoffKnobBase:Knob = new Knob();
			addChild(cutoffKnobBase);
			cutoffKnobBase.x = 135;
			cutoffKnobBase.y = 39;
			
			cutoffKnobBase.buttonMode = true;
			_cutoffKnob = new KnobRotation(cutoffKnobBase, _stage);
			
			var pitchKnobBase:Knob = new Knob();
			addChild(pitchKnobBase);
			pitchKnobBase.x = 211;
			pitchKnobBase.y = 38;
			
			pitchKnobBase.buttonMode = true;
			_pitchKnob = new KnobRotation(pitchKnobBase, _stage);
			
			//warp knob
			var moogKnobBase:Knob = new Knob();
			addChild(moogKnobBase);
			moogKnobBase.x = 290;
			moogKnobBase.y = 39;
			
			moogKnobBase.buttonMode = true;
			_moogKnob = new KnobRotation(moogKnobBase, _stage);
			
		}
		
		//instantiates sliders
		private function sliders():void
		{
			_vSlide = new SliderManagerVerticle();
			_vSlide.setUpAssets(volSlider.mc_track, volSlider.mc_handle);
			_vSlide.setPercent(.2);
			
		}
		
		public function update(event:Event):void{
			
			_octaveKnobValue = uint(_octaveKnob.getValue());
			//controls octave value via knob in ui
			octaveConditions();
			
			_cutoffKnobValue = uint(_cutoffKnob.getValue());
			if(_cutoffKnobValue != 0){
				lpf.cutoffFrequency = _cutoffKnobValue * 100;
			}
			
			_pitchKnobValue = uint(_pitchKnob.getValue());
			if(_pitchKnobValue != 0){
				
				_pitchIndex = Math.random() * 59 + 37;
				//trace(_pitchIndex);
			}
			
			//Warp knob
			moogKnobValue = uint(_moogKnob.getValue());
			moog.cutoffFrequency = moogKnobValue * 50;
			
			
			
			volumeSlider(int(_vSlide.getPCT())/10);
			
			//trace(int(_vSlide.getPCT())/10);
		}
		
		//info button mouse down
		private function infoButtonDown(event:MouseEvent):void
		{
			mc_info.gotoAndStop(2);
			mc_tips.alpha = 1;
		}
		
		//info button mouse up
		private function infoButtonUp(event:MouseEvent):void
		{
			mc_info.gotoAndStop(1);
			mc_tips.alpha = 0;
		}
		
		//volume slider functionality
		private function volumeSlider(vol:Number=0.5):void
		{
			if(vol > 1 || vol == 0){
				vol = 1;
			}if(vol == .1){
				vol = 0;
			}
			
			st = new SoundTransform();
			st.volume = vol;
			sc.soundTransform = st;
		}
		
		//handles octave knob conditionals for array position pitch adjustments
		private function octaveConditions():void
		{
			if(_octaveKnobValue == 1 || _octaveKnobValue == 2){
				_pitchIndex = 25;
			}if(_octaveKnobValue == 3){
				_pitchIndex = 37;
			}if(_octaveKnobValue == 4){
				_pitchIndex = 49;
			}if(_octaveKnobValue == 5){
				_pitchIndex = 61;
			}if(_octaveKnobValue == 6){
				_pitchIndex = 73;
			}if(_octaveKnobValue == 7){
				_pitchIndex = 85;
			}if(_octaveKnobValue == 8){
				_pitchIndex = 85;
			}if(_octaveKnobValue == 9){
				_pitchIndex = 85;
			}if(_octaveKnobValue == 10){
				_pitchIndex = 85;
			}
		}	
		
		//handles reset button mouse up
		private function resetUP(event:MouseEvent):void
		{
			mc_reset.gotoAndStop(1);
		}
		
		//reset functions
		private function reset(event:MouseEvent):void
		{
			mc_reset.gotoAndStop(2);
			
			removeEventListener(Event.ENTER_FRAME, update);
			_pitchIndex = 37;
			
			init();
			
		}
		
	}
}
function make_slides(f) {
  var   slides = {};

  slides.i0 = slide({
     name : "i0",
     start : function() {
      exp.startT = Date.now();
     }
  });

  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });
  
  slides.pretrial = slide({
    name : "pretrial",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });
  
    slides.one_slider_practice = slide({
    name : "one_slider_practice",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
	  

	present : [
		{source: '<source src = "../_shared/images/PS1.mp4" <type="video/mp4"></source>'},
		{source: '<source src = "../_shared/images/PS2.mp4" <type="video/mp4"></source>'},
	],

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
		$("#p_justification").val('');
		$(".p_err").hide();
		$(".p_hidden").hide();
		$(".p_jerr").hide();

		this.stim = stim; //I like to store this information in the slide so I can record it later.


      $("#practiceVideo").html(stim.source);
	  $("#practiceVideo").load();
	  document.getElementById("practiceVideo").onended = function() {right()};
		function right() {
			$(".p_hidden").show()
		
		}
      this.init_sliders();
      exp.sliderPost = null;	  //erase current slider value
	  
    },
	
	    button : function() {
		if (exp.sliderPost == null) {
			$(".p_err").show();
		} else {
			var chatinput = document.getElementById("p_justification").value;
			if (chatinput == "" || chatinput.length == 0 || chatinput == null) {
				$(".p_err").hide();
				$(".p_jerr").show();
			} else {
				this.log_responses();

					/* use _stream.apply(this); if and only if there is
					"present" data. (and only *after* responses are logged) */
					_stream.apply(this);
			}
		}
    },

    init_sliders : function() {
      utils.make_slider("#prac_single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        "trial_type" : "one_slider_practice",
        "response" : exp.sliderPost,
		"justification" : $("#p_justification").val(),
		//put condition here as well
      });
    }
  });
  
  


  slides.one_slider = slide({
    name : "one_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
	  
	  //exp_condition = _.sample(["cond1", "cond2", "cond3", "cond4"])
	  

	present : [
		{cond1: '<source src = "../_shared/images/TNTwo1.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/2frogscontrast.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/4frogs.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/4frogscontrast.mp4" <type="video/mp4"></source>'},
		{cond1: '<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>'},
		{cond1: '<source src = "../_shared/images/TNTwo2.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/2butterflycontrast.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/4butterflies.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/4butterflycontrast.mp4" <type="video/mp4"></source>'},
		{cond1: '<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>'},
		{cond1: '<source src = "../_shared/images/TNTwo3.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/2lionscontrast.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/4lions.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/4lionscontrast.mp4" <type="video/mp4"></source>'},
		{cond1: '<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>'},
		{cond1: '<source src = "../_shared/images/TNTwo4.mp4" <type="video/mp4"></source>', cond2: '<source src = "../_shared/images/2dinoscontrast.mp4" <type="video/mp4"></source>', cond3: '<source src = "../_shared/images/4dinos.mp4" <type="video/mp4"></source>', cond4: '<source src = "../_shared/images/4dinoscontrast.mp4" <type="video/mp4"></source>'},
	],

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
		$("#justification").val('');
		$(".err").hide();
		$(".hidden").hide();
		$(".jerr").hide();
		$(".text_response").val('');

		this.stim = stim; //I like to store this information in the slide so I can record it later.

	    exp.condition = _.sample(["cond1", "cond2", "cond3", "cond4"]);

      $("#expVideo").html(stim[exp.condition]);
	  $("#expVideo").load();
	  document.getElementById("expVideo").onended = function() {right()};
		function right() {
			$(".hidden").show()
		
		}
      this.init_sliders();
      exp.sliderPost = null;	  //erase current slider value
	  
    },
	
/* 	$("#play").click(function() {
		  var myVideo = document.getElementById("expVideo"); 
			function playPause() { 
				if (myVideo.paused) 
					myVideo.play(); 
				else 
					myVideo.pause(); 
			} 
	}); */

    button : function() {
		if (exp.sliderPost == null) {
			$(".err").show();
		} else {
			var chatinput = document.getElementById("justification").value;
			if (chatinput == "" || chatinput.length == 0 || chatinput == null) {
				$(".err").hide();
				$(".jerr").show();
			} else {
				this.log_responses();

					/* use _stream.apply(this); if and only if there is
					"present" data. (and only *after* responses are logged) */
					_stream.apply(this);
			}
		}
    },

    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        "trial_type" : "one_slider",
        "response" : exp.sliderPost,
		"justification" : $("#justification").val(),
		"condition" : exp.condition,
      });
    }
  });
  

 

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
		selfreport : $("#selfreport").val(),
        comments : $("#comments").val(),
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "condition" : exp.condition,
		  "justification" : exp.justify,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
  exp.trials = [];
  exp.catch_trials = [];
  //exp.condition = _.sample(["Cond 1"]); //can randomize between subject conditions here
  //exp.condition = _.sample(["Cond 1, Cond 2, Cond 3, Cond 4"]); //can randomize between subject conditions here
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width,
    };
  //blocks of the experiment:
  exp.structure=["i0", "instructions", "one_slider_practice", "pretrial", "one_slider", 'subj_info', 'thanks'];
  
  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);
	
	//exp.nQs = 2;
  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}

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
		{practice: {video: '/<source src = "../_shared/images/PS1.mp4" <type="video/mp4"></source>', sentence: "\"The smurf bought two cars.\""}},
		{practice: {video: '/<source src = "../_shared/images/PS2.mp4" <type="video/mp4"></source>', sentence: "\"All dogs jumped on the table.\""}},
	],

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
		$("#p_justification").val('');
		$(".p_err").hide();
		$(".p_hidden").hide();
		$(".p_jerr").hide();
		$(".text_response").val('');

		this.stim = stim; //I like to store this information in the slide so I can record it later.
		
		$("#practiceSentence").html(stim["practice"]["sentence"]);
		$("#practiceVideo").html(stim["practice"]["video"]);
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

  present : [
    {twowithout: {video: '/<source src = "../_shared/images/2frogs.mp4" <type="video/mp4"></source>', sentence: "\"Two frogs didn't jump over the rock.\"", item: "frog"}, twowith: {video: '/<source src = "../_shared/images/2frogscontrast.mp4" <type="video/mp4"></source>', sentence: "\"Two frogs jumped over the fence, but two frogs didn't jump over the rock.\"", item: "frog"}, fourwithout: {video: '/<source src = "../_shared/images/4frogs.mp4" <type="video/mp4"></source>', sentence: "\"Two frogs didn't jump over the rock.\"", item: "frog"}, fourwith: {video: '/<source src = "../_shared/images/4frogscontrast.mp4" <type="video/mp4"></source>', sentence: "\"Four frogs jumped over the fence, but two frogs didn't jump over the rock.\"", item: "frog"}},
	{twowithout: {video: '/<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', sentence: "\"Three hippos drank milk.\"", item: "control1"}, twowith: {video: '/<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', sentence: "\"Three hippos drank milk.\"", item: "control1"}, fourwithout: {video: '/<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', sentence: "\"Three hippos drank milk.\"", item: "control1"}, fourwith: {video: '/<source src = "../_shared/images/CS1.mp4" <type="video/mp4"></source>', sentence: "\"Three hippos drank milk.\"", item: "control1"}},
	{twowithout: {video: '/<source src = "../_shared/images/2butterflies.mp4" <type="video/mp4"></source>', sentence: "\"Two butterflies didn't go to the city.\"", item: "butterflies"}, twowith: {video: '/<source src = "../_shared/images/2butterfliescontrast.mp4" <type="video/mp4"></source>', sentence: "\"Two butterflies went to the forest, but two butterflies didn't go to the city.\"", item: "butterflies"}, fourwithout: {video: '/<source src = "../_shared/images/4butterflies.mp4" <type="video/mp4"></source>', sentence: "\"Two butterflies didn't go to the city.\"", item: "butterflies"}, fourwith: {video: '/<source src = "../_shared/images/4butterfliescontrast.mp4" <type="video/mp4"></source>', sentence: "\"Four butterflies went to the forest, but two butterflies didn't go to the city.\"", item: "butterflies"}},
	{twowithout: {video: '/<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', sentence: "\"Only one dog rolled his ball.\"", item: "control2"}, twowith: {video: '/<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', sentence: "\"Only one dog rolled his ball.\"", item: "control2"}, fourwithout: {video: '/<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', sentence: "\"Only one dog rolled his ball.\"", item: "control2"}, fourwith: {video: '/<source src = "../_shared/images/CS2.mp4" <type="video/mp4"></source>', sentence: "\"Only one dog rolled his ball.\"", item: "control2"}},
	{twowithout: {video: '/<source src = "../_shared/images/2lions.mp4" <type="video/mp4"></source>', sentence: "\"Two lions didn't buy a cookie.\"", item: "lions"}, twowith: {video: '/<source src = "../_shared/images/2lionscontrast.mp4" <type="video/mp4"></source>', sentence: "\"Two lions bought an egg, but two lions didn't buy a cookie.\"", item: "lions"}, fourwithout: {video: '/<source src = "../_shared/images/4lions.mp4" <type="video/mp4"></source>', sentence: "\"Two lions didn't buy a cookie\"", item: "lions"}, fourwith: {video: '/<source src = "../_shared/images/4lionscontrast.mp4" <type="video/mp4"></source>', sentence: "\"Four lions bought an egg, but two lions didn't buy a cookie.\"", item: "lions"}},
	{twowithout: {video: '/<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', sentence: "\"Four lizards climbed on the book.\"", item: "control3"}, twowith: {video: '/<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', sentence: "\"Four lizards climbed on the book.\"", item: "control3"}, fourwithout: {video: '/<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', sentence: "\"Four lizards climbed on the book.\"", item: "control3"}, fourwith: {video: '/<source src = "../_shared/images/CS3.mp4" <type="video/mp4"></source>', sentence: "\"Four lizards climbed on the book.\"", item: "control3"}},
	{twowithout: {video: '/<source src = "../_shared/images/2dinosaurs.mp4" <type="video/mp4"></source>', sentence: "\"Two dinosaurs didn't eat bugs.\"", item: "dinosaurs"}, twowith: {video: '/<source src = "../_shared/images/2dinosaurscontrast.mp4" <type="video/mp4"></source>', sentence: "\"Two dinosaurs ate fish, but two dinosaurs didn't eat bugs.\"", item: "dinosaurs"}, fourwithout: {video: '/<source src = "../_shared/images/4dinosaurs.mp4" <type="video/mp4"></source>', sentence: "\"Two dinosaurs didn't eat bugs.\"", item: "dinosaurs"}, fourwith: {video: '/<source src = "../_shared/images/4dinosaurscontrast.mp4" <type="video/mp4"></source>', sentence: "\"Four dinosaurs ate fish, but two dinosaurs didn't eat bugs.\"", item: "dinosaurs"}},
	
  ],

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
		$("#justification").val('');
		$(".err").hide();
		$(".hidden").hide();
		$(".jerr").hide();
		$(".text_response").val('');

		this.stim = stim; //I like to store this information in the slide so I can record it later.

      exp.context = _.sample(["with","without"]);
      exp.number = _.sample(["two","four"]);
	  //exp.number = _.sample(["two"]);

      exp.condition = exp.number + exp.context

      exp.item = stim[exp.condition]["item"]

      $("#testSentence").html(stim[exp.condition]["sentence"])

      $("#expVideo").html(stim[exp.condition]["video"]);
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
		"number" : exp.number,
    "context" : exp.context,
    "item" : exp.item,
    "slide_number" : exp.phase

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
        assess : $('input[name="assess"]:checked').val(),
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
  repeatWorker = false;
  (function(){
      var ut_id = "scopeTVJT-fixed";
      if (UTWorkerLimitReached(ut_id)) {
        $('.slide').empty();
        repeatWorker = true;
        alert("You have already completed the maximum number of HITs allowed by this requester. Please click 'Return HIT' to avoid any impact on your approval rating.");
      }
  })();

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

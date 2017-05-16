// var testflip = function() {
//   return flip(.8)
// }

// viz.auto(repeat(100, function () {testflip()}))

// //Individuals and their chances (Prior jump belief)
// var indiv = {
//   "Frogs": ["Pablo", "Juan", "Paco", "Brian"],
//   "Probs": [.5, .5, .5, .5]
// }

var frogs = ["Pablo", "Juan", "Paco", "Brian"]
var Probs = [.5, .5, .5, .5]

var statePrior = function() {
  var Pablo = flip(Probs[0])
  var Juan = flip(Probs[1])
  var Paco = flip(Probs[2])
  var Brian = flip(Probs[3])
  
  return{"Pablo": Pablo,
        "Juan": Juan,
        "Paco": Paco,
        "Brian": Brian}
}

// possible utterances
var utterances = ["null","every-not"];

var utterancePrior = function() {
  uniformDraw(utterances)
}

//possible scopes
var scopePrior = function(){ 
  return uniformDraw(["surface", "inverse"])
}

//specific reading or total reading (2 specific frogs, or 2 total frogs)
var specPrior = function(){
  return uniformDraw(["specific","total"])
}

var totalFrogs = function() {
    Infer({model: function(){
    var state = statePrior();
    return state;
    }})
}

totalFrogs()


// //Doesn't work with viz.auto (or anything?)
// viz.auto(repeat(1000, function() {statePrior()}))

// // tally up the state
// var totState = function(state) {
//   var fun = function(x) {
//     x ? 1 : 0
//   }
//   return sum(map(fun,state))
// }
// ///


// //world state
// var statePrior = function(frogs,prob) {
//   Infer({model: function(){
//   var frogs = indiv.Frogs
//   var prob = indiv.Probs
//   var success = flip(prob)
//   return {success: success}
// }})
// }


// indiv
// viz.hist(repeat(1000, function() {statePrior()}))
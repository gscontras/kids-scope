// Here is the code for the quantifier scope model

// wrapper function so the global variables can be set up before each run
var runModel = function(utterances, numParticipants, baseRate,
                        unitSize, 
                        exactMeaning,
                         scopes, scopePriorDist,
                         QUDs,
                        QUDPrior_makeUnits, QUDPrior_noMakeUnits,
                        makeUnits_baseRate, 
                        makeUnits_baseRate_sameSize,
                        pragSpeakerState){

var utterancePrior = function() {
  uniformDraw(utterances)
}

/////// world state functions /////////////
// recursive function that flips based on base rate to determine which
//    individuals were successful
var makeSuccesses = function(numParticipants, baseRate){
  // if numParticipants == 1, return the empty set or [numParticipants]
  // based on flip
  if(numParticipants == 1){
    if(flip(baseRate)){
      return [numParticipants]
    }else{
      return []
    }
  }// flip this one and concatenate it to results of doing so for one participant less
  else{
    if(flip(baseRate)){
      // success for this participant
      return sort([numParticipants].concat(makeSuccesses(numParticipants-1, baseRate)))
    }else{
      return makeSuccesses(numParticipants-1, baseRate)
    }
  }
}
                      
// sanity check for making states
//print(makeSuccesses(4,0.5))

// getInverseHelper
// input: non-empty list (ex: successes = [1,2])
//        and non-empty list of individuals in world (ex: [1,2,3,4])
// removes each success individual from individuals list until no more successes
var getInverseHelper = function(toFind, individuals){
  // if toFind.length == 1, remove that element from individuals and then return
  if(toFind.length == 1){
    return remove(toFind[0], individuals);
  }
  // else remove first element of toFind from individuals and from toFind
  //   and then recurse on new smaller toFind and new smaller individuals
  else{
    return getInverseHelper(remove(toFind[0], toFind),  // toFind w/o first elem
                            remove(toFind[0], individuals)) // individuals w/o toFind[0]
  }
}

// main function for getting inverse of list, based on numParticipants in world
// used for getting failures from list of successes
var getInverse = function(successes, numParticipants){
    // explicitly list out each participant with a number (e.g., [1,2,3,4])
  var participants = mapN(function(x) { return x + 1; }, numParticipants);
  // check first to see if successes.length == 0; if so, inverse = whole list
  if(successes.length == 0){
    return participants;
  }
  // else check to see if successes.length == numParticipants; if so, inverse = empty
  else if(successes.length == numParticipants){
    return [];
  }else{
  // else call helper function to get inverse individuals
    return getInverseHelper(successes, participants);
  }
}

//// sanity check for getInverse
// print("getInverse on successes [1] for numParticipants = " + numParticipants);
// print(getInverse([1], numParticipants))
  

// state builder: needs to know 
//                (1) how many particants (numParticipants), 
//                (2) base rate of success (baseRate)
// returns: states = {successes: [list of success individuals], 
//                    failures: [list of failure individuals]}
var statePrior = function(numParticipants, baseRate) {
// always return the collection -- can get length alone later on if needed
  //return makeSuccesses(numParticipants, baseRate);
  var successes = makeSuccesses(numParticipants, baseRate);
  return {
    successes: successes,
    failures: getInverse(successes, numParticipants)
  }
}

// sanity check on state prior
//print(statePrior(4, 0.5))
//////////// end world state generation

/// sanity check for statePrior with makeUnits option
//var makeUnits = true;
//var unitSize = 2;
//print(statePrior(makeUnits, unitSize))
////////// end state prior ////////////

//////// Units: what happens if we want to make units of size unit_size 
//////// making units: helper functions /////////
// recursive sampleUnit 
var recursiveSampleUnit = function(unit_size, list, unit){
  //print("list is currently: " + list)
  // if unit == unit_size, return unit
  if (unit.length == unit_size){
    //print("unit is size unit_size")
    return unit;
  }else{
    // else sample an element from the list
    // remove from list and add to unit
    // recursiveSampleUnit(unit_size, updated_list, updated_unit)
    var sampledElem = uniformDraw(list);
    //print("sampledElem: " + sampledElem);
    var smallerList = remove(sampledElem, list)
    //print("list without sampledElem: " + smallerList)
    var new_unit = unit.concat([sampledElem]);
    //print("unit is now " + new_unit)
    return recursiveSampleUnit(unit_size, smallerList, new_unit);
  }
}

// creates unit of size unit_size from list, 
//     creating unit = list of elements from original list
var sampleUnit = function(unit_size, list, unit){
  // if list < unit_size, not possible so return []
  if(list.length < unit_size){
    return [];
  }
  // elsif list = unit_size, then return list and don't bother with recursion
    else if(list.length == unit_size){
    return list;    
  }
  // else list > unit_size, so sample unit_size elements from list  
  else{
    return recursiveSampleUnit(unit_size, list, []);
  }
}


// implement n choose unit_size to get combinations of unit_size-frog units,
//    where each number stands for an individual frog
// return: list of concatenated units of size unit_size from all
//         possible combinations
var unitize = cache(function(unit_size, list){
  Infer({method:"enumerate"}, function(){
    // call function to return a unique unit of size unit_size
    var unit = sampleUnit(unit_size, list, [])
    //print("in unitize, unit = " + unit)
    // don't care about order of elements in units 
    //(e.g., [1,2] unit = [2,1] unit), 
    //so sort first
    return sort(unit)
  }
       )
})

// sanity check to make sure unitize works
//viz.table(unitize(2, [1,2,3,4]))

////////////// end making units //////////////

///////// how to get a draw from the collection of unitSize units ///////////
// need to know unitSize and give list of possible participants
var unitPrior = function(unitSize, numParticipants){
  // explicitly list out each participant with a number (e.g., [1,2,3,4])
  var participants = mapN(function(x) { return x + 1; }, numParticipants);
  var unitStates = unitize(unitSize, participants); // make your units
   // uniform over possible units succeeding (e.g., [1,2] = unit [1,2] succeeded)
   // .supp gives back the elements from Inference, and not the probabilities
    return uniformDraw(unitStates.supp);  
}
 
// sanity check for unit prior
//print(unitPrior(2, 4))

/////////// scopePrior: possible scopes /////////
var scopePrior = function(){ 
  // based on scopePriorDist
   return categorical({vs: scopes, 
                       ps: scopePriorDist}); 
}
////////////////////////

// sanity check on scope prior
//print(scopePrior());


///// helper function for unit-based meaning function calculation
// takes two lists (unit and state) and determines if all the elements
// of the first list (unit) are in the second list (state)
// --> go through each element in first list and find it in second list
// returns boolean
var findFirstInSecondList = function(list1, list2){
  // if only 1 element in list1, find in list 2
  if(list1.length == 1){
    //typeof myVar != 'undefined' is how to check for undefined return
    if(typeof (find(function(x) { return x == list1[0]; }, list2)) == 'undefined'){
      return false;
    }else{
      return true;
    }
  }else{
  // else remove first element in list1
    var elem0 = list1[0];
    var shorterList = remove(elem0, list1);
     // and find in list2
    if(typeof (find(function(x) { return x == list1[0]; }, list2)) != 'undefined'){ 
     // if present, continue with remaining elements in list1
      findFirstInSecondList(shorterList, list2);
     // else return false
    }else{
      return false;
    }
  }
}

// sanity check for helper function
//print(findFirstInSecondList([2,3,5],[1,2,3,4,5]))

/////////// meaning function used by literal listener ///////
// meaning function: include numParticipants var, 
// since this impacts the surface scope reading calculation
// for units: need makeUnits boolean and unit to search for
// condition on exactMeaning
var meaning = function(utterance, state, scope, 
                        numParticipants, makeUnits, unit) {
  if(utterance == "two-not"){
    if(makeUnits){ // assess by unit
      // scope doesn't matter -- all that matters is whether 
      // the unit was unsuccessful (= in state.failures)
      if(exactMeaning){
        // need failures to be unit
        // debug
//         print("debug, meaning: checking if unit " + unit)
//         print(" is equivalent to state[\"failures\"] " + state["failures"]);
//         print((findFirstInSecondList(unit, state["failures"]) 
//                && state["failures"].length == unitSize));
        return (findFirstInSecondList(unit, state["failures"]) 
              && state["failures"].length == unitSize);
      }else{
        // e.g., unit [1,2] for state failures = [1, 2, 3] = true
        return findFirstInSecondList(unit, state["failures"]);
      }
    }else{ // no units -- just total count, where scope matters
      // working with state.length to get total count
      if(scope == "surface"){ //there are two who didn't
        // Update so doing verification on failure state
        if(exactMeaning){
          // looking for exactly two failures
          return (state["failures"].length == 2);
        }else{
        //   Specifically, looking for failures >= 2 individuals
        return (state["failures"].length >= 2); 
        }
      }else{ // it's not true that two did
        // verification on successes
        if(exactMeaning){
          return (state["successes"].length != 2);
        }else{
          //  < 2 individuals
          return (state["successes"].length < 2)
        }
      }
    }
  }else{
    // null utterance: fall back on prior 
    return true;
  }
};

// testing the meaning function
// var test_utt = "two-not";
// var test_state = {
//   successes: [1,2], 
//   failures: [3,4]
// };
// var test_scope = "inverse";
// var test_numParticipants = 4;
// var test_makeUnits = true;
// var test_unit = [3,4];
// var meaning_check = meaning(test_utt, test_state, test_scope, 
//                             test_numParticipants, test_makeUnits, test_unit);
// print("meaning check with participant num " + test_numParticipants) 
// print( "with utterance " + test_utt)
// print(" in state with successes " + test_state["successes"])
// print(" and failures "+ test_state["failures"])
// print(" with scope reading " + test_scope)
// print(" when make_units is " + test_makeUnits)
// print(" and test_unit is " + test_unit)
// print(meaning_check)
//////// end meaning function used by literal listener //////////


///////////// QUDs ////////////////////
// "how many?", "all?", "none?", "this unit?", "not this unit?"
// TO DO: adjust QUD prior to be based on makeUnits value
var QUDPrior = function(makeUnits) {
  //uniformDraw(QUDs); - old one doing uniform draw
  // if makeUnits, biased towards unit QUDs ("this unit?", "not this unit?")
  if(makeUnits){
    // 0.10 divided between non-unit, 0.90 divided between unit
    categorical({vs: QUDs, 
                 ps: QUDPrior_makeUnits}); 
  }else{   // else, biased towards non-unit QUDS ("all?", "none?", "how many?")
    // 0.90 divided between non-unit, 0.10 divided between unit
    categorical({vs: QUDs, 
                 ps: QUDPrior_noMakeUnits});
  }
}

// sanity check on the QUDprior
// print("QUDs are: ")
// print(QUDs);
// print("Draw one when makeUnits = true");
// print(QUDPrior(true));

// "how many?", "all?", "none?", "this unit?", "not this unit?"
var QUDFun = function(QUD,state,numParticipants, unit) {
  if(QUD == "all?"){ // boolean
    return state["successes"].length == numParticipants;
  }else if(QUD == "none?"){ // boolean
    return state["successes"].length == 0;
  }else if(QUD == "how many?"){ // number successes
    return state["successes"].length;
  }else if(QUD == "two fail?"){
    return state["failures"].length == 2;
  }else if(QUD == "two succeed?"){
    return state["successes"].length == 2;
  }else if(QUD == "this unit?"){ //  boolean (Did this unit succeed?)
    return findFirstInSecondList(unit, state["successes"]);
  }else if(QUD == "not this unit?"){ // boolean (Did this unit fail?)
    return findFirstInSecondList(unit, state["failures"]);
  }
};

// QUD sanity check
//print(QUDFun("this unit?", {"successes": [1,2,4], "failures": [3]}, 4, [1,2]))
///////// end QUD stuff /////////////

// Literal listener (L0)
var literalListener = cache(function(utterance,scope,QUD,makeUnits) {
  Infer({model: function(){
    var state = statePrior(numParticipants, baseRate);
    //print("literalListener, state = " + state)
    // if makeUnits, need to draw a unit and feed that to the qState
    if(makeUnits){
      var unit = unitPrior(unitSize, numParticipants);
      //print("literalListener: unit = " + unit)
      var qState = QUDFun(QUD,state, numParticipants, unit);
      //print("literalListener, qState = " + qState)
      //print("literalListener, meaning = " + meaning(utterance,state,scope,
       //                 numParticipants,makeUnits,unit))
      //print("***")
      condition(meaning(utterance,state,scope,
                        numParticipants,makeUnits,unit));
      return qState;
    }else{
      var qState = QUDFun(QUD,state, numParticipants, []);
      //print("literalListener, qState = " + qState)
      //print("literalListener, meaning = " + meaning(utterance,state,scope,
       //                 numParticipants,makeUnits,[]))
      condition(meaning(utterance,state,scope,
                        numParticipants,makeUnits,[]));
      return qState;
    }
  }});
});

// sanity check for literal listener
//viz.auto(literalListener("two-not", "inverse", "this unit?", true));

var alpha_S1 = 2.5

// Speaker (S)
var speaker = cache(function(scope,state,QUD,makeUnits,unit) {
  Infer({model: function(){
    var utterance = utterancePrior();
    if(makeUnits){
      var qState = QUDFun(QUD,state,numParticipants,unit);
      factor(alpha_S1 * literalListener(utterance,scope,QUD,makeUnits).score(qState));
      return utterance;
    }else{
      var qState = QUDFun(QUD,state,numParticipants,[]);
      factor(alpha_S1 * literalListener(utterance,scope,QUD,makeUnits).score(qState));
      return utterance;        
    }
  }});
});

// sanity check for speaker S1
//viz.auto(speaker("surface", [1,3,4], "not this unit?", true, [1,2]))

// helper function to return correct makeUnits value
var getMakeUnits = function(){
  //check to see if numParticipants == unitSize  
  if(numParticipants == unitSize){
    // if so, use special prior for makeUnits: makeUnits_baseRate_sameSize
    return flip(makeUnits_baseRate_sameSize);
  }else{
    // else makeUnits inferred based on makeUnits_baseRate
    return flip(makeUnits_baseRate);
  }
}

// sanity check on getMakeUnits
// print("numParticipants: " + numParticipants + ", unitSize = " + unitSize);
// print(getMakeUnits());
  
// Pragmatic listener (L1)
// get utterance, and infer everything else:
//   scope, state, QUD, makeUnits, unit
var pragmaticListener = cache(function(utterance) {
  Infer({model: function(){
    var scope = scopePrior();
    // numParticipants and baseRate of success globally set
    var state = statePrior(numParticipants, baseRate); 
    // get makeUnits
    var makeUnits = getMakeUnits();
    var QUD = QUDPrior(makeUnits); // QUDs depend on whether makeUnits
    // if makeUnits, unit sampled; 
    if(makeUnits){ // makeUnits reading
      // unitSize, numParticipants already set globally
      var unit = unitPrior(unitSize, numParticipants);
      factor(speaker(scope,state,QUD,makeUnits,unit).score(utterance));
      //observe(speaker(scope,state,QUD),utterance);
      //return {state: state.length, makeUnits: makeUnits};
      return state;
    }else{ // not making units, so unit is empty list
      factor(speaker(scope,state,QUD,makeUnits,[]).score(utterance));
      //return {state: state.length, makeUnits: makeUnits};
      return state;
    }
  }});
});

// sanity check for pragmaticListener
//viz(pragmaticListener("two-not"))

var alpha_S2 = 1 // optimality of pragmatic speaker

// Pragmatic speaker (S2)
// takes in state, and decides whether to endorse utterance,
//   given all possibilities of scope, state, QUD, makeUnits, and unit
var pragmaticSpeaker = cache(function(state) {
  Infer({model: function(){
    var utterance = utterancePrior();
    factor(alpha_S2 * pragmaticListener(utterance).score(state))
    return utterance
  }})
})

// now run pragmatic speaker
print("num of participants: " + numParticipants)
print("in world with successes = " + pragSpeakerState["successes"])
print(" and failures = " + pragSpeakerState["failures"])
viz.table(pragmaticSpeaker(pragSpeakerState))
pragmaticSpeaker(pragSpeakerState)

} // end runModel wrapper function

// global variables for runModel
var utterances = ["null","two-not"];
var numParticipants = 2; // e.g., total frogs
var baseRate = 0.5; // success rate
var unitSize = 2; // e.g., for 2-frog units
var exactMeaning = true;
var scopes = ["surface", "inverse"];
var scopePriorDist = [0.9, 0.1];
var QUDs = ["how many?","all?","none?", "two fail?", "two succeed?", "this unit?", "not this unit?"];
// if making units, favor the QUDs concerned with units
var QUDPrior_makeUnits = [0.03, .03, .03, .03, .03, 0.01, 0.01];
//var QUDPrior_makeUnits = [0.033, 0.033, 0.033, 0.45, 0.45];
// if not making units, favor the QUDs not concerned with making units
//var QUDPrior_noMakeUnits = [0.3, 0.3, 0.3, 0.05, 0.05];
var QUDPrior_noMakeUnits = [0.03, .03, .03, 4, .03, 0.01, 0.01];
//var makeUnits = true;
// prior probability of making units in default cases
var makeUnits_baseRate = 0.01; 
// prior probability of making units if numParticipants == unitSize
// e.g., two-frog world when utterance is "two frogs..." (two-not)
var makeUnits_baseRate_sameSize = 0.01;  
  

// now run the model with whatever state we want, given the variables above
var pragSpeakerState2frogs = {
  successes: [1],
  failures: [2]
}

var pragSpeakerState4frogs = {
  successes: [1,2],
  failures: [3,4]
}

print("baseRate of success: " + baseRate);
print("makeUnits_baseRate: " + makeUnits_baseRate);
print("makeUnits_baseRate_sameSize: " + makeUnits_baseRate_sameSize);
print("scope prior distribution [surface, inverse]: " + scopePriorDist)
print("exact meaning? " + exactMeaning);
runModel(utterances, numParticipants, baseRate, unitSize,
        exactMeaning,
        scopes, scopePriorDist,
        QUDs, QUDPrior_makeUnits, QUDPrior_noMakeUnits,
        makeUnits_baseRate, makeUnits_baseRate_sameSize,
        pragSpeakerState2frogs);

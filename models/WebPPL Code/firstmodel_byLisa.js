// Here is the code for the quantifier scope model
/// pressuposition failure, need to find a unit
/// adjust QUD prior to be based on makeunits
/// adjust make units base rate, based on makeunits value
///

///// variables that can be set globally
////////////// possible utterances
// // two-not = "two frogs didn't jump"
var utterances = ["null","two-not"];
var numParticipants = 4; // e.g., total frogs
var baseRate = 0.5; // success rate
//unitsize will match number in utterance(hopefully)
var unitSize = 2; // e.g., for 2-frog units
var scopes = ["surface", "inverse"];
var QUDs = ["how many?","all?","none?", "this unit?", "not this unit?"];
//var makeUnits = true;
var makeUnits_baseRate = 0.5; // prior probability of making units

///////////////////////

var utterancePrior = function() {
  uniformDraw(utterances)
}

/////// world state functions /////////////
// recursive function that flips based on base rate to determine which
//    individuals were successful
var makeStates = function(numParticipants, baseRate){
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
      return sort([numParticipants].concat(makeStates(numParticipants-1, baseRate)))
    }else{
      return makeStates(numParticipants-1, baseRate)
    }
  }
}
                      
// sanity check for making states
//print(makeStates(4,0.5))

// state builder: needs to know 
//                (1) how many particants (numParticipants), 
//                (2) base rate of success (baseRate)
var statePrior = function(numParticipants, baseRate) {
// always return the collection -- can get length alone later on if needed
  return makeStates(numParticipants, baseRate);
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
  // uniform over possible scopes
  return uniformDraw(scopes)
}
////////////////////////


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
var meaning = function(utterance, state, scope, 
                        numParticipants, makeUnits, unit) {
  if(utterance == "two-not"){
    if(makeUnits){ // assess by unit
      // scope doesn't matter -- all that matters is whether 
      // the unit was unsuccessful (= not in the success state)
      // e.g., unit = [1,2] for state = [1,2,3] = true
      return !findFirstInSecondList(unit, state);
    }else{ // no units -- just total count, where scope matters
      // working with state.length to get total count
      if(scope == "surface"){ //there are two who didn't
        // e.g., 4-frog world, so only true when 2, 3, or 4 didn't = 0, 1, or 2 who did
        // e.g., state <= 2 (= total_frogs-2) 
        // in 2-frog world, only true when 2 didn't, so 0 did
        return (state.length <= numParticipants - 2); 
      }else{ // it's not true that two did
        // e.g., 4-frog world, so only true when 0 or 1 (<2) did
        // e.g., state < 2
        // in 2-frog world, only true when 0 or 1 (<2) did
        return (state.length < 2)      
      }
    }
  }else{
    // null utterance: fall back on prior 
    return true;
  }
};

// testing the meaning function
// var test_utt = "two-not";
// var test_state = [1,2];
// var test_scope = "inverse";
// var test_numParticipants = 4;
// var test_makeUnits = true;
// var test_unit = [1,2];
// var meaning_check = meaning(test_utt, test_state, test_scope, 
//                             test_numParticipants, test_makeUnits, test_unit);
// print("meaning check with participant num " + test_numParticipants) 
// print( "with utterance " + test_utt)
// print(" in success state " + test_state)
// print(" with scope reading " + test_scope)
// print(" when make_units is " + test_makeUnits)
// print(" and test_unit is " + test_unit)
// print(meaning_check)
//////// end meaning function used by literal listener //////////


///////////// QUDs ////////////////////
var QUDPrior = function() {
  uniformDraw(QUDs);
}

// "how many?", "all?", "none?", "this unit?", "not this unit?"
var QUDFun = function(QUD,state,numParticipants, unit) {
  if(QUD == "all?"){ // boolean
    return state.length == numParticipants;
  }else if(QUD == "none?"){ // boolean
    return state.length == 0;
  }else if(QUD == "how many?"){ // number successes
    return state.length;
  }else if(QUD == "this unit?"){ //  boolean (Did this unit succeed?)
    return findFirstInSecondList(unit, state);
  }else if(QUD == "not this unit?"){ // boolean (Did this unit not succeed?)
    return !findFirstInSecondList(unit, state);
  }
};

// QUD sanity check
//print(QUDFun("not this unit?", [1,2,3,4], 4, [1,2]))
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

var alpha_S1 = 1

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

// Pragmatic listener (L1)
// get utterance, and infer everything else:
//   scope, state, QUD, makeUnits, unit
var pragmaticListener = cache(function(utterance) {
  Infer({model: function(){
    var scope = scopePrior();
    // numParticipants and baseRate of success globally set
    var state = statePrior(numParticipants, baseRate); 
    var QUD = QUDPrior();
    // makeUnits inferred based on makeUnits_baseRate
    var makeUnits = flip(makeUnits_baseRate);
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
//pragmaticListener("two-not")
///pressuposition failure, need to find a unit
/// adjust QUD prior to be based on makeunits
///adjust make units base rate, based on makeunits value
///

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

// // A speaker decides whether to endorse the ambiguous utterance as a 
// // description of a certain success world state
// if we set numParticipants = 4, let's look at a 2-frog success state
print("num of participants: " + numParticipants)
print("in world with success state = [1,2]")
pragmaticSpeaker([1,2])

// if we set numParticipants = 2, let's look at a 1-frog success state
// print("num of participants: " + numParticipants)
// print("in world with success state = [1]")
// pragmaticSpeaker([1])

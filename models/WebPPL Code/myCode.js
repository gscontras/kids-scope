////Goal: Copy down Lisa's code exactly so I understand it and can work with it.
//Lisa's comments in quotes

var utterancePrior = function() {
  uniformDraw(utterances)
}

///// World State Fucntions /////
// "recursive function that flips based on base rate to determine which
// individuals were successful"
// So my version had a different flip for each frog.  The issue here is that you are
// going to get a guassian looking world prior; which maybe we want
// (differnt from previous model)
var makeSuccesses = function(numParticipants, baseRate){
  // "if numParticipants == 1, return the empty set or [numParticipants]
  // based on flip"
  if(numParticipants == 1){
    if(flip(baseRate)){
      return [numParticipants]
    }else{
          return []
        }
    }
    //"Flip this one and concatenate it to results of doing so for one participant 
    // less"
    else{
      if(flip(baseRate)){
        // "success for this participant"
        return sort([numParticipants].concat(makeSuccesses(numParticipants - 1, baseRate
                                                         )))}
      else{
        return makeSuccesses(numParticipants - 1, baseRate)
        }
      }
    }
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




// "main function for getting inverse of list, based on numParticipants in world
// used for getting failures from list of successes"
// successes is of notation e.g. [1,2], where numParticipants is total number unbracketed
var getInverse = function(successes, numParticipants){
  // "explicitly list out each participant with a number (e.g., [1,2,3,4])"
  var participants = mapN(function(x) { return x + 1; }, numParticipants);
  // "check first to see if successes.length == 0, if so, inverse = whole list
  if(successes.length == 0){
    return participants
  }
  // "else check to see if success.length == numParticipants; if so, inverse = empty
  else if(successes.length == numParticipants){
    return [];
  }else{
    // "else call helper function to get inverse individuals"
    return getInverseHelper(successes, participants);
  }
}

// Looks to be doing the same thing as the helper, except you can give it numParticipants
// instead of a list
////TEST
// var b = getInverse([2],4)
// b


// "state builder: needs to know
// (1) how many participants (numParticipants),
// (2) base rate of succes (baseRate)
//returns: states = {successes: [list of success individuals],
//                   failures: [list of failure individuals]}"
var statePrior = function(numParticipants, baseRate){
  // "always return the collection - can get length alone later on if needed
  // return make Successes(numPartipants, baseRate);"
  var successes = makeSuccesses(numParticipants, baseRate);
  return {
    successes: successes,
    failures: getInverse(successes, numParticipants)
  }
}
// I think I understand this function, but I don't understand the syntax. Can you
// run a recursive function as an argument in a return function? I guess you can
// this function is a little redudant, as its just the combined output of makeSuccesses and 
// the failure function. It's good to see a way to compose them though.  Is there a way to 
// collapse all of these functions into one?
/////TEST
// var b = statePrior(4,0.5)
// b
//So the statePrior spits out the individual frogs (e.g. [1,2,3]) That succeed and
//fail

// viz.hist(repeat(1000, function() {statePrior(4,.5)}))


// this function makes is the sampler used in the make units function. Is there a way
// to combine these?
var recursiveSampleUnit = function(unit_size, list, unit){
  //print("list is currently: " + list)
  // if unit == unit_size, return unit (this makes sense)
  if (unit.length == unit_size){
    return unit;
  }else{
    // else sample an element from the list
    // remove from list and add to unit
    // recursiveSampleUnit(unit_size, updated_list, updated_unit)
    var sampledElem = uniformDraw(list);
    var smallerList = remove(sampledElem, list);
    var new_unit = unit.concat([sampledElem]);
    return recursiveSampleUnit(unit_size, smallerList, new_unit);
  }
}
// I'm understanding pretty precisely how each of these functions work.
////TEST
// var b = recursiveSampleUnit(2, [1,2,3,4], [])
// b

// creates unit of size unit_size from list
// creating unit = list of elements from original list
// This function just makes it so you don't have to run the sampler if the unit_size
// = the list size
var sampleUnit = function(unit_size, list, unit){
  // if list < unit_size, not possible so return []
  if(list.length < unit_size){
    return []
  }
  else if(list.length == unit_size){
    return list;
  }
  else{
    return recursiveSampleUnit(unit_size, list, []);
  }
} 


/////CACHED
// var unitize = cache(function(unit_size, list){
//   Infer({method: "enumerate"}, function(){
//     // call function to return a unique unit of size unit_size
//     var unit = sampleUnit(unit_size, list, [])
//     // "don't care about order of elements in units. . . so sort first"
//     // What does this have to do with sorting?
//     return sort(unit)
//   })
// }
//                     )


/////NONCACHED
// var unitize = function(unit_size, list){
//   Infer({method: "enumerate"}, function(){
//     // call function to return a unique unit of size unit_size
//     var unit = sampleUnit(unit_size, list, [])
//     // "don't care about order of elements in units. . . so sort first"
//     // What does this have to do with sorting?
//     return sort(unit)
//   })
// }
//You don't need cache to ge it to run. I'm assuming cache just speeds up overal 
//runtime. Also beginning to understand how 'Infer' works

////TEST (This works!)
// var b = unitize(2,[1,2,3,4])
// viz.hist(b)

var scopePrior = function(){
  return categorical({vs: scopes, ps: scopePriorDist});
}


//The following is some kind of unit-meaning helper function. Not sure what it does
var findFirstInSecondList = function(list1, list2){
  if (list1.length == 1){
    // typeof of myVar != 'undefined' is how to check for undefined return
    // typeof
    if(typeof (find(function(x) { return x == list1[0]; }, list2)) == 'undefined'){
      return false;
    }else{
      return true;
    }
  }else{
    //else remove first element in list1
    var elem0 = list1[0];
    var shorterList = remove(elem0, list1);
    // and find in list2
    if(typeof (find(function(x) { return x == list1[0]; }, list2)) != 'undefined'){
      //"if present, continue with remaining elements in list1
      findFirstInSecondList(shorterList, list2);
      //else return false
      
    }else{
      return false;
    }
  }
}
//I have no idea what this function is doing
//Okay, so this function is just taking two lists, and making sure all the members of
// the first list are in the second list, presumably to use in unit meaning function
////TEST
// var b = findFirstInSecondList([1,2,3,4], [1,2])
// b

// The meaning function
// This meanig function is intense, and useful to go over

var meaning = function(utterance, state, scope, numParticipants, exactMeaning, makeUnits,unit){
  if(utterance == "two-not"){
    if(makeUnits){
      //scope doesn't matter in the makeUnits case
      if(exactMeaning){
        //Lisa used a bunch of print statements to debug. smart
        return (findFirstInSecondList(unit, state["failures"])
               && state["failures"].length == unitSize);
      }else{
        return findFirstInSecondList(unit, state["failures"])
      }
    }else{
      //no units here
      if(scope == "surface"){
        if(exactMeaning){
          return (state["failures"].length == 2)
          //does this mean, return true if state[failures] is two?
        }else{
          return (state["failures"].length >= 2);
        }
      }else{
        //inverse
        if(exactMeaning){
          return(state["successes"].length != 2);
        }else{
          retun (state["successes"].length < 2);
        }
      }
    }
  }else{
    return true;
  }
};

/////TEST
var state = statePrior(4,.5);
var b = meaning("two-not", state, "surface", 4,true, false, 2)
print(state)
b


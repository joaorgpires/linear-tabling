:- use_module(library(tries)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Initialization
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


init_tabling :-
  trie_open(GoalTable), %Global trie
  set_value(globalGoalTable, GoalTable), %Global variable for GoalTable
  set_value(new_answers, false), %Sets the flag for new answers to false
  set_value(sccLeader, none). %Initially, there is no leader

:- init_tabling.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Tabling predicates
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Call for tabling a term
tabled_call(OrCall, SgId, TrCall) :-
  writeln('Tabled Call:'),
  writeln(OrCall),
  exists_entry(OrCall, SgId, EntryType),
  set_leader(LeaderFlag),
  exec_call(OrCall, SgId, TrCall, EntryType, LeaderFlag),
  reset_leader(LeaderFlag).


%%%Verify if entry already exists. If not, add it.
exists_entry(OrCall, SgId, EntryType) :-
  get_value(globalGoalTable, GoalTable),
  trie_check_entry(GoalTable, OrCall, Ref), %Check if OrCall is already in GoalTable and get its reference
  !, %If entry exists, we can stop recursion
  recorded(db_answers, [Ref, SgId, PrevEntryType], _),
  update_db(Ref, SgId, PrevEntryType, EntryType).

exists_entry(OrCall, SgId, EntryType) :-
  get_value(globalGoalTable, GoalTable),
  trie_put_entry(GoalTable, OrCall, Ref), %Get ref in GoalTable so we can add it to the database of answers
  trie_open(SgId), %Open a trie for this subgoal
  recorda(db_answers, [Ref, SgId, new], _), %Add this entry to the database
  EntryType = new.


%%%If we are repeating a call to an entry in the database, update its EntryType to rep if it was new in database
update_db(Ref, SgId, new, EntryType) :-
  recorded(db_answers, [Ref, SgId, new], DbRef),
  erase(DbRef), %Erase this entry from database
  recorda(db_answers, [Ref, SgId, rep], _),
  EntryType = rep.

update_db(_, _, rep, EntryType) :- EntryType = rep.

update_db(_, _, comp, EntryType) :- EntryType = comp.


%%%Set leader to current if none, reset it to none if current in order to be ready for next tabling
set_leader(true) :-
  get_value(sccLeader, none),
  !,
  set_value(sccLeader, cur).

set_leader(false).

reset_leader(true) :- set_value(sccLeader, none).

reset_leader(false).


%%%Executes the actual predicate if it is a new call
exec_call(OrCall, _, TrCall, new, _) :- writeln('Call:'), writeln(OrCall), call(TrCall). %Simply call the transformed call

exec_call(OrCall, SgId, TrCall, new, true) :- %If we have new answers, prepare for new computation loop
  get_value(new_answers, true), %It was set true by new_answer, that is, the transformed call
  writeln('Testing loop for'),
  writeln(OrCall),
  prepare_new_loop(OrCall, SgId, TrCall).

exec_call(_, _, _, _, true) :- %Mark everything as complete so we do not recompute them
  complete_db(dummy),
  fail.

exec_call(OrCall, SgId, _, _, LeaderFlag) :- %Simply return all solutions
  trie_traverse(SgId, Ref),
  trie_get_entry(Ref, OrCall).


%%%Prepares database for new loop
prepare_new_loop(OrCall, SgId, TrCall) :-
  !, %We can stop recursion
  reset_db(dummy),
  set_value(new_answers, false),
  writeln('Redoing loop'),
  exec_call(OrCall, SgId, TrCall, new, true),
  fail.


%%%Resets the database putting everything as new, in order to prepare it for the new computation loop
reset_db(dummy) :-
  recorded(db_answers, [Ref, SgId, rep], DbRef),
  erase(DbRef),
  recorda(db_answers, [Ref, SgId, new], _), %Set everything to new
  fail.

reset_db(_).


%%%Marks everything in database as complete
complete_db(dummy) :-
  recorded(db_answers, [Ref, SgId, _], DbRef),
  erase(DbRef),
  recorda(db_answers, [Ref, SgId, comp], _),
  fail.

complete_db(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Transformed call predicates
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%If the answer is new, add it to the current subgoal trie
new_answer(SgId, OrCall) :-
  exists_answer(OrCall, SgId, EntryType),
  add_answer(OrCall, SgId, EntryType),
  fail. %Local scheduling action


%%%Check if answer exists in current subgoal trie
exists_answer(OrCall, SgId, EntryType) :-
  trie_check_entry(SgId, OrCall, _),
  !, %If entry exists, we can stop recursion
  EntryType = rep.


exists_answer(_, _, EntryType) :- EntryType = new.


%%%Adds a new answer if it does not exist in current subgoal trie
add_answer(OrCall, SgId, new) :-
  trie_put_entry(SgId, OrCall, _),
  writeln('New answer'),
  writeln(SgId),
  writeln(OrCall),
  set_value(new_answers, true).


add_answer(OrCall, _, rep) :-
  writeln('Repeated answer'),
  writeln(OrCall).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Count and enumerate predicates
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%Enumerates all calls to OrCall
enum_calls(OrCall) :- recorded(db_answers, [Ref, _, _], _),
                        trie_get_entry(Ref, OrCall).


%%%Enumerates all solutions found
enum_solutions(OrCall) :- recorded(db_answers, [_, SgId, _], _),
                       trie_traverse(SgId, Ref),
                       trie_get_entry(Ref, OrCall).


%%%Counts number of diferent solutions (used to test correctness)
count_calls(OrCall, Count) :- findall(1, OrCall, L),
                               length(L, Count).

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

init_tabling.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Tabling predicates
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Call for tabling a term
tabled_call(OrCall, SgId, TrCall) :-
  exists_entry(OrCall, SgId, EntryType),
  set_leader(LeaderFlag),
  exec_call(OrCall, SgId, TrCall, EntryType, LeaderFlag),
  reset(LeaderFlag).


%%%Verify if entry already exists. If not, add it.
exists_entry(OrCall, SgId, EntryType) :-
  get_value(globalGoalTable, GoalTable),
  trie_check_entry(GoalTable, OrCall, Ref), %Check if OrCall is already in GoalTable and get its reference
  !, %If entry exists, we can stop recursion
  recorded(db_answers, [Ref, SgId, PrevEntryType], _),
  update_db(Ref, SgId, PrevEntryType, EntryType).

exists_entry(SgId, OrCall, EntryType) :-
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

update_db(_, _, rep, rep).

update_db(_, _, comp, comp).


%%%Set leader to current if none, reset it to none if current in order to be ready for next tabling
set_leader(true) :-
  get_value(leader, none),
  !,
  set_value(leader, cur).

set_leader(false).

reset_leader(true) :- set_value(leader, none).

reset_leader(false).

%%%Execute if we are not dealing with a repeated call
exec_call().

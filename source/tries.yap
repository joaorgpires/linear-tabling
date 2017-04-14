%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                            %%%
%%%           Examples on how to use the tries module          %%%
%%%                                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(tries)).

go1 :- trie_open(A),
       trie_show(A),
       trie_close(A),
       trie_stats_show.

go2 :- trie_open(A),
       trie_put_entry(A,X,_),
       trie_put_entry(A,1,_),
       trie_put_entry(A,f(X,1),_),
       trie_put_entry(A,f(X,2),_),
       trie_show(A),
       trie_close(A),
       trie_stats_show.

go3 :- trie_open(A),
       trie_put_entry(A,[],X1),
       trie_put_entry(A,[a(X)],X2),
       trie_put_entry(A,[a(X),b(X,Y)],X3),
       trie_show(A),
       trie_get_entry(X1,T1),
       write('Term 1: '), write(T1), nl,
       trie_get_entry(X2,T2),
       write('Term 2: '), write(T2), nl,
       trie_get_entry(X3,T3),
       write('Term 3: '), write(T3), nl,
       trie_remove_entry(X1),
       trie_remove_entry(X2),
       trie_show(A),
       trie_close(A),
       trie_stats_show.

go4 :- trie_open(A),
       trie_put_entry(A,[],_),
       trie_put_entry(A,[a(X)],_),
       trie_put_entry(A,[a(X),b(X,Y)],_),
       trie_show(A),
       trie_check_entry(A,[a(V)],_),
       trie_check_entry(A,[a(V),b(V,Z)],_),
       var(V), var(Z),
       trie_show(A),
       trie_close(A),
       trie_stats_show.

go5 :- trie_open(A),
       trie_put_entry(A,X,_),
       trie_put_entry(A,1,_),
       trie_put_entry(A,f(X,1),_),
       trie_put_entry(A,f(X,2),_),
       trie_show(A),
       aux_traverse_and_remove(A),
       trie_show(A),
       trie_close(A),
       trie_stats_show.

aux_traverse_and_remove(A) :- 
       trie_traverse(A,D),
       trie_get_entry(D,E),
       write('Removing: '), write(E), nl, 
       trie_remove_entry(D),
       fail.
aux_traverse_and_remove(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trie_show(A) :- 
	write('--------------- TRIE ---------------'), nl,
	trie_print(A),
	trie_usage(A,Entries,Nodes,_),
	write('(Entries '), write(Entries),
	write(' Nodes '), write(Nodes), write(')'), nl,
	write('------------------------------------'), nl.

trie_stats_show :-
	write('------------ TRIE STATS ------------'), nl,
	trie_stats(CMemory,CTries,CEntries,CNodes),
	write('(Memory '), write(CMemory),
	write(' Tries '), write(CTries),
	write(' Entries '), write(CEntries),
	write(' Nodes '), write(CNodes), write(')'), nl,
	write('------------------------------------'), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

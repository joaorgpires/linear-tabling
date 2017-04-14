%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Program:
%%%    Same generation for a cylinder with 5x5x2 nodes
%%% Number of answers for the query '?- samegen(X,Z).':
%%%    626
%%% Possible program transformation:
%%%
%%%    samegen(X,Z) :- 
%%%       tabled_call(samegen(X,Z),SgId,samegen_table(SgId,X,Z)).
%%%
%%%    samegen_table(SgId,X,Z) :- 
%%%       cylinder(X,Y),
%%%       samegen(Y,W),
%%%       cylinder(Z,W),
%%%       new_answer(SgId,samegen(X,Z)).
%%%    samegen_table(SgId,X,X) :- 
%%%       new_answer(SgId,samegen(X,X)).
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- table samegen/2.

samegen(X,Z) :- cylinder(X,Y), samegen(Y,W), cylinder(Z,W).
samegen(X,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cylinder(1,20).
cylinder(1,20).
cylinder(2,3).
cylinder(2,4).
cylinder(3,10).
cylinder(3,23).
cylinder(4,25).
cylinder(4,20).
cylinder(5,11).
cylinder(5,15).
cylinder(6,11).
cylinder(6,18).
cylinder(7,11).
cylinder(7,11).
cylinder(8,15).
cylinder(8,3).
cylinder(9,4).
cylinder(9,1).
cylinder(10,5).
cylinder(10,6).
cylinder(11,2).
cylinder(11,8).
cylinder(12,5).
cylinder(12,13).
cylinder(13,16).
cylinder(13,8).
cylinder(14,19).
cylinder(14,15).
cylinder(15,25).
cylinder(15,18).
cylinder(16,18).
cylinder(16,22).
cylinder(17,23).
cylinder(17,25).
cylinder(18,16).
cylinder(18,7).
cylinder(19,8).
cylinder(19,7).
cylinder(20,7).
cylinder(20,1).
cylinder(21,4).
cylinder(21,18).
cylinder(22,17).
cylinder(22,23).
cylinder(23,16).
cylinder(23,15).
cylinder(24,6).
cylinder(24,5).
cylinder(25,20).
cylinder(25,2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

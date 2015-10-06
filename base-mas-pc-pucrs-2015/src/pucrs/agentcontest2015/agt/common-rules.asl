best_shop([Shop|_],Shop). // simply get the first!

find_shops(ItemId,[],[]).
find_shops(ItemId,[shop(ShopId,ListItems)|List],[ShopId|Result]) :- 
   .member(item(ItemId,_,_,_),ListItems) &
   find_shops(ItemId,List,Result).
find_shops(ItemId,[shop(ShopId,ListItems)|List],Result) :- 
   not .member(item(ItemId,_,_,_),ListItems) & 
   find_shops(ItemId,List,Result).
   
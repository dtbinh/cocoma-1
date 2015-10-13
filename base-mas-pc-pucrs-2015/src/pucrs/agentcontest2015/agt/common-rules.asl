
// unifies tools the agent is able (by its role), but does not have
required_tool(T) :-
   role(_,_,_,_,Tools) & 
   .member(T,Tools) &
   not item(T,_).

find_shop(ItemId, ShopId) :-
	shop(ShopId,_,_,Items) &
	.member(item(ItemId,Price,Amount,_), Items).

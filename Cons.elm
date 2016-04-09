module Cons where

import List


type Cons a = Cons a (List a)


-- Contructor and accessors

cons : a -> List a -> Cons a
cons = Cons


-- Convenience functions

singleton : a -> Cons a
singleton x = Cons x []

fromList : List a -> Maybe (Cons a)
fromList l =
  case l of
    [] -> Nothing
    head::tail -> Just <| Cons head tail

toList : Cons a -> List a
toList (Cons head tail) = head::tail

tail' : Cons a -> Maybe (Cons a)
tail' = tail >> fromList

cons' : a -> Cons a -> Cons a
cons' x = toList >> cons x

cons2' : (a, b) -> (Cons a, Cons b) -> (Cons a, Cons b)
cons2' (x, y) (xs, ys) = (cons' x xs, cons' y ys)


-- List methods that avoid Maybe

head : Cons a -> a
head (Cons head _) = head

tail : Cons a -> List a
tail (Cons _ tail) = tail

maximum : Cons number -> number
maximum = foldl1 max

minimum : Cons number -> number
minimum = foldl1 min


-- List methods that maintain Cons

reverse : Cons a -> Cons a
reverse = foldl1 cons'

--(::) = cons

append : Cons a -> Cons a -> Cons a
append c d = foldr cons d c
--append' : List a -> Cons a -> Cons a
--append'' : Cons a -> List a -> Cons a

concat : Cons (Cons a) -> Cons a
concat = foldl1 append

intersperse : a -> Cons a -> Cons a
intersperse x c =
  case tail' c of
    Nothing -> c
    Just tail -> Cons head <| Cons x <| intersperse x tail

unzip : Cons (a, b) -> (Cons a, Cons b)
unzip = foldr1 cons2'

map : (a -> b) -> Cons a -> Cons b
map f (Cons head tail) = Cons (f head) (List.map f tail)

map2 : (a -> b -> c) -> Cons a -> Cons b -> Cons c
map2 f (Cons x xs) (Cons y ys) = Cons (f x y) (List.map2 f xs ys)

map3 : (a -> b -> c -> d) -> Cons a -> Cons b -> Cons c -> Cons d
map3 f (Cons x xs) (Cons y ys) (Cons z zs) = Cons (f x y z) (List.map3 f xs ys zs)

map4 : (a -> b -> c -> d -> e) -> Cons a -> Cons b -> Cons c -> Cons d -> Cons e
map4 f (Cons v vs) (Cons w ws) (Cons x xs) (Cons y ys) = Cons (f v w x y) (List.map3 f vs ws xs ys)

map5 : (a -> b -> c -> d -> e -> f) -> Cons a -> Cons b -> Cons c -> Cons d -> Cons e -> Cons f
map5 f (Cons v vs) (Cons w ws) (Cons x xs) (Cons y ys) (Cons z zs) = Cons (f v w x y z) (List.map3 f vs ws xs ys zs)

indexedMap : (Int -> a -> b) -> Cons a -> Cons b
indexedMap f c =
  let
    go i (Cons head tail) = Cons <| f i head <| go (i + 1) tail
  in
    go 0 c

foldr1 : (a -> a -> a) -> Cons a -> a
foldr1 f c =
  case tail' c of
    Nothing -> head c
    Just tail -> f (head c) (foldr1 tail)

foldl1 : (a -> a -> a) -> Cons a -> a
foldl1 f (Cons head tail) = List.foldl f head tail


scanl : (a -> b -> b) -> b -> Cons a -> Cons b
scanl =
--scanl1


-- List methods

isEmpty = toList >> List.isEmpty
length = toList >> List.length
member x = toList >> List.member x
filter f = toList >> List.filter f
take n = toList >> List.take n
drop n = toList >> List.drop n
partition f = toList >> List.partition f
filterMap f = toList >> List.filterMap f
concatMap f = toList >> List.concatMap f
foldr f x = toList >> List.foldr f x
foldl f x = toList >> List.foldl f x
sum = toList >> List.sum
product = toList >> List.product
all = toList >> List.all
any = toList >> List.any
sort = toList >> List.sort
sortBy f = toList >> List.sortBy f
sortWith f = toList >> List.sortWith f

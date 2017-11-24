# Avocado language spec

Avocado is a declarative language with strong typing and focus on manipulation
of data streams.

## Type system

All values are statically typed.
But in many cases type annotations can be omitted.

Basic types:
```
Int
Float
String
Bool
```

Container types:
```
List a
Tuple()
Record()
```

Special types:
```
Schema
Transform
```

## Values

Values can be created with literals and assigned to store:
```
; Int
age: Int = 27
age = 27

; Float
weight: Float = 76.2
weight = 76.2

; String
name: String = 'Daniil'
name = 'Daniil'

; Bool
awake: Bool = true
awake = true

; List
hobbies: List String = ['develpment', 'music', 'skateboarding']
hobbies = ['development', 'music', 'skateboarding']
```

## Transforms

Transforms take values and produce a new value as output.
Transforms are defined by chaining predefined functions.

Assigning transform to value runs the transform and assigns the output.

Transforms can have external dependencies on other values/transforms
Transform must not modify its external dependencies
Transform can't have circular external dependencies

```
; Simple transform
;
t_big_numbers: Transform(List Number -> List Number) = where($ > 100)
t_big_numbers = where($ > 10)
nums = [2, 41, 15, 6, 30]
big_numbers = nums | t_big_numbers

; Chained transform
;
min_age = 18

; Transform(List Record(age Number, *) -> List Record(age Number, *))
; This one has external dependency on value 'min_age'
t_grownups = where($.age > min_age)

; Transform(List Record(name String, *) -> List String)
t_only_name = pick($.name)

users = [{name: "Tim", age: 23}, {name: "Sam", age: 16}]
grownup_names = users | t_grownups | t_only_name

```
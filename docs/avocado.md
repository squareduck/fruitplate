# Avocado language

Avocado is a small strongly typed declarative language for describing Fruitplate ideas.

## Value types

Any - Special type when we only care about value being present
Id - Can be ommited in value literal and will be automatically generated as UUID
Bool
Int
Float
String
List a
Record(a)
Enum

## Defining basic values

Value type can be inferred if type is missing
Value must be initialized

Defining values
```
my_age: Int = 27
my_height: Float = 178.2
my_name: String = "Daniil"
married: Bool = True
my_hobbies: List String = ["Development", "Music", "Skateboarding"]
my_profile: Record(name String, age Number) = {name: "Daniil", age: 27}
my_profile: Record(user) = {name: "Daniil", age: 27}
```

## Generics

A transform can have generic type
where transform has type "List a"
which will resolve into "List Sting" if you pass it ["a", "b", "c"]

## Defining schemas

```
user: Schema = name String, age Number
my_profile: Record(user) = {name: "Daniil", age: 27}
```

## Special symbols
```
$ is current element when transforming collection
@name is referring to named value in value store
&name is referring to named transform in transform store
%name is referring to named pipeline in pipeline store
#name is referring to named component in component store
```

## Defining transforms

Transforms are pre-defined functions that accept values as input and output values
Transforms can have sideeffects only if secondary arguments are passed

Transforms are called with
```
name(primary_arg, [secondary_arg_name: secondary_arg])

// Filter values in List by criteria
@scores | where($ > 100)

// Merge two records
@tasks | merge(@new_tasks)
```

Examples
```
passing_score: Int = 500
scores: List Int = [440, 720, 510]

// Piping value into transform returns output (e.g. can be viewed in Value Store page)
scores | max
scores | max(1000 - $)
scores | where($ >= @passing_score) | max

// Define named transform
passed: Transform = where($ >= @passing_score)
scores | &passed

// Define named transform with stricter type
passedOnlyInts: Transform(List Int -> List Int) = where($ > @passing_score)

// Create new value from transform (will infer the type from transform type)
passed_scores = scores | &passed

// Replace the value
scores = scores | where($ >= @passing_score)
```
## Defining pipelines

Pipeline is a sequence of transforms or other pipelines
Pipelines have different namespace from values

```
max_score: Pipeline(List Int -> Int) = where($.age > 18) | &passed
scores | %max_score
```

## Defining components

Component is a container for one or more pipelines with standard visual representation

List component (List String)
```
users: List Record(name String, age Number) = [
    {name: "Sam", age: 17},
    {name: "Tim", age: 23},
    ]

grownups: Component = list{
    input: @users,
    pipeline: where($.age > 18) | pick($.name),
    }
```
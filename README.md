# Sukunimitin

Markov Chain based Finnish surname generator. Uses Finnish Surname data set from https://www.avoindata.fi/data/fi/dataset/none and checks that the names are not in use from https://verkkopalvelu.vrk.fi/nimipalvelu/.


## Configuration

The generation algorithm can be configured through the following query parameters

 - `chainSize`: Number of adjecent characters to taken into account in the Markov chain, default 3
 - `maxLength`: Regenerate name if result is longer than this value, default 15
 - `amount`: Number of names generated per round, default 10
 - `sameness`: Weight given to common patterns, default 1
 - `hideUnavailable`: Hides unavailable names if set to `true`, default `false`
 - `beginWith`: Starting characters to continue geneartion from, default empty
 - `endWith`: Regenrate if names not ending in given characters, default empty

You might need to fiddle a bit with all the parameters to produce pleasant names. If the names sound like jibberish, you might want to increase the `chainSize` and `sameness`. If, on the other hand, most of the names are unavailable, you might want to reduce the `chainSize` or the `sameness`. Alternatively, you can hide unavailable names and increase the amount of names generated. Try out different combinations and see what happens!

### Example

[`https://aeirola.github.io/sukunimitin/?chainSize=4&amount=40&sameness=2&hideUnavailable=true`](https://aeirola.github.io/sukunimitin/?chainSize=4&amount=40&sameness=2&hideUnavailable=true) will produce quite common sounding surnames. Here we've bumped the `chainSize` and `sameness` to generate quite common sounding names. Since most of the names will have been taken, we generate more names and hide the unavailable ones.

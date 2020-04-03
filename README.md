# Google Hash Code 2020 Qualification Round


compile with `ghc -dynamic -O2 solver.hs`


## Score

|input                       |      score| time |
|----------------------------|----------:|-----:|
|a_example.txt               |         17|   <1s|
|b_read_on.txt               |  5,822,900|   <1s|
|c_incunabula.txt            |  5,688,777|   49s|
|d_tough_choices.txt         |  5,028,725|  7min|
|e_so_many_books.txt         |  5,044,872|   20s|
|f_libraries_of_the_world.txt|  5,308,034|    7s|
| total                      | 26,883,325|8min16|
```

## vs Python vs Rust

Same idea behind all these solvers.

* Python solver: <https://github.com/PicoJr/2020-hashcode>
* Rust solver: <https://github.com/PicoJr/2020-hashcode-rust>

best in **bold**

| Haskell        | time |   Python  | time |      Rust     | time    |
|---------------:|-----:|----------:|-----:|--------------:|--------:|
|             17 |   <1s|         17|   <1s|         17    |     <1s |
|  **5,822,900** |   <1s|  5,724,900|  1.5s|  5,821,000    |     <1s |
|  **5,688,777** |   49s|  5,685,165|   47s|  5,683,014    |  **4s** |
|  **5,028,725** |  7min|  5,028,465| 12min| **5,028,725** | **46s** |
|  **5,044,872** |   20s|  4,992,207|   18s|  4,525,774    |  **2s** |
|  **5,308,034** |    7s|  5,027,259|    2s|  5,183,128    | **<1s** |
| **26,883,325** |8min16| 26,458,013| 13min| 26,241,658    | **52s** |

### Notes

Performances:

* I am fairly inexperienced with Haskell (1st time writing Haskell)
* Python was run using "vanilla" python (not `cpython`), it could probably be faster
* Rust was run using `cargo --release`, it did not use hardware specific optimizations

Scores:

* Haskell and Rust both use integral division whereas Python use float division
* Rust uses an unstable sort by key

---
layout: post
title: "Creating a new NMatrix"
date: 2012-12-27
tags: [en-us, ruby, sciruby, nmatrix]
---

As I've been working with [NMatrix](http://github.com/sciruby/nmatrix) documentation lately, I thought that a good explanation of how to create a new `NMatrix` object and all the options would be useful.

Let's start with the simplest thing possible: to create a NMatrix from an array of values, without any options:

	>> m = N[ [2, 3, 4], [7, 8, 9] ]
	=> #<NMatrix:0x007f8e121b6cf8shape:[2,3] dtype:int32 stype:dense> 
	>> m.pp
	  [2, 3, 4]
	  [7, 8, 9]
	=> nil 

<!--more-->

When I started playing with this project, I had problems myself about poor documentation: how the hell do I *use* it? My first doubt was about `stypes` and `dtypes`. I'll explain what they are and show examples of some patterns to create new matrices along the way.

## The type of a matrix's elements

Each `NMatrix` object has what's called a `dtype`. It's a `Symbol` that says what each element of the matrix is: if it's an integer, a floating-point, a complex or a rational number and the number of bits used to store it. These are defined in [ext/nmatrix/nmatrix.h](https://github.com/SciRuby/nmatrix/blob/master/ext/nmatrix/nmatrix.h#L195). Below is the complete list.

- `:byte` (unsigned 8bit integer)
- `:int8` (signed 8bit integer, a char)
- `:int16`
- `:int32`
- `:int64`
- `:float32` 
- `:float64`
- `:complex64`
- `:complex128`
- `:rational64`
- `:rational128`
- `:object` (a ruby object, simply a VALUE)

They're very valuable when you know the kind of data you're going to use beforehand. If you're simply doing some experiments and have no idea what you're going to encounter, stick to the defaults - it's probably int64 or float64.

To create a matrix with a specific `dtype`, you can use `#new` or one of the various [shortcuts that I've already talked about][1]. Some examples:

	>> NMatrix.new([2, 3], [0, 1, 2, 3, 4, 5], :int64).pp
	  [0, 1, 2]
	  [3, 4, 5]
	=> nil 

Here the first parameter is an array representing the dimension of the matrix (2-by-3 in this case), the second parameter are the values used and the third one is the `dtype`. If you're creating a square matrix, you can simply pass an integer as the first parameter.

If there are less values than the number of element in the matrix, they will be repeated as much as necessary.

	>> NMatrix.new([2, 3], [1, 7]).pp
	  [1, 7, 1]
	  [7, 1, 7]
	=> nil 

For complex and rational matrices, you must use Ruby's `Complex` and `Rational` classes.

	>> values = []
	>> 6.times { |i| values << Rational(i, 7) }
	>> values
	=> [(0/1), (1/7), (2/7), (3/7), (4/7), (5/7)] 

	>> NMatrix.new([2, 3], values, :rational64).pp
	  [(0/1), (1/7), (2/7)]
	  [(3/7), (4/7), (5/7)]
	=> nil

	>> values = []
	>> 6.times { |i| values << Complex(i, 2*i) }
	>> values
	=> [(0+0i), (1+2i), (2+4i), (3+6i), (4+8i), (5+10i)] 
	
	>> NMatrix.new([2, 3], values, :complex64).pp
	  [(0.0+0.0i), (1.0+2.0i), (2.0+4.0i)]
	  [(3.0+6.0i), (4.0+8.0i), (5.0+10.0i)]
	=> nil

If you don't specify a `dtype`, `NMatrix` will try to guess (and it'll probably be right).

	>> q = []
	>> 4.times {|i| q << Rational(2, i+1)}
	>> q
	=> [(2/1), (1/1), (2/3), (1/2)] 

	>> NMatrix.new(2, q).dtype
	=> :rational64

And that's it for `dtypes`. As I said, most of the time we're dealing with integers and floating-point numbers, but it's very good to have this kind of machinery for the times when we need it - complex for lots of tasks in signal processing, rationals for number fields (e.g. [Q-lattices in quantum statistical mechanics][2]), uint8 for logical matrices (incidence matrices in graph theory), etc.

## The storage of a matrix

The `stype` is a much less used parameter of NMatrix. It controls how the data of the matrix is stored on memory. It's defined as an `enum` in [ext/nmatrix/nmatrix.h](https://github.com/SciRuby/nmatrix/blob/master/ext/nmatrix/nmatrix.h#L191).

There are only 3 options:

- `:dense`
- `:list`
- `:yale`

The first one is what you should use most of the time. It uses row-major order and is the standard when creating a new matrix with `#new` or the [shortcuts][1].

List matrices are used for sparse storage, but they're generally only used when converting between stypes. It's not very useful from an user's point of view, so you should stick with dense or yale. Defined in [ext/nmatrix/storage/list.cpp](https://github.com/SciRuby/nmatrix/blob/master/ext/nmatrix/storage/list.cpp).

Yale is a standard format for sparse matrices. There are two versions of it: old Yale and new Yale, the difference being that the diagonal values are stored separately in the latter. There's a lot of information about it [on Wikipedia](http://en.wikipedia.org/wiki/Sparse_matrix#Yale_format). NMatrix uses new Yale, which is defined in [ext/nmatrix/storage/list.h](https://github.com/SciRuby/nmatrix/blob/master/ext/nmatrix/storage/list.cpp).

There's a module called `NMatrix::YaleFunctions` with a lot of methods for reflection of Yale matrices: `#yale_ija`, `#yale_ia`, `#yale_ja`, `#yale_d`, `#yale_lu`, `#yale_a`, etc.

## Conclusion

Understanding `dtypes` and `stypes` makes it really simple to create new matrices:

	NMatrix.new([stype, ]dimension, values[, dtype])

- `stype` defines the storage used for the data.
- `dimension` can be an integer for square matrices or an array of arbitrary size.
- `values` is the initial value. If it's an integer, it'll be repeated for the size of the matrix. If it's an array and there are less elements than in the matrix, they'll be repeated as much as necessary, and if there are more elements, some will be ignored.
- `dtype` is used to force how the data is to be stored. If it isn't given, a guess will be made using `values`.

I hope this is all the information necessary for the most common use cases. If you have a suggestion, please use the comments section or post on SciRuby's mailing list.

I'll update this post as possible.

[1]: http://onox.com.br/2012/12/06/how-to-use-nmatrix-shortcuts.html
[2]: http://www.math.fsu.edu/~marcolli/NotesQlattices1.pdf
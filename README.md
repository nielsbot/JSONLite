JSONLite
========

A simple JSON parser that allows looser JSON syntax. 

- You can put C-style line comments //anywhere...
- You dont need to quote object keys unless they "contain spaces"
- You don't need commas to separate key:value pairs
- But, if you use commas, they're allowed after the last key:value pair in an object and after the last value in an array

Non-standard but I love it for my own projects..

Standard JSON:

    {
        "arrayProp": [ 
            "string0", 1.0, 
            "string1" 
        ],
        "objectProp": { "key0":"string0" }
    }

"JSONLite":

    {
        // a comment can go here
        arrayProp: [ 
            "string0" 1.0 
            "string1" // or here...
        ]
        objectProp: { key0:"string0" }
    }

Getting it working
------------------

You will need to install updated versions of `bison` and `flex`. The project expects them to be in `/usr/local/opt/bison` and `/usr/local/opt/flex` respectively. You can use [homebrew][1] to install them in the right place: `brew install bison` and `brew install flex`. After that JSONLite should compile.

[1]: http://brew.sh

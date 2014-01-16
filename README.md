JSONLite
========

A simple JSON parser that allows looser JSON syntax. 

- You can put C-style line comments //anywhere...
- You dont need to quote object keys unless they "contain spaces"
- You don't need commas to separate key:value pairs

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

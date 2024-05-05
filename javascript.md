#### variables
``` js
let x;
var num = 1;
const pi = '3.14';
```

#### object
``` js
const post = {
    user_id = 1,
    content = 'hi mom'
}
```

#### array
``` js
const arr = [];
let statusArr = ['ToDo','WIP','Done']
```

#### build-in functions
``` js
Date(); // returns date and time
concat(); // join two strings, returns new string
push(); // adds item to array
pop(); // removes item from array, returns this item
round(); // rounds value to nearest integer, returns int
length(); // returns the length of string, array etc 
```

#### access element
``` js
let loginInput = document.getElementById('idName');
document.getElementByClass('className');
document.getElementByTagName('tagName');
document.querySelector('cssstyle');

```

#### cookie
``` js
document.cookie = "key1 = value1; key2 = value2; expires = date"; // name-value pairs separated by semicolons
function createCookie(name, value, expirationDays) {
    let dateObject = new Date();
    let date = dateObject.setDate(dateObject.getDate() + expirationDays);
    let expirationDate = date.toUTCString();
    document.cookie = `name = ${name}; value = ${value}; expires = ${expirationDate}; path = /`;
}
```
#### arrow functions
``` js
const hiMom = (name) => {
    console.log(`hi ${name}`)
}
```

### praca w gates
Pracowałem jako IT Application Analyst nad aplikacjami fullstack zbudowanymi w dwóch różnych frameworkach. <br>
Pierwszy to jQuery, ColdFusion SQL Server <br>
Drugi React js, Express JS, SQL Server <br>
w pierwszym frameworku API pisane były poprzez jQuery AJAX, $.ajax, $.post etc. <br>
w drugim axios lub fetch przy użyciu zasad REST <br>
aplikacje polegały na tym samym bez różnicy jaki framework został użyty. 10% to front end, tam dodawałem tylko inputy i zmieniałem ID, nazwy, standaryzacja <br>
30% backend, pisane były funcje (w coldfusion, potem javascript) które były używane do komunikacji z SQL Server, w samym SQL Server działałem w MS SQL Management Studio <br>
Personalnie używam DBeaver to MySQL (Linux Ubuntu) i SQL Server (Windows) <br>
STAR: <br>
Problem: Brak priorytyzacji zadań, używanie OneNote do wrzucania tasków developerom <br>
Zaimplementowałem Listy Sharepoint do obsługi improvementów, dzięki temu mogłem nadać klka customizowanych statusów, oraz kto komu przypisał taska <br>
Ponad To: napisałem flow w PowerAutomate dzięki któremu developerzy oraz requestorzy dostawali maile odnośnie taksów <br>
Wynik: Management został ustawiony co pomogło w priorytyzacji zadań developerom,  <br>
oraz IT od baz danych, ponieważ w liscie ustawilem flage, czy zmiana wpływa na bazy danych (problem w query KPI, SLA) system jest używany do dzisiaj. <br>
``` js
 $.ajax({
        url: apiUrl,
        type: "GET",
        success: function(response) {
            // In this example, we'll just log the response to the console and display it on the page
            console.log(response);
            $("#result").text(JSON.stringify(response));
        },
        error: function(xhr, status, error) {
            console.error("Error:", error);
            $("#result").text("Error: " + error);
        }
    });
```
w drugim poprzez axios lub fetch
``` js
var apiUrl = "https://api.example.com/data";
axios.get(apiUrl)
  .then(function (response) {
    // Handle the successful response from the API
    // In this example, we'll just log the response to the console and display it on the page
    console.log(response.data);
    document.getElementById("result").innerText = JSON.stringify(response.data);
  })
  .catch(function (error) {
    // Handle any errors that occur during the API request
    console.error("Error:", error);
    document.getElementById("result").innerText = "Error: " + error.message;
  });

fetch(apiUrl)
  .then(function(response) {
    // Check if the response is successful
    if (!response.ok) {
      throw new Error("Network response was not ok");
    }
    // Parse the response JSON
    return response.json();
  })
  .then(function(data) {
    // Handle the successful response from the API
    // In this example, we'll just log the response to the console and display it on the page
    console.log(data);
    document.getElementById("result").innerText = JSON.stringify(data);
  })
  .catch(function(error) {
    // Handle any errors that occur during the API request
    console.error("Error:", error);
    document.getElementById("result").innerText = "Error: " + error.message;
  });
```

### backend javascript
npm install express pg
``` js
const express = require('express');
const { Pool } = require('pg');
const app = express();
const PORT = 3000;

// PostgreSQL database configuration
const pool = new Pool({
  user: 'your_username',
  host: 'localhost',
  database: 'your_database_name',
  password: 'your_password',
  port: 5432,
});

// Middleware to parse JSON bodies
app.use(express.json());

// Route to get a specific user by ID
app.get('/users/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    const rows = result.rows;
    if (rows.length === 0) {
      res.status(404).json({ error: 'User not found' });
    } else {
      res.json(rows[0]);
    }
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
```

#### variables
``` js
let x;
var num = 1;
const pi = '3.14';
scope, hoisting, and redeclaration
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
test();
exec(); //
require(): Used to import modules in Node.js.
module.exports: Used to export functions, objects, or primitive values from a module.
process.env: Provides access to environment variables.
console.log(): Outputs messages to the console.
setTimeout(): Executes a function after a specified delay.
setInterval(): Executes a function at specified intervals.
clearTimeout(): Cancels a timeout previously established with setTimeout().
clearInterval(): Cancels an interval previously established with setInterval().
JSON.stringify(): Converts a JavaScript object or value to a JSON string.
JSON.parse(): Parses a JSON string, converting it to a JavaScript object.
fs.readFileSync(): Reads the contents of a file synchronously.
fs.writeFileSync(): Writes data to a file synchronously.
fs.readFile(): Reads the contents of a file asynchronously.
fs.writeFile(): Writes data to a file asynchronously.
fs.existsSync(): Checks if a file or directory exists.
fs.mkdirSync(): Creates a directory synchronously.
fs.mkdir(): Creates a directory asynchronously.
fs.unlinkSync(): Deletes a file synchronously.
fs.unlink(): Deletes a file asynchronously.
fs.readdirSync(): Reads the contents of a directory synchronously.
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

#### passing objects in functions:
By Value means creating a COPY of the original. they are born exactly the same, but can differ later
By Reference means creating an ALIAS to the original, but its still the same

#### API
``` js
// API to zestaw metod dostępnych w postaci adresów URI (endpointów)
// endpoint: https://github.com/skubichrupki/:user
// response:
[
    {
        name: "michu",
        id: 20
    }
]
```
REST API to standard określający zasady projektowania API
WEB REST API:
GET /movies (select, read)
POST /movies (create)
PUT /movies/:id (update)
DELETE /movies/:id (delete)

REST RULES:
1: Uniform Interface: one api for client/server communication <br>
2: Client-server: client and server application should be seperated <br>
3: Stateless: server should not store info, client should send it every time <br>
4: Cacheable: API should support caching data to increase performance <br>
5: Layered system: Client does not need to know about server actions <br>
6: (optional) Code on Demand: server response is fragment of code that client can use  <br>
<br>
Resource (Zasób): data with name (noun like 'user'), unique, has URI (it's name and address)
Naming Convention: liczba pojedyncza vs mnoga, standaryzacja, bez czasowników
JSON, YAML, XML (YAML ma wcięcia jak Python), XML ma Tagi

API: /api/v1/users/:id
punkt wejścia/wersja/kolekcja zasobów/identyfikator zasobu
- /api/v1/users/:id/comments/:comment-id
paramentry adresu URL:
- api/v1/users?fields=name,email&offset=10 (parametry: nazwa=wartość&)


### session storage, local storage
Local Storage – The data is not sent back to the server for every HTTP request – reducing the amount of traffic between client and server. 
It will stay until it is manually cleared through settings or program.

Session Storage – in local storage data has no expiration time, 
data stored in session storage gets cleared when the page session ends. 

### status codes
200: OK
404: Not Found
500: Internal Server Error
And more: There are status codes for various scenarios, such as redirection (3xx), client errors (4xx), and server errors (5xx).




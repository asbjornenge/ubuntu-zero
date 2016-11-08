var http = require('http')

http.createServer(function(req, res) {
  console.log('RECEIVED METHOD '+req.method)
  if (req.method == 'POST') {
    var data = ''
    req.on('data', (chunk) => {
      data += chunk.toString()
    })
    req.on('end', () => {
      console.log(data)
      res.writeHead(200, 'OK', {'Content-Type': 'text/html'})
      res.end(data)
    })
  }
  else {
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('okay')
  }
}).listen(3000, function() {
  console.log('Listening to port 3000')
})


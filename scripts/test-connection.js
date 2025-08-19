#!/usr/bin/env node

const http = require('http');

const options = {
  hostname: '127.0.0.1',
  port: 5123,
  path: '/health',
  method: 'GET'
};

console.log('Testing WebPrint Agent connection...');
console.log(`Connecting to http://${options.hostname}:${options.port}/health`);

const req = http.request(options, (res) => {
  console.log(`Status: ${res.statusCode}`);
  console.log(`Headers: ${JSON.stringify(res.headers, null, 2)}`);
  
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    try {
      const response = JSON.parse(data);
      console.log('Response:', JSON.stringify(response, null, 2));
      
      if (response.status === 'ok') {
        console.log('✅ Connection successful!');
        console.log(`OS: ${response.os}`);
        console.log(`Architecture: ${response.arch}`);
        console.log(`Version: ${response.version}`);
      } else {
        console.log('❌ Unexpected response status');
      }
    } catch (e) {
      console.log('❌ Failed to parse response:', e.message);
      console.log('Raw response:', data);
    }
  });
});

req.on('error', (e) => {
  console.log('❌ Connection failed:', e.message);
  console.log('');
  console.log('Make sure the WebPrint Agent is running:');
  console.log('  npm run dev    # for development');
  console.log('  npm run start  # for production');
});

req.end();

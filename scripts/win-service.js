const Service = require('node-windows').Service;
const path = require('path');

// Create a new service object
const svc = new Service({
  name: 'WebPrint Agent',
  description: 'Local bridge for silent PDF printing from web apps',
  script: path.join(__dirname, '..', 'dist', 'index.js'),
  nodeOptions: [],
  env: [
    {
      name: 'NODE_ENV',
      value: 'production'
    }
  ]
});

// Listen for the install event
svc.on('install', function() {
  console.log('Service installed successfully');
  console.log('Starting service...');
  svc.start();
});

// Listen for the start event
svc.on('start', function() {
  console.log('Service started successfully');
});

// Listen for the alreadyinstalled event
svc.on('alreadyinstalled', function() {
  console.log('Service is already installed');
});

// Listen for the uninstall event
svc.on('uninstall', function() {
  console.log('Service uninstalled successfully');
});

// Listen for the error event
svc.on('error', function(err) {
  console.error('Service error:', err);
});

const command = process.argv[2];

if (command === 'install') {
  console.log('Installing WebPrint Agent service...');
  svc.install();
} else if (command === 'uninstall') {
  console.log('Uninstalling WebPrint Agent service...');
  svc.uninstall();
} else if (command === 'start') {
  console.log('Starting WebPrint Agent service...');
  svc.start();
} else if (command === 'stop') {
  console.log('Stopping WebPrint Agent service...');
  svc.stop();
} else {
  console.log('Usage: node win-service.js [install|uninstall|start|stop]');
  console.log('');
  console.log('Commands:');
  console.log('  install   - Install and start the service');
  console.log('  uninstall - Stop and remove the service');
  console.log('  start     - Start the service');
  console.log('  stop      - Stop the service');
}

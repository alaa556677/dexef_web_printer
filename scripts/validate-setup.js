#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

console.log('🔍 Validating WebPrint Agent Setup...\n');

let allGood = true;

// Check package.json
console.log('📦 Checking package.json...');
if (fs.existsSync('package.json')) {
  try {
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    console.log(`   ✅ Package name: ${pkg.name}`);
    console.log(`   ✅ Version: ${pkg.version}`);
  } catch (e) {
    console.log('   ❌ Invalid package.json');
    allGood = false;
  }
} else {
  console.log('   ❌ package.json not found');
  allGood = false;
}

// Check TypeScript config
console.log('\n⚙️  Checking TypeScript configuration...');
if (fs.existsSync('tsconfig.json')) {
  console.log('   ✅ tsconfig.json found');
} else {
  console.log('   ❌ tsconfig.json not found');
  allGood = false;
}

// Check source files
console.log('\n📁 Checking source files...');
const requiredFiles = [
  'src/index.ts',
  'src/server.ts',
  'src/routes/health.ts',
  'src/routes/printers.ts',
  'src/routes/print.ts',
  'src/routes/jobs.ts',
  'src/services/config.ts',
  'src/services/security.ts',
  'src/services/logger.ts',
  'src/services/printers-win.ts',
  'src/services/printers-posix.ts',
  'src/services/print-win.ts',
  'src/services/print-posix.ts'
];

requiredFiles.forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`   ✅ ${file}`);
  } else {
    console.log(`   ❌ ${file} missing`);
    allGood = false;
  }
});

// Check configuration
console.log('\n⚙️  Checking configuration...');
if (fs.existsSync('config/default.json')) {
  console.log('   ✅ config/default.json found');
} else {
  console.log('   ❌ config/default.json missing');
  allGood = false;
}

// Check SumatraPDF directory (Windows)
console.log('\n🖨️  Checking SumatraPDF setup...');
if (fs.existsSync('vendor/sumatra/')) {
  if (fs.existsSync('vendor/sumatra/SumatraPDF.exe')) {
    console.log('   ✅ SumatraPDF.exe found');
  } else {
    console.log('   ⚠️  SumatraPDF.exe not found (required for Windows)');
    console.log('      Download from: https://www.sumatrapdfreader.org/download-free-pdf-viewer');
    console.log('      Place in vendor/sumatra/ directory');
  }
} else {
  console.log('   ⚠️  vendor/sumatra/ directory not found');
}

// Check scripts
console.log('\n📜 Checking scripts...');
const scripts = [
  'scripts/win-service.js',
  'scripts/test-connection.js',
  'scripts/start-agent.bat',
  'scripts/start-agent.ps1'
];

scripts.forEach(script => {
  if (fs.existsSync(script)) {
    console.log(`   ✅ ${script}`);
  } else {
    console.log(`   ❌ ${script} missing`);
    allGood = false;
  }
});

// Check documentation
console.log('\n📚 Checking documentation...');
const docs = [
  'README.md',
  'QUICKSTART.md',
  'api.http'
];

docs.forEach(doc => {
  if (fs.existsSync(doc)) {
    console.log(`   ✅ ${doc}`);
  } else {
    console.log(`   ❌ ${doc} missing`);
    allGood = false;
  }
});

// Summary
console.log('\n' + '='.repeat(50));
if (allGood) {
  console.log('🎉 Setup validation passed! You\'re ready to go.');
  console.log('\nNext steps:');
  console.log('1. npm install');
  console.log('2. npm run build');
  console.log('3. npm run dev');
} else {
  console.log('⚠️  Setup validation failed. Please fix the issues above.');
  console.log('\nAfter fixing issues, run this script again.');
}

console.log('\nFor help, see README.md or QUICKSTART.md');

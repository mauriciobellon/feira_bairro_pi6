#!/usr/bin/env node

/**
 * Database Migration Script
 * 
 * This script runs SQL migrations in order:
 * 1. 01-schema.sql - Creates tables, indexes, and constraints
 * 2. 02-seed-data.sql - Inserts sample data (optional)
 * 
 * Usage:
 *   npm run migrate              # Run all migrations
 *   npm run migrate -- --schema-only  # Run only schema (skip seed data)
 * 
 * Environment variables required:
 *   DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD, DB_SSL
 */

const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

// Parse command line arguments
const args = process.argv.slice(2);
const schemaOnly = args.includes('--schema-only');

// Configuration
const config = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME || 'feira_bairro',
  user: process.env.DB_USER || 'feira_user',
  password: process.env.DB_PASSWORD || 'feira_password',
  ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  connectionTimeoutMillis: 30000,
};

// SQL files to execute in order
const sqlFiles = [
  { path: '../database/01-schema.sql', name: 'Schema', required: true },
  { path: '../database/02-seed-data.sql', name: 'Seed Data', required: false, skipIfSchemaOnly: true },
];

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

function logSuccess(message) {
  log(`✅ ${message}`, colors.green);
}

function logError(message) {
  log(`❌ ${message}`, colors.red);
}

function logWarning(message) {
  log(`⚠️  ${message}`, colors.yellow);
}

function logInfo(message) {
  log(`ℹ️  ${message}`, colors.blue);
}

async function checkConnection(client) {
  try {
    const result = await client.query('SELECT version()');
    logSuccess('Database connection established');
    logInfo(`PostgreSQL version: ${result.rows[0].version.split(',')[0]}`);
    return true;
  } catch (error) {
    logError(`Database connection failed: ${error.message}`);
    return false;
  }
}

async function executeSqlFile(client, filePath, fileName) {
  const absolutePath = path.resolve(__dirname, filePath);
  
  // Check if file exists
  if (!fs.existsSync(absolutePath)) {
    logError(`File not found: ${absolutePath}`);
    throw new Error(`Migration file not found: ${fileName}`);
  }

  // Read SQL file
  const sql = fs.readFileSync(absolutePath, 'utf8');
  
  if (!sql.trim()) {
    logWarning(`File is empty: ${fileName}`);
    return;
  }

  logInfo(`Executing: ${fileName}`);
  
  try {
    // Execute the SQL
    await client.query(sql);
    logSuccess(`${fileName} executed successfully`);
  } catch (error) {
    // Check if error is about duplicate objects (already exists)
    if (error.message.includes('already exists')) {
      logWarning(`${fileName}: Some objects already exist (this is normal for re-runs)`);
    } else {
      logError(`${fileName} failed: ${error.message}`);
      throw error;
    }
  }
}

async function runMigrations() {
  log('\n' + '='.repeat(60), colors.bright);
  log('Database Migration Script', colors.bright);
  log('='.repeat(60) + '\n', colors.bright);

  // Display configuration (hide password)
  logInfo('Configuration:');
  console.log(`  Host: ${config.host}`);
  console.log(`  Port: ${config.port}`);
  console.log(`  Database: ${config.database}`);
  console.log(`  User: ${config.user}`);
  console.log(`  SSL: ${config.ssl ? 'enabled' : 'disabled'}`);
  console.log('');

  if (schemaOnly) {
    logInfo('Running in schema-only mode (skipping seed data)');
    console.log('');
  }

  const client = new Client(config);

  try {
    // Connect to database
    logInfo('Connecting to database...');
    await client.connect();
    
    // Check connection
    const connected = await checkConnection(client);
    if (!connected) {
      throw new Error('Failed to establish database connection');
    }
    console.log('');

    // Execute migrations
    log('Running migrations...', colors.bright);
    console.log('');

    for (const file of sqlFiles) {
      // Skip if schema-only mode and file should be skipped
      if (schemaOnly && file.skipIfSchemaOnly) {
        logInfo(`Skipping: ${file.name} (schema-only mode)`);
        continue;
      }

      try {
        await executeSqlFile(client, file.path, file.name);
      } catch (error) {
        if (file.required) {
          throw error;
        } else {
          logWarning(`${file.name} failed but is optional, continuing...`);
        }
      }
    }

    console.log('');
    log('='.repeat(60), colors.bright);
    logSuccess('All migrations completed successfully!');
    log('='.repeat(60) + '\n', colors.bright);

    // Verify tables exist
    logInfo('Verifying database structure...');
    const tableCheck = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name
    `);
    
    if (tableCheck.rows.length > 0) {
      logSuccess(`Found ${tableCheck.rows.length} tables:`);
      tableCheck.rows.forEach(row => {
        console.log(`  - ${row.table_name}`);
      });
    } else {
      logWarning('No tables found in database');
    }

    console.log('');
    process.exit(0);

  } catch (error) {
    console.log('');
    log('='.repeat(60), colors.bright);
    logError('Migration failed!');
    log('='.repeat(60), colors.bright);
    console.error('\nError details:');
    console.error(error.message);
    console.log('');
    
    logInfo('Troubleshooting tips:');
    console.log('  1. Verify database credentials are correct');
    console.log('  2. Ensure database server is accessible');
    console.log('  3. Check if database exists');
    console.log('  4. Verify SQL files are present in database/ directory');
    console.log('  5. Check database logs for more details');
    console.log('');
    
    process.exit(1);
  } finally {
    await client.end();
  }
}

// Run migrations
runMigrations();


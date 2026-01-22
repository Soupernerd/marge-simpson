const fs = require('fs');
const path = require('path');

const htmlPath = path.join(__dirname, '2space.html');
const htmlContent = fs.readFileSync(htmlPath, 'utf8');

function test(description, fn) {
    try {
        fn();
        console.log(`✓ ${description}`);
        return true;
    } catch (error) {
        console.error(`✗ ${description}`);
        console.error(`  Error: ${error.message}`);
        return false;
    }
}

function assert(condition, message) {
    if (!condition) {
        throw new Error(message || 'Assertion failed');
    }
}

console.log('Running tests for 2space.html...\n');

let passed = 0;
let failed = 0;

// Test 1: File exists and is not empty
if (test('2space.html exists and is not empty', () => {
    assert(htmlContent.length > 0, 'File should not be empty');
})) passed++; else failed++;

// Test 2: Has valid HTML structure
if (test('has valid HTML5 doctype', () => {
    assert(htmlContent.includes('<!DOCTYPE html>'), 'Should have HTML5 doctype');
})) passed++; else failed++;

// Test 3: Has html tag with lang attribute
if (test('has html tag with lang attribute', () => {
    assert(htmlContent.includes('<html lang="en">'), 'Should have html tag with lang attribute');
})) passed++; else failed++;

// Test 4: Has proper head section
if (test('has proper head section with charset and viewport', () => {
    assert(htmlContent.includes('<meta charset="UTF-8">'), 'Should have charset meta tag');
    assert(htmlContent.includes('viewport'), 'Should have viewport meta tag');
})) passed++; else failed++;

// Test 5: Has title related to space
if (test('has title related to space', () => {
    assert(htmlContent.toLowerCase().includes('<title>') &&
           htmlContent.toLowerCase().includes('space'),
           'Should have a title containing "space"');
})) passed++; else failed++;

// Test 6: Has heading with space theme
if (test('has heading with space theme', () => {
    assert(htmlContent.includes('<h1>') &&
           htmlContent.toLowerCase().includes('space'),
           'Should have h1 heading about space');
})) passed++; else failed++;

// Test 7: Contains space-related elements (emojis or icons)
if (test('contains space elements', () => {
    const hasSpaceEmojis = /🌍|🪐|🔴|🟠|☀️|⭐|🌌|🌟|🌙|💫/.test(htmlContent);
    const hasSpaceClass = htmlContent.includes('celestial') || htmlContent.includes('planet') || htmlContent.includes('star');
    assert(hasSpaceEmojis || hasSpaceClass, 'Should contain space emojis or space CSS elements');
})) passed++; else failed++;

// Test 8: Has CSS styling
if (test('has CSS styling', () => {
    assert(htmlContent.includes('<style>'), 'Should have inline CSS styles');
})) passed++; else failed++;

// Test 9: Has cosmos/space container
if (test('has cosmos container element', () => {
    assert(htmlContent.includes('cosmos') || htmlContent.includes('space-container'), 'Should have a cosmos or space container');
})) passed++; else failed++;

// Test 10: Has multiple celestial elements
if (test('has multiple celestial elements', () => {
    const celestialCardCount = (htmlContent.match(/celestial-card/g) || []).length;
    assert(celestialCardCount >= 3, 'Should have at least 3 celestial elements');
})) passed++; else failed++;

// Test 11: Has CSS animations
if (test('has CSS animations', () => {
    assert(htmlContent.includes('@keyframes'), 'Should have CSS keyframe animations');
    assert(htmlContent.includes('animation'), 'Should use animation property');
})) passed++; else failed++;

// Test 12: Has proper closing tags
if (test('has proper closing tags', () => {
    assert(htmlContent.includes('</body>'), 'Should have closing body tag');
    assert(htmlContent.includes('</html>'), 'Should have closing html tag');
})) passed++; else failed++;

// Test 13: Has planet/celestial body names
if (test('has celestial body names displayed', () => {
    assert(htmlContent.includes('planet-name') || htmlContent.includes('celestial'),
           'Should have celestial name elements');
    assert(htmlContent.toLowerCase().includes('earth') ||
           htmlContent.toLowerCase().includes('mars') ||
           htmlContent.toLowerCase().includes('saturn'),
           'Should include planet names');
})) passed++; else failed++;

// Test 14: Has planet/celestial body info
if (test('has celestial body info displayed', () => {
    assert(htmlContent.includes('planet-info') || htmlContent.includes('planet-stats'),
           'Should have planet info elements');
})) passed++; else failed++;

// Test 15: Has footer
if (test('has footer element', () => {
    assert(htmlContent.includes('<footer>'), 'Should have a footer element');
})) passed++; else failed++;

// Test 16: Has interactive JavaScript
if (test('has interactive JavaScript', () => {
    assert(htmlContent.includes('<script>'), 'Should have JavaScript');
    assert(htmlContent.includes('onclick') || htmlContent.includes('addEventListener'),
           'Should have event handlers for interactivity');
})) passed++; else failed++;

// Test 17: Has interactive controls/buttons
if (test('has interactive controls', () => {
    assert(htmlContent.includes('<button') || htmlContent.includes('control-btn'),
           'Should have interactive buttons or controls');
})) passed++; else failed++;

// Test 18: Has star field effect
if (test('has star field effect', () => {
    assert(htmlContent.includes('star') && htmlContent.includes('createStars'),
           'Should have a star field effect');
})) passed++; else failed++;

// Test 19: Has multiple interactive features
if (test('has multiple interactive features', () => {
    const hasToggle = htmlContent.includes('toggleCard') || htmlContent.includes('toggle');
    const hasFilter = htmlContent.includes('filterView') || htmlContent.includes('filter');
    const hasFact = htmlContent.includes('showRandomFact') || htmlContent.includes('fact');
    assert(hasToggle || hasFilter || hasFact, 'Should have at least one interactive feature');
})) passed++; else failed++;

// Test 20: Has keyboard navigation
if (test('has keyboard navigation', () => {
    assert(htmlContent.includes('keydown') || htmlContent.includes('keypress'),
           'Should support keyboard navigation');
})) passed++; else failed++;

console.log(`\n${'='.repeat(40)}`);
console.log(`Tests: ${passed} passed, ${failed} failed`);
console.log(`${'='.repeat(40)}`);

process.exit(failed > 0 ? 1 : 0);

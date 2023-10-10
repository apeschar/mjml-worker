#!/usr/bin/env node

const mjml2html = require("mjml");
const readline = require("readline");

async function main() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: null,
    terminal: false,
  });

  for await (const input of rl) {
    let ref, mjml;
    ({ ref, mjml } = JSON.parse(input));
    try {
      const html = mjml2html(mjml);
      console.log(JSON.stringify({ ref, html: html.html }));
    } catch (e) {
      console.log(JSON.stringify({ ref, error: e.message }));
    }
  }
}

main();

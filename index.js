#!/usr/bin/env node
const fs = require('fs');
const fetch = require('node-fetch');
const XLSX = require('xlsx');
const Foswig = require('foswig');


const CHAIN_SIZE = 3;
const MIN_LENGTH = 5;
const MAX_LENGTH = 10;
const NUMBER_OF_NAMES = 10;

const FILENAME = 'sukunimitilasto.xls';

function fetchData() {
    if (fs.existsSync(FILENAME)) {
        return Promise.resolve(FILENAME);
    } else {
        console.log('Fetching list of names...');
        return fetch('https://www.avoindata.fi/data/dataset/57282ad6-3ab1-48fb-983a-8aba5ff8d29a/resource/af5b50bf-094e-41a5-bdde-80f5c4e11620/download/Sukunimitilasto-2017-04-06-VRK.xls')
            .then(response => response.buffer())
            .then(body => fs.writeFileSync(FILENAME, body))
            .then(() => FILENAME);
    }
}

function loadData() {
    console.log('Loading names...');
    return fetchData()
        .then(filename => XLSX.readFile(filename))
        .then(workbook => workbook.Sheets['Nimet'])
        .then(worksheet => XLSX.utils.sheet_to_json(worksheet))
        .then(json => json.map(row => row['Sukunimi']));
}

function generateModel(names) {
    console.log(`Generatings Markov Chain of size ${CHAIN_SIZE}...`);
    var chain = new Foswig(CHAIN_SIZE);
    chain.addWordsToChain(names);
    return chain;
}

function generateNames(model) {
    console.log(`Generating ${NUMBER_OF_NAMES} names...\n`);

    const names = [];
    while(names.length < NUMBER_OF_NAMES) {
        const name = model.generateWord(MIN_LENGTH, MAX_LENGTH, false);
        names.push(name);
    }

    return names;
}

function isNameAvailable(name) {
    return fetch('https://verkkopalvelu.vrk.fi/nimipalvelu/nimipalvelu_sukunimihaku.asp', {
        body: `nimi=${name}&submit2=HAE`,
    })
    .then(response => response.text())
    .then(body => {
        const nameAvailable = body.indexOf('Väestötietojärjestelmässä ei ole hakemaasi sukunimeä') === -1;
        return nameAvailable;
    });
}


function main() {
    loadData()
        .then(names => generateModel(names))
        .then(model => generateNames(model))
        .then(newNames => newNames.forEach(name => {
            isNameAvailable(name)
                .then(nameAvailable => {
                    if (nameAvailable) {
                        console.log(name);
                    } else {
                        console.log(`${name} is already taken!`);
                    }
                });
        })
    );
}

main();

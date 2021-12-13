const readInput = filename => {
    const fs = require('fs');
    return fs.readFileSync(filename, 'utf8').trim().split('\n');
}

const transpose = matrix => matrix[0].map((_, index) => matrix.map(row => row[index]));

const countElements = array => array.map(element => element.reduce((acc, el) => {
    if (!acc[el]) {
        acc[el] = 1;
    } else {
        acc[el] += 1
    }
    return acc;
}, {}));


const filterFor = (func, bit) => (elements) => elements.map(element => Object.keys(element).reduce((a, b) => {
    if(element[a] === element[b]) {
        return bit;
    }
    return func(element[a], element[b]) ? a : b;
}));

const mostCommon = (bit) => filterFor((a, b) => a > b, bit);

const leastCommon = (bit) => filterFor((a, b) => a < b, bit);

const flipbits = bits => bits.map(bit => (1 - bit));

const toDecimal = binaryArray => parseInt(binaryArray.join(''), 2);

const partOne = input => {
    const matrix = input.map(element => element.split(''));
    const transposed = transpose(matrix);
    const gamma = mostCommon('1')(countElements(transposed));
    const epsilon = flipbits(gamma);
    return toDecimal(gamma) * toDecimal(epsilon);
}

const partTwo = (input) => {
    const findRating = (matrix, filter, index) => {
        if (matrix.length === 1) {
            return matrix[0];
        }
        const transposed = transpose(matrix);
        const pattern = filter(countElements(transposed));
        const filtered = matrix.filter(element => element[index] === pattern[index]);
        return findRating(filtered, filter, ++index);
    }

    const matrix = input.map(element => element.split(''));
    const oxygenGeneratorRating = toDecimal(findRating(matrix, mostCommon('1'), 0));
    const CO2scrubberRating = toDecimal(findRating(matrix, leastCommon('0'), 0));
    return oxygenGeneratorRating * CO2scrubberRating;
}

const input = readInput('input.txt');
console.log('Part one: ' + partOne(input));
console.log('Part two: ' + partTwo(input));
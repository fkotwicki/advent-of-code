const readInput = (filename) => {
    const fs = require('fs');
    return fs.readFileSync(filename, 'utf8').split('\n').map(element => parseInt(element));    
}

const partOne = (input) => {
    return input.filter((element, index, array) => element && index != 0 && element > array[index - 1]).length
}

const partTwo = (input) => {
    const sumOfWindows = input.map((element, index, array) => index < array.length - 2 ? element + array[index + 1] + array[index + 2] : NaN);
    return partOne(sumOfWindows);
}

const input = readInput('input.txt');
console.log('Part one: ' + partOne(input));
console.log('Part two: ' + partTwo(input));
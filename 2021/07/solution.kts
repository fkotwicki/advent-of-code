import java.io.File
import kotlin.math.abs

fun readFile(name: String) = File(name).readText()

fun catchCrabs(input: String) = input.trim().split(',').map { it.toInt() }

fun calculateCheapestFuelCost(crabs: List<Int>, fuelCalculator: (Int) -> Int): Int {
    val maxPosition = crabs.maxOrNull()!!
    val minPosition = crabs.minOrNull()!!
    val positions =
        (minPosition..maxPosition).map { position -> position to crabs.sumOf { crab -> fuelCalculator(abs(crab - position)) } }
    return positions.minByOrNull { it.second }?.second!!
}

fun partOne(input: String) = calculateCheapestFuelCost(catchCrabs(input)) { distance -> distance }

fun partTwo(input: String) = calculateCheapestFuelCost(catchCrabs(input)) { distance -> distance * (distance + 1) /2 }

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part two: ${partTwo(input)}")

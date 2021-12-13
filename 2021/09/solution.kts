import java.io.File

fun readFile(name: String) = File(name).useLines { it.toList() }

fun parseSmokeFlows(input: List<String>) = input.mapIndexed { colIndex, row ->
    row.trim().toCharArray()
        .mapIndexed { rowIndex, value -> Point(rowIndex, colIndex, Character.getNumericValue(value)) }
}.let { HeightMap(it) }

data class Point(val x: Int, val y: Int, val value: Int)

class HeightMap(private val points: List<List<Point>>) {

    fun getLowPoints(): List<Point> {
        val lowPoints = mutableListOf<Point>()
        points.forEach { row ->
            row.forEach { point ->
                surroundedBy(point, row).all {
                    point.value < it.value
                }.takeIf { it }?.also {
                    lowPoints.add(point)
                }
            }
        }

        return lowPoints
    }

    fun getBasins(): List<Int> {
        val basins = mutableListOf<Set<Point>>()
        val lowPoints = getLowPoints()
        lowPoints.forEach {
            basins.add(calculateBasin(it))
        }
        return basins.map { it.size }.sortedDescending().take(3)
    }

    private fun surroundedBy(point: Point, row: List<Point>): List<Point> {
        val above = if (point.y == 0) null else points[point.y - 1][point.x]
        val below = if (point.y == points.size - 1) null else points[point.y + 1][point.x]
        val left = if (point.x == 0) null else row[point.x - 1]
        val right = if (point.x == row.size - 1) null else row[point.x + 1]
        return listOfNotNull(above, below, left, right)
    }

    private fun calculateBasin(point: Point): Set<Point> {
        var currentBasin = setOf(point)
        var newBasin: MutableSet<Point>
        while (true) {
            newBasin = newBasin(currentBasin)
            if (currentBasin.size == newBasin.size) return newBasin
            currentBasin = newBasin
        }
    }

    private fun newBasin(currentBasin: Set<Point>): MutableSet<Point> {
        val newBasin = currentBasin.toMutableSet()
        currentBasin.forEach { point ->
            newBasin.addAll(surroundedBy(point, points[point.y]).filter { it.value != 9 })
        }
        return newBasin
    }

}

fun partOne(input: List<String>) = parseSmokeFlows(input).getLowPoints().sumOf { it.value + 1 }

fun partTwo(input: List<String>) = parseSmokeFlows(input).getBasins().reduce { acc, next -> acc * next }

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part two: ${partTwo(input)}")

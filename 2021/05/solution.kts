import java.io.File
import kotlin.math.abs
import kotlin.math.max

fun readFile(name: String) = File(name).useLines { it.toList() }

fun parseLines(input: List<String>) = input.map { row ->
    val points = row.split(" -> ")
    val start = points[0].split(",")
    val end = points[1].split(",")
    Line(Point(start[0].toInt(), start[1].toInt()), Point(end[0].toInt(), end[1].toInt()))
}

data class Point(val x: Int, val y: Int) {
    override fun toString() = "$x,$y"
}

data class Line(val start: Point, val end: Point) {
    override fun toString() = "Line($start -> $end)"

    fun isStraight() = isHorizontal() || isVertical()

    private fun isHorizontal() = start.y == end.y

    private fun isVertical() = start.x == end.x

    fun coveredPoints(): List<Point> {
        val lengthX = abs(end.x - start.x)
        val lengthY = abs(end.y - start.y)
        val deltaX = delta(start.x, end.x)
        val deltaY = delta(start.y, end.y)
        return (0..max(lengthX, lengthY)).map {
            Point(start.x + deltaX * it, start.y + deltaY * it)
        }
    }

    private fun delta(start: Int, end: Int): Int {
        val length = abs(end - start)
        return if (length > 0) (end - start) / length else 0
    }
}

fun partOne(input: List<String>): Int {
    val lines = parseLines(input)
    val diagram = mutableMapOf<Point, Int>()
    lines
        .filter { it.isStraight() }
        .forEach { line ->
            line.coveredPoints().forEach { point ->
                diagram[point] = (diagram[point] ?: 0) + 1
            }
        }
    return diagram.values.filter { it >= 2 }.size
}

fun partTwo(input: List<String>): Int {
    val lines = parseLines(input)
    val diagram = mutableMapOf<Point, Int>()
    lines.forEach { line ->
        line.coveredPoints().forEach { point ->
            diagram[point] = (diagram[point] ?: 0) + 1
        }
    }
    return diagram.values.filter { it >= 2 }.size
}

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part two: ${partTwo(input)}")
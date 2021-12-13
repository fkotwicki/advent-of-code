import Solution.CommandProcessor
import java.io.File

fun readFile(name: String) = File(name).useLines { it.toList() }

data class Position(val horizontal: Int, val depth: Int, val aim: Int = 0)

data class Command(val action: String, val units: Int)

typealias CommandProcessor = (Position, Command) -> Position

fun process(input: List<String>, processor: CommandProcessor) = input.map { it.split(" ").run { Command(get(0), get(1).toInt()) } }
        .fold(Position(0, 0), processor)
        .let { it.depth * it.horizontal }

val partOne: CommandProcessor = { currentPosition, command ->
    when (command.action) {
        "forward" -> currentPosition.copy(horizontal = currentPosition.horizontal + command.units)
        "down" -> currentPosition.copy(depth = currentPosition.depth + command.units)
        "up" -> currentPosition.copy(depth = currentPosition.depth - command.units)
        else -> throw IllegalArgumentException("Unknown command!")
    }
}

val partTwo: CommandProcessor = { currentPosition, command ->
    when (command.action) {
        "forward" -> currentPosition.copy(horizontal = currentPosition.horizontal + command.units, depth = currentPosition.depth + (currentPosition.aim * command.units))
        "down" -> currentPosition.copy(aim = currentPosition.aim + command.units)
        "up" -> currentPosition.copy(aim = currentPosition.aim - command.units)
        else -> throw IllegalArgumentException("Unknown command!")
    }
}

val input = readFile("input.txt")
println("Part one: ${process(input, partOne)}")
println("Part two:  ${process(input, partTwo)}")

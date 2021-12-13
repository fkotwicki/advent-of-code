import java.io.File

fun readFile(name: String) = File(name).useLines { it.toList() }

fun readBoards(input: List<String>) = input.drop(2)
        .filter { it.isNotEmpty() }
        .windowed(5, 5)
        .map { row ->
            Board(row.map { fields ->
                    FieldRow(fields.trim().split("\\s+".toRegex()).map { Field(it.toInt(), false) })
                }
            )
        }

class Field(val number: Int, var isMarked: Boolean)

class FieldRow(private val fields: List<Field>) {

    fun markField(number: Int) {
        fields.firstOrNull { it.number == number }?.apply {
            isMarked = true
        }
    }

    fun areAllFieldsMarked() = fields.all { it.isMarked }

    fun isFieldMarkedAt(position: Int) = fields[position].isMarked

    fun notMarked() = fields.filter { it.isMarked.not() }
}

class Board(private val rows: List<FieldRow>) {

    fun mark(number: Int) {
        rows.forEach { it.markField(number) }
    }

    fun isWinning(): Boolean {
        val rows = rows.map { row ->
            row.areAllFieldsMarked()
        }.any { it }

        val cols = (this.rows.indices).map { col ->
            this.rows.map { row ->
                row.isFieldMarkedAt(col)
            }.all { it }
        }.any { it }

        return rows || cols
    }

    fun score(winningNumber: Int) = rows
                .flatMap { row -> row.notMarked() }
                .sumOf { it.number } * winningNumber

}


class Bingo(private val boards: List<Board>) {

    fun isAnyWinning() = boards.any { it.isWinning() }

    fun areAllWinning() = boards.all { it.isWinning() }

    fun call(number: Int) {
        boards.forEach {
            it.mark(number)
        }
    }

    fun winner() = boards.firstOrNull { it.isWinning() }

    fun filterOutWinners() = Bingo(boards.filter { it.isWinning().not() })

}

fun partOne(input: List<String>): Int? {
    val numbers = input[0].split(",").map { it.toInt() }
    val boards = readBoards(input)
    val bingo = Bingo(boards)

    numbers.forEach { number ->
        bingo.call(number)
        if(bingo.isAnyWinning()) {
            return bingo.winner()?.score(number)
        }
    }

    return null
}

fun partTwo(input: List<String>): Int? {
    val numbers = input[0].split(",").map { it.toInt() }
    val boards = readBoards(input)

    var bingo = Bingo(boards)
    numbers.forEach { number ->
        bingo.call(number)
        if(bingo.areAllWinning()) {
            return bingo.winner()?.score(number)
        }
        bingo = bingo.filterOutWinners()
    }

    return null
}

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part one: ${partTwo(input)}")
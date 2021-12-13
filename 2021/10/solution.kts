package day10

import java.io.File

fun readFile(name: String) = File(name).useLines { it.toList() }

fun parseChunksLines(input: List<String>) = input.map {
    ChunksLine(it.trim())
}

object Chunks {
    private val chunks = mapOf(
        '(' to ')',
        '[' to ']',
        '{' to '}',
        '<' to '>'
    )

    fun isOpen(character: Char) = chunks.keys.contains(character)

    fun getCloseChunk(character: Char) = chunks[character]
}

sealed class AnalyzeResult {
    data class Corrupted(val value: Char, val expected: Char?) : AnalyzeResult() {
        fun score() = when (value) {
            ')' -> 3
            ']' -> 57
            '}' -> 1197
            '>' -> 25137
            else -> 0
        }
    }

    data class Uncompleted(private val completion: List<Char>) : AnalyzeResult() {
        fun score() = completion.fold(0L) { acc, next ->
            (acc * 5) + charScore(next)
        }

        private fun charScore(char: Char) = when (char) {
            ')' -> 1
            ']' -> 2
            '}' -> 3
            '>' -> 4
            else -> 0
        }
    }
}

class ChunksLine(private val line: String) {

    fun analyze(): AnalyzeResult {
        val stack = ArrayDeque<Char>()
        line.forEach { character ->
            if (Chunks.isOpen(character)) {
                stack.add(Chunks.getCloseChunk(character)!!)
            } else {
                val lastClose = stack.removeLastOrNull()
                if (lastClose != character) {
                    return AnalyzeResult.Corrupted(character, lastClose)
                }
            }
        }

        return AnalyzeResult.Uncompleted(stack.reversed())
    }

}

fun partOne(input: List<String>) = parseChunksLines(input).let { lines ->
    lines.map { it.analyze() }
        .filterIsInstance<AnalyzeResult.Corrupted>()
        .sumOf { it.score() }
}

fun partTwo(input: List<String>): Long = parseChunksLines(input)
    .map { it.analyze() }
    .filterIsInstance<AnalyzeResult.Uncompleted>()
    .map { it.score() }
    .sorted()
    .let { it[(it.size - 1) / 2] }

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part two: ${partTwo(input)}")

import java.io.File

fun readFile(name: String) = File(name).useLines { it.toList() }

fun parseEntries(input: List<String>) = input.map {
    with(it.split(" | ")) {
        Entry(
            get(0).trim().split(" "),
            get(1).trim().split(" ")
        )
    }
}

object UniqueDigits {
    val segmentsLengths = setOf(2, 3, 4, 7)

    val segmentsLengthToDigit = mapOf(
        2 to 1,
        3 to 7,
        4 to 4,
        7 to 8
    )
}

data class DigitPattern(private val pattern: String) {

    fun isValidDigit(output: String) = if (pattern.length == output.length) {
        pattern.toSortedSet() == output.toSortedSet()
    } else false
}

class Patterns(private val patterns: List<String>) {

    private val mapping = mutableMapOf<String, Int>()

    fun resolveMapping(): Map<DigitPattern, Int> {
        val uniqueDigitsPatterns = patterns.mapNotNull { pattern ->
            UniqueDigits.segmentsLengthToDigit[pattern.length]?.let { pattern to it }
        }.toMap()

        patterns.sortedByDescending { it.length }
            .filter { !uniqueDigitsPatterns.containsKey(it) }
            .forEach { applyPattern(uniqueDigitsPatterns, it) }

        return uniqueDigitsPatterns.plus(mapping).map { entry ->
            DigitPattern(entry.key) to entry.value
        }.toMap()
    }

    private fun applyPattern(uniqueDigitsPatterns: Map<String, Int>, pattern: String) {
        when (pattern.length) {
            6 -> applyPatternForLengthOf6(uniqueDigitsPatterns, pattern)
            5 -> applyPatternForLengthOf5(uniqueDigitsPatterns, pattern)
            else -> null
        }?.also { mapping[it.first] = it.second }
    }

    private fun applyPatternForLengthOf6(uniqueDigitsPatterns: Map<String, Int>, pattern: String) =
        when (uniqueDigitsPatterns.countDigitsIn(pattern)) {
            2 -> pattern to 0
            3 -> pattern to 9
            else -> pattern to 6
        }

    private fun applyPatternForLengthOf5(uniqueDigitsPatterns: Map<String, Int>, pattern: String) =
        when (uniqueDigitsPatterns.countDigitsIn(pattern)) {
            2 -> pattern to 3
            else -> {
                val patternForSix = mapping.filter { it.value == 6 }.map { it.key }.first()
                when (patternForSix.commonSegmentsWith(pattern)) {
                    6 -> pattern to 5
                    else -> pattern to 2
                }
            }
        }

    private fun Map<String, Int>.countDigitsIn(pattern: String) = pattern.toSet().let { patternChars ->
        keys.count { uniqueDigitPattern -> patternChars.containsAll(uniqueDigitPattern.toSet()) }
    }

    private fun String.commonSegmentsWith(pattern: String) = this.toSet().union(pattern.toSet()).size

}

class Entry(private val patterns: List<String>, private val output: List<String>) {

    fun countUniqueOutputDigits(): Int = output.filter { UniqueDigits.segmentsLengths.contains(it.length) }.size

    fun decodeOutputDigits(): String {
        val patterns = Patterns(patterns)
        val mapping = patterns.resolveMapping()
        return decodeDigits(mapping).joinToString("")
    }

    private fun decodeDigits(mapping: Map<DigitPattern, Int>) = output.flatMap { digit ->
        mapping.filter { it.key.isValidDigit(digit) }.map { it.value }
    }
}

fun partOne(input: List<String>): Int = parseEntries(input).sumOf { it.countUniqueOutputDigits() }

fun partTwo(input: List<String>): Int = parseEntries(input).sumOf { it.decodeOutputDigits().toInt() }

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part two: ${partTwo(input)}")

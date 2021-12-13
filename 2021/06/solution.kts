import java.io.File

fun readFile(name: String) = File(name).useLines { it.toList() }

fun catchFish(input: List<String>) = input[0].split(',').map { it.toInt() }

fun naiveGeneration(days: Int, day: Int, fish: List<Int>): List<Int> {
    if (day == days) {
        return fish
    }

    val newGeneration = fish.flatMap {
        if (it == 0) {
            listOf(6, 8)
        } else {
            if (it > 0) {
                listOf(it - 1)
            } else {
                listOf()
            }
        }
    }
    return naiveGeneration(days, day + 1, newGeneration)
}

fun generation(days: Int, fish: List<Int>): Long {
    val generation = mutableMapOf<Int, Long>()
    fish.forEach {
        generation[it] = (generation[it] ?: 0) + 1
    }

    repeat((0 until days).count()) {
        val lives = generation.keys
        val newGeneration = mutableMapOf<Int, Long>()
        lives.filter { it > 0 }.forEach { life ->
            newGeneration[life - 1] = generation[life]!!
        }
        generation[0]?.apply {
            newGeneration[6] = (newGeneration[6] ?: 0) + this
            newGeneration[8] = (newGeneration[8] ?: 0) + this
        }

        generation.clear()
        newGeneration.forEach {
            generation[it.key] = it.value
        }
    }

    return generation.values.sum()
}

fun partOne(input: List<String>): Long {
    val fish = catchFish(input)
    return generation(80, fish)
}

fun partTwo(input: List<String>): Long {
    val fish = catchFish(input)
    return generation(256, fish)
}

val input = readFile("input.txt")
println("Part one: ${partOne(input)}")
println("Part two: ${partTwo(input)}")



input = open('input.txt').read().splitlines()

class Hand:
    STRENGTHS = { '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, 'T': 10, 'J': 11, 'Q': 12, 'K':13, 'A': 14 }
    
    JOKER_SCORES = { 
        1: {0: 1, 1: 2}, 
        2: {0: 2, 1: 4, 2: 4}, 
        3: {0: 3, 1: 5, 2: 6}, 
        4: {0: 4, 1: 6, 2: 7, 3: 6}, 
        5: {0: 5, 2: 7, 3: 7},
        6: {0: 6, 1: 7, 4: 7}
    }

    def __init__(self, cards, bid, with_jokers = False):
        self.cards = cards
        self.bid = int(bid)
        self.with_jokers = with_jokers
        if self.with_jokers:
            self.jokers_count = len([card for card in self.cards if card == 'J'])
    
    def show_card(self, position):
        return self.cards[position]

    def calculate_strength(self):
        cards_sorted = sorted(self.cards, key=lambda card: Hand.STRENGTHS[card])
        cards_set = list(set(cards_sorted))
        
        if len(cards_set) == 1 and cards_set[0] == self.cards[0]:
            return 7 # Five of a kind

        if len(set(cards_sorted[:-1])) == 1 or len(set(cards_sorted[1::])) == 1:
            return self._calculate_type_strength(6) # Four of a kind
 
        if (len(set(cards_sorted[0:2])) == 1 and len(set(cards_sorted[2::])) == 1) or (len(set(cards_sorted[0:3])) == 1 and len(set(cards_sorted[3::])) == 1):
            return self._calculate_type_strength(5) # Full House
        
        if len(set(cards_sorted[0:3])) == 1 or len(set(cards_sorted[1:4])) == 1 or len(set(cards_sorted[2:5])) == 1:
            return self._calculate_type_strength(4) # Three of a kind

        if (len(set(cards_sorted[0:2])) == 1 and len(set(cards_sorted[2:4])) == 1) or (len(set(cards_sorted[1:3])) == 1 and len(set(cards_sorted[3:5])) == 1) or (len(set(cards_sorted[0:2])) == 1 and len(set(cards_sorted[3:5])) == 1):
            return self._calculate_type_strength(3) # Two pair
        
        if len(cards_set) < len(cards_sorted):
            return self._calculate_type_strength(2) # One pair
        
        return self._calculate_type_strength(1) # High card
    
    def _calculate_type_strength(self, type_strength):
        if self.with_jokers:
            return Hand.JOKER_SCORES[type_strength][self.jokers_count] 
        return type_strength
    
    def _get_card_strength(self, card):
        if self.with_jokers and card == 'J':
            return 0
        return Hand.STRENGTHS[card]
    
    def __lt__(self, other):
        self_rank = self.calculate_strength()
        other_rank = other.calculate_strength()

        if self_rank == other_rank:
            card_pos = 0
            while card_pos < 5:
                self_card_strength = self._get_card_strength(self.show_card(card_pos))
                other_card_strength = self._get_card_strength(other.show_card(card_pos))
                if self_card_strength != other_card_strength:
                    return self_card_strength > other_card_strength
                card_pos += 1
            return 0
        else:
            return self_rank > other_rank
        
    def __str__(self): 
        return f'{self.cards} {self.bid}'
    
    def __repr__(self): 
        return self.__str__()

def calculate_total_winnings(input, with_jokers):
    hands = [Hand(line.split(' ')[0], line.split(' ')[1], with_jokers) for line in input]
    hands.sort()
    hands_count = len(hands)
    total_winnings = 0
    for index, hand in enumerate(hands):
        total_winnings += hand.bid * (hands_count - index)
    return total_winnings

print(f'Part one: {calculate_total_winnings(input, False)}')
print(f'Part two: {calculate_total_winnings(input, True)}')
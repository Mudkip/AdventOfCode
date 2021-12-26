<?php

class Room {
    private string $type;
    private array $occupants = [];
    private int $exit;

    function __construct(string $type, array $occupants, int $exit) {
        $this->type = $type;
        $this->exit = $exit;
        foreach($occupants as $occupant) {
            if($occupant === null) $this->occupants[] = null;
            else {
                $amphipods = new Amphipods($occupant, $type);
                $this->occupants[] =  $amphipods;
            }
        }
    }

    function type(): string {
        return $this->type;
    }

    function full(): bool {
        foreach($this->occupants as $occupant) {
            if($occupant === null) return false;
        }
        return true;
    }

    function occupants(): array {
        return $this->occupants;
    }

    function setOccupant(int $index, ?Amphipods $occupant) {
        $this->occupants[$index] = $occupant;
    }

    function exit(): int {
        return $this->exit;
    }
}

class Amphipods {
    private string $type;
    private string $location;
    private int $moveCost;
    
    function __construct(string $type, string $location) {
        $this->type = $type;
        $this->location = $location;
        $this->moveCost = match($type) {
            "A" => 1,
            "B" => 10,
            "C" => 100,
            "D" => 1000
        };
    }

    function setLocation(string $location) {
        $this->location = $location;
    }

    function location(): string {
        return $this->location;
    }

    function type(): string {
        return $this->type;
    }

    function moveCost(): int {
        return $this->moveCost;
    }
}

class Simulation {
    private array $rooms;
    private array $amphipods = [];
    private int $cost = 0;
    private ?array $last_move = null;
    # Can only move within hall bounds and into rooms, cannot stop in front of room exits.
    private array $legalMoves = ['A', 'B', 'C', 'D', 0, 1, 3, 5, 7, 9, 10];

    function __construct(array $rooms) {
        $this->rooms = $rooms;
        foreach($this->rooms as $room) {
            foreach($room->occupants() as $occupant) {
                if($occupant === null) continue;
                $this->amphipods[] = $occupant;
            }
        }   
    } 
    
    static function fromHash(string $hash, int $roomCount) {
        $simulation = new Simulation([
            'A' => new Room('A', array_fill(0, $roomCount, null), 2),
            'B' => new Room('B', array_fill(0, $roomCount, null), 4),
            'C' => new Room('C', array_fill(0, $roomCount, null), 6),
            'D' => new Room('D', array_fill(0, $roomCount, null), 8)
        ]);

        [$cost, $hash] = explode(":", $hash);
        $positions = explode("_", $hash);
        foreach($positions as $position) {
            $split = str_split($position);
            if(count($split) === 3) {
                [$type, $location, $pos] = $split;
                if(is_numeric($location)) {
                    $location = $location.$pos;
                    $pos = null;
                }
            } else {
                [$type, $location] = $split;
                $pos = null;
            }
            $amphipod = new Amphipods($type, $location);
            $simulation->amphipods[] = $amphipod;
            if($pos !== null) {
                $simulation->rooms[$location]->setOccupant($pos, $amphipod);
            }
        }
        $simulation->cost = $cost;
        return $simulation;
    }

    function canMove(Amphipods $amphipods, string $destination) {
        # Only legal moves
        if(!in_array($destination, $this->legalMoves)) return false;
        # No move to same spot
        if($amphipods->location() == $destination) return false;

        # Moving into the hall
        if(is_numeric($destination)) {
            # Can only move from a room
            if(is_numeric($amphipods->location())) return false;

            $currentRoom = $this->rooms[$amphipods->location()];
            $currentRoomOccupants = $currentRoom->occupants();
            # If room is already full with correct amphipods or amphipods already in correct please
            if($currentRoom->type() == $amphipods->type()) {
                $allSame = true;
                foreach($currentRoomOccupants as $k => $occupant) {
                    if($occupant === null) continue;
                    if($occupant->type() !== $amphipods->type()) {
                        $allSame = false;
                        break;
                    }
                }
                if($allSame) return false;
            }

            # Cannot pass through other amphipods in room
            $firstFound = null;
            foreach($currentRoomOccupants as $k => $occupant) {
                if($occupant === null) continue;
                $firstFound = $occupant;
                break;
            }
            if($firstFound !== $amphipods) return false;
        } # Moving into a room
        else {
            $room = $this->rooms[$destination];

            if(!is_numeric($amphipods->location())) {
                $currentRoom = $this->rooms[$amphipods->location()];
                $currentRoomOccupants = $currentRoom->occupants();
                # Cannot pass through other amphipods in room
                $firstFound = null;
                foreach($currentRoomOccupants as $k => $occupant) {
                    if($occupant === null) continue;
                    $firstFound = $occupant;
                    break;
                }
                if($firstFound !== $amphipods) return false;
            } 

            # Can only move into its own room type
            if($amphipods->type() !== $room->type()) return false;
            # Can only move into a non-full room
            if($room->full()) return false;
            # If room has an occupant, can only move to room if occupant is same type
            foreach($room->occupants() as $occupant) {
                if($occupant === null) continue;
                if($occupant->type() !== $amphipods->type()) return false;
            }
        }

        # Cannot walk past other amphipods in hall.
        $destIndex = is_numeric($destination) ? $destination : $this->rooms[$destination]->exit();
        $locIndex  = is_numeric($amphipods->location()) ? $amphipods->location() : $this->rooms[$amphipods->location()]->exit();
        $path = range($locIndex, $destIndex);
        foreach($this->amphipods as $other) {
            if($amphipods === $other) continue;
            if(in_array($other->location(), $path)) return false;
        }

        return true;
    }

    function calculateCost(Amphipods $amphipods, string $destination): int {
        $moveCost = $amphipods->moveCost();
        $start = $amphipods->location();
        $end = $destination;
        $path = 0;
        if(!is_numeric($destination)) {
            $room = $this->rooms[$end];
            $end = $room->exit();
            $firstNotNull = count($room->occupants());
            foreach(range(count($room->occupants()) -1, 0) as $k) {
                if($room->occupants()[$k] !== null) {
                    $firstNotNull = $k;
                }
            }
            $path += $firstNotNull;
        }
        if(!is_numeric($start)) {
            $room = $this->rooms[$start];
            $start = $room->exit();
            $index = array_search($amphipods, $room->occupants(), true);
            $path += $index + 1;
        }
        $start = $start > $end ? $start - 1 : $start + 1;
        $path += count(range($start, $end));
        return $path * $moveCost;
    }

    function move(int $index, string $destination) {
        $amphipods = $this->amphipods($index);
        if($this->canMove($amphipods, $destination)) {
            $cost = $this->calculateCost($amphipods, $destination);
            $this->cost += $cost;
            if(!is_numeric($amphipods->location())) {
                $room = $this->rooms[$amphipods->location()];
                foreach($room->occupants() as $k => $occupant) {
                    if($amphipods === $occupant) {
                        $occupantIndex = $k;
                        break;
                    }
                }
                $room->setOccupant($occupantIndex, null);
            }
            if(!is_numeric($destination)) {
                $room = $this->rooms[$destination];
                foreach($room->occupants() as $k => $occupant) {
                    if($occupant !== null) break;
                    $destOccupantIndex = $k;
                }
                $room->setOccupant($destOccupantIndex, $amphipods);
            }
            $this->last_move = [$index, $amphipods->location(), $cost];
            $amphipods->setLocation($destination);
            return true;
        }
        return false;
    }

    function undoMove(): void {
        if($this->last_move === null) return;
        [$i, $to, $cost] = $this->last_move;
        $amphipods = $this->amphipods($i);

        $this->cost -= $cost;

        if(!is_numeric($amphipods->location())) {
            $room = $this->rooms[$amphipods->location()];
            foreach($room->occupants() as $k => $occupant) {
                if($amphipods === $occupant) {
                    $occupantIndex = $k;
                    break;
                }
            }
            $room->setOccupant($occupantIndex, null);
        }

        if(!is_numeric($to)) {
            $room = $this->rooms[$to];
            foreach($room->occupants() as $k => $occupant) {
                if($occupant !== null) break;
                $destOccupantIndex = $k;
            }
            $room->setOccupant($destOccupantIndex, $amphipods);
        }

        $this->last_move = null;
        $amphipods->setLocation($to);
    }

    function amphipods(int $i): Amphipods {
        return $this->amphipods[$i];
    }

    function hash(): string {
        $locations = [];
        foreach($this->amphipods as $amphipods) {
            if(!is_numeric($amphipods->location())) {
                $occupantIndex = array_search($amphipods, $this->rooms[$amphipods->location()]->occupants(), true);
                $locations[] =  $amphipods->type() . $amphipods->location() . $occupantIndex;
            }
            else $locations[] = $amphipods->type() . $amphipods->location();
        }
        asort($locations);
        return $this->cost . ":" . implode("_", $locations);
    }
}

function simulate(string $start, string $goal, int $room_count): int {
    $states = [$start => 0];
    $cache = [];

    while(count($states) !== 0) {
        foreach($states as $hash => $cost) {
            unset($states[$hash]);
            $fake = Simulation::fromHash($cost . ":" . $hash, $room_count);
            for($i = 0; $i < ($room_count * 4); $i++) {
                foreach(['A', 'B', 'C', 'D', 0, 1, 3, 5, 7, 9, 10] as $move) {
                    if($fake->move($i, $move)) {
                        [$ncost, $nhash] = explode(":", $fake->hash());
                        $fake->undoMove();
                        if(($cache[$nhash] ?? INF) <= $ncost) continue;        
                        if(($cache[$goal] ?? INF) <= $ncost) continue;     
                        $cache[$nhash] = $states[$nhash] = $ncost;
                    }   
                } 
            }
        }
    }
    return $cache[$goal];
}

function solve(string $start): int {
    $start_split = explode("_", $start);
    $per_room = count($start_split) / 4;
    $goal = "";
    foreach(range("A", "D") as $letter) {
        for($i = 0; $i < $per_room; $i++) {
            $goal .= $letter . $letter . $i . ($letter !== "D" || $i !== ($per_room - 1) ? "_" : "");
        }
    }
    $cache = [];
    $states = [$start => 0];
    return simulate($start, $goal, $per_room);


}

echo "Part 1: " . solve("BA0_DA1_CB0_DB1_CC0_AC1_BD0_AD1") . PHP_EOL; 
echo "Part 2: " . solve("BA0_DA1_DA2_DA3_CB0_CB1_BB2_DB3_CC0_BC1_AC2_AC3_BD0_AD1_CD2_AD3") . PHP_EOL;

